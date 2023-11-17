<div align="center">

# asdf-etcd [![Build](https://github.com/particledecay/asdf-etcd/actions/workflows/build.yml/badge.svg)](https://github.com/particledecay/asdf-etcd/actions/workflows/build.yml) [![Lint](https://github.com/particledecay/asdf-etcd/actions/workflows/lint.yml/badge.svg)](https://github.com/particledecay/asdf-etcd/actions/workflows/lint.yml)

[etcd](https://github.com/etcd-io/etcd) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Contents

- [Dependencies](#dependencies)
- [Install](#install)
- [Contributing](#contributing)
- [License](#license)

# Dependencies

- `bash`, `curl`, `tar`, and [POSIX utilities](https://pubs.opengroup.org/onlinepubs/9699919799/idx/utilities.html).

# Install

Plugin:

```shell
asdf plugin add etcd
# or
asdf plugin add etcd https://github.com/particledecay/asdf-etcd.git
```

etcd:

```shell
# Show all installable versions
asdf list-all etcd

# Install specific version
asdf install etcd latest

# Set a version globally (on your ~/.tool-versions file)
asdf global etcd latest

# Now etcd commands are available
etcdctl version
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/particledecay/asdf-etcd/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [Joey Espinosa](https://github.com/particledecay/)
