# Copyright (c) 2017 CoreOS, Inc.. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CROS_WORKON_PROJECT="personal/cryptsetup-agent"
CROS_WORKON_LOCALNAME="cryptsetup-agent"
CROS_WORKON_REPO="git://gitlab.com"

#CROS_WORKON_REPO="git://github.com"
#CROS_WORKON_PROJECT="coreos/cryptsetup-agent"

if [[ ${PV} == 9999 ]]; then
	KEYWORDS="~amd64 ~arm64"
else
	CROS_WORKON_COMMIT="HEAD" # v0.1.0
	KEYWORDS="amd64 arm64"
fi

inherit coreos-cargo cros-workon systemd

DESCRIPTION="A tool for collecting instance metadata from various providers"
HOMEPAGE="https://gitlab.com/lucab/cryptsetup-agent"
LICENSE="Apache-2.0"
SLOT="0"

src_unpack() {
	cros-workon_src_unpack "$@"
	coreos-cargo_src_unpack "$@"
	unpack hashicorp_vault-0.6.1.tar.gz
}

src_prepare() {
	default

	# check to make sure we are using the right version of update-ssh-keys
	# our Cargo.toml should be using this version string as a tag specifier
#	grep -q "^update-ssh-keys.*tag.*${UPDATE_SSH_KEYS_VERSION}" Cargo.toml || die "couldn't find update-ssh-keys version ${UPDATE_SSH_KEYS_VERSION} in Cargo.toml"

	sed -i "s;^hashicorp_vault.*;hashicorp_vault = { path = \"${WORKDIR}/vault-rs-0af09ceb31814db7d61d773e22f9aa4bf9c97c1a\" };" Cargo.toml

	# tell the rust-openssl bindings where the openssl library and include dirs are
	export PKG_CONFIG_ALLOW_CROSS=1
	export OPENSSL_LIB_DIR=/usr/lib64/
	export OPENSSL_INCLUDE_DIR=/usr/include/openssl/
}

src_install() {
	cargo_src_install
}

# sed -n 's/^"checksum \([^ ]*\) \([^ ]*\) .*/\1-\2/p' Cargo.lock
CRATES="
adler32-1.0.2
advapi32-sys-0.2.0
ansi_term-0.9.0
atty-0.2.3
base64-0.6.0
base64-0.7.0
bitflags-0.7.0
bitflags-0.9.1
bitflags-1.0.1
build_const-0.2.0
byteorder-1.1.0
bytes-0.4.5
cc-1.0.3
cfg-if-0.1.2
chrono-0.4.0
clap-2.27.1
core-foundation-0.2.3
core-foundation-sys-0.2.3
crc-1.6.0
crossbeam-0.2.10
crypt32-sys-0.2.0
dtoa-0.4.2
error-chain-0.11.0
foreign-types-0.2.0
fuchsia-zircon-0.2.1
fuchsia-zircon-sys-0.2.0
futures-0.1.17
futures-cpupool-0.1.7
glob-0.2.11
hashicorp_vault-0.6.1
httparse-1.2.3
hyper-0.11.7
hyper-tls-0.1.2
idna-0.1.4
inotify-0.5.0
inotify-sys-0.1.1
iovec-0.1.1
isatty-0.1.5
itoa-0.3.4
kernel32-sys-0.2.2
language-tags-0.2.2
lazy_static-0.2.11
lazycell-0.5.1
libc-0.2.33
libflate-0.1.12
log-0.3.8
matches-0.1.6
mime-0.3.5
mime_guess-2.0.0-alpha.2
mio-0.6.11
miow-0.2.1
native-tls-0.1.4
net2-0.2.31
num-0.1.40
num-integer-0.1.35
num-iter-0.1.34
num-traits-0.1.40
num_cpus-1.7.0
openssl-0.9.21
openssl-sys-0.9.21
percent-encoding-1.0.1
phf-0.7.21
phf_codegen-0.7.21
phf_generator-0.7.21
phf_shared-0.7.21
pkg-config-0.3.9
quick-error-1.2.1
quote-0.3.15
rand-0.3.18
redox_syscall-0.1.31
redox_termios-0.1.1
relay-0.1.0
reqwest-0.8.1
result-1.0.0
rust-ini-0.10.0
safemem-0.2.0
schannel-0.1.8
scoped-tls-0.1.0
secur32-sys-0.2.0
security-framework-0.1.16
security-framework-sys-0.1.16
serde-1.0.21
serde_derive-1.0.21
serde_derive_internals-0.17.0
serde_ini-0.1.0
serde_json-1.0.6
serde_urlencoded-0.5.1
siphasher-0.2.2
slab-0.3.0
slab-0.4.0
slog-2.0.12
slog-async-2.1.0
slog-scope-4.0.0
slog-term-2.3.0
smallvec-0.2.1
strsim-0.6.0
syn-0.11.11
synom-0.11.3
take-0.1.0
take_mut-0.1.3
tempdir-0.3.5
term-0.4.6
termion-1.5.1
textwrap-0.9.0
thread_local-0.3.4
time-0.1.38
tokio-core-0.1.10
tokio-io-0.1.4
tokio-proto-0.1.1
tokio-service-0.1.0
tokio-tls-0.1.3
unicase-1.4.2
unicase-2.1.0
unicode-bidi-0.3.4
unicode-normalization-0.1.5
unicode-width-0.1.4
unicode-xid-0.0.4
unreachable-1.0.0
url-1.6.0
uuid-0.5.1
vcpkg-0.2.2
vec_map-0.8.0
version_check-0.1.3
void-1.0.2
winapi-0.2.8
winapi-build-0.1.1
ws2_32-sys-0.2.1
"

# not listed:
# hashicorp_vault-0.6.1

SRC_URI="$(cargo_crate_uris ${CRATES})
https://github.com/lucab/vault-rs/archive/0af09ceb31814db7d61d773e22f9aa4bf9c97c1a.tar.gz -> hashicorp_vault-0.6.1.tar.gz
"
