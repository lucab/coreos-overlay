# Copyright (c) 2018 CoreOS.
# Distributed under the terms of the Apache 2.0 license.

EAPI=5
CROS_WORKON_PROJECT="lucab/coreos-cryptagent"
CROS_WORKON_LOCALNAME="coreos-cryptagent"
CROS_WORKON_REPO="git://gitlab.com"
COREOS_GO_PACKAGE="gitlab.com/lucab/coreos-cryptagent"
inherit coreos-go cros-workon

if [[ "${PV}" == 9999 ]]; then
	KEYWORDS="~amd64 ~arm64"
else
#	CROS_WORKON_COMMIT="35d7372a332b5239fe0f52b59888d9181c06ff81"
	CROS_WORKON_COMMIT="HEAD"
	KEYWORDS="amd64 arm64"
fi

DESCRIPTION="coreos-cryptagent"
HOMEPAGE="https://gitlab.com/lucab/coreos-cryptagent"
SRC_URI=""

LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

src_compile() {
        go_build "${COREOS_GO_PACKAGE}"
}

src_install() {
        exeinto /usr/lib/coreos
        doexe "${GOBIN}"/coreos-cryptagent
}
