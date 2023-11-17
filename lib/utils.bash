#!/usr/bin/env bash

set -euo pipefail

# GitHub homepage where releases can be downloaded for etcd.
GH_REPO="https://github.com/etcd-io/etcd"
GH_DOWNLOAD_URL="$GH_REPO/releases/download"
TOOL_NAME="etcd"
TOOL_TEST="etcdctl version"

fail() {
	echo -e "asdf-$TOOL_NAME: $*"
	exit 1
}

curl_opts=(-fsSL)

if [ -n "${GITHUB_API_TOKEN:-}" ]; then
	curl_opts=("${curl_opts[@]}" -H "Authorization: token $GITHUB_API_TOKEN")
fi

sort_versions() {
	sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
		LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

list_github_tags() {
	git ls-remote --tags --refs "$GH_REPO" |
		grep -o 'refs/tags/.*' | cut -d/ -f3- |
		sed 's/^v//'
}

list_all_versions() {
	list_github_tags
}

download_release() {
	local version filename url os_name file_ext
	version="$1"
	filename="$2"
	os_name="$(get_os)"
	file_ext="$([[ "$os_name" == "darwin" ]] && echo "zip" || echo "tar.gz")"

	release_file="$ASDF_DOWNLOAD_PATH/$TOOL_NAME-v$ASDF_INSTALL_VERSION-${os_name}-$(get_arch).${file_ext}"
	url="$GH_DOWNLOAD_URL/v${version}/${TOOL_NAME}-v${version}-$(get_os)-$(get_arch).${file_ext}"
	export release_file

	echo "* Downloading $TOOL_NAME release $version..."
	curl "${curl_opts[@]}" -o "$filename" -C - "$url" || fail "Could not download $url"
}

install_version() {
	local install_type="$1"
	local version="$2"
	local install_path="${3%/bin}/bin"

	if [ "$install_type" != "version" ]; then
		fail "asdf-$TOOL_NAME supports release installs only"
	fi

	(
		mkdir -p "$install_path"
		cp -r "$ASDF_DOWNLOAD_PATH"/* "$install_path"

		local tool_cmd
		tool_cmd="$(echo "$TOOL_TEST" | cut -d' ' -f1)"
		test -x "$install_path/$tool_cmd" || chmod +x "$install_path/$tool_cmd"
		# test -x "$install_path/$tool_cmd" || fail "Expected $install_path/$tool_cmd to be executable."

		echo "$TOOL_NAME $version installation was successful!"
	) || (
		rm -rf "$install_path"
		fail "An error occurred while installing $TOOL_NAME $version."
	)
}

get_os() {
	local os
	os="$(uname)"

	echo "$os" | tr '[:upper:]' '[:lower:]'
}

get_arch() {
	local arch
	arch="$(uname -m)"

	case $arch in
	x86_64)
		echo amd64
		;;
	*)
		echo "$arch"
		;;
	esac
}
