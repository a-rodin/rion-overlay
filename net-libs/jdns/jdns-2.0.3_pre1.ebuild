# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit git-r3 cmake-utils multibuild

DESCRIPTION="JDNS is a simple DNS implementation library"
HOMEPAGE="https://github.com/psi-im/jdns"

EGIT_COMMIT="ae2e7264e8458d64932590bdde2417605946cb8a"
EGIT_REPO_URI="https://github.com/psi-im/jdns.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="qt4 qt5 tools"

DEPEND="
	qt4? ( dev-qt/qtcore:4 )
	qt5? ( dev-qt/qtnetwork:5 )
"
RDEPEND="${DEPEND}"

pkg_setup() {
	MULTIBUILD_VARIANTS=( $(usev qt4) $(usev qt5) )
}

src_configure() {
	if [[ -z "${MULTIBUILD_VARIANTS[@]}" ]]; then
		local mycmakeargs=( -DBUILD_QJDNS=OFF
			$(cmake-utils_use_build tools JDNS_TOOL) )
		cmake-utils_src_configure
	else
		myconfigure() {
			local mycmakeargs=( -DMULTI_QT=ON -DBUILD_QJDNS=ON
				$(cmake-utils_use_build tools JDNS_TOOL) )

			[[ ${MULTIBUILD_VARIANT} == qt4 ]] && mycmakeargs+=( -DQT4_BUILD=ON )

			cmake-utils_src_configure
		}
		multibuild_foreach_variant myconfigure
	fi
}

src_compile() {
	if [[ -z "${MULTIBUILD_VARIANTS[@]}" ]]; then
		cmake-utils_src_compile
	else
		multibuild_foreach_variant cmake-utils_src_compile
	fi
}

src_install() {
	if [[ -z "${MULTIBUILD_VARIANTS[@]}" ]]; then
		cmake-utils_src_install
	else
		multibuild_foreach_variant cmake-utils_src_install
	fi
}