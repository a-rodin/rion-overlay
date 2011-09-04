# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit eutils multilib toolchain-funcs

DESCRIPTION="A library to verify and create signatures of e-mail headers."
HOMEPAGE="http://libdkim.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.zip"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-libs/openssl
	app-arch/unzip"
RDEPEND="!mail-filter/libdkim-exim
	dev-libs/openssl"

S=${WORKDIR}/${PN}/src

src_prepare() {
	ecvs_clean
	# upstream claims to be portable, but isn't very
	epatch "${FILESDIR}/${PN}-gentoo.patch" || die "epatch failed"
	epatch "${FILESDIR}/${PN}-extra-options.patch" ||  die "epatch failed"
}

src_compile() {
	tc-export AR CC CPP CXX RANLIB
	export LIBDIR=$(get_libdir)
	emake
}

src_install() {
	emake DESTDIR="${ED}" install || die "emake install failed"
	dodoc ../README || die "Install README failed"
}
