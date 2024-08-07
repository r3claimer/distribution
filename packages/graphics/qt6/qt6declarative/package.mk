# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2024-present ROCKNIX (https://github.com/ROCKNIX)

PKG_NAME="qt6declarative"
PKG_MAJOR_VERSION="6.6"
PKG_VERSION="${PKG_MAJOR_VERSION}.3"
PKG_LICENSE="GPLv3"
PKG_SITE="https://download.qt.io"
PKG_URL="${PKG_SITE}/archive/qt/${PKG_MAJOR_VERSION}/${PKG_VERSION}/submodules/qtdeclarative-everywhere-src-${PKG_VERSION}.tar.xz"
PKG_DEPENDS_HOST="toolchain:host qt6base"
PKG_DEPENDS_TARGET="toolchain qt6declarative:host qt6base"
PKG_LONGDESC="QT6 Tools package"

pre_configure_host() {
 PKG_CMAKE_OPTS_HOST+="		-GNinja \
				-DQT_HOST_PATH=${PKG_BUILD}/.x86_64-linux-gnu \
				-DQt6HostInfo_DIR=${PKG_BUILD}/../qt6base-6.6.3/.x86_64-linux-gnu/lib/cmake/Qt6HostInfo \
				-DBUILD_WITH_PCH=OFF \
				-DQT_BUILD_TESTS=ON \
				-DQT_BUILD_MANUAL_TESTS=ON \
				-DCMAKE_CROSSCOMPILING=OFF \
				-DQT_BUILD_MINIMAL_STATIC_TESTS=ON"
}

pre_configure_target() {
  PKG_CMAKE_OPTS_TARGET+="	-GNinja \
				-DQT_HOST_PATH=${PKG_BUILD}/.x86_64-linux-gnu \
				-DQt6BuildInternals_DIR=${PKG_BUILD}/../qt6base-6.6.3/.x86_64-linux-gnu/lib/cmake/Qt6BuildInternals \
				-DQt6Core_DIR=${PKG_BUILD}/../qt6base-6.6.3/.x86_64-linux-gnu/lib/cmake/Qt6Core \
				-DQt6CoreTools_DIR=${PKG_BUILD}/../qt6base-6.6.3/.x86_64-linux-gnu/lib/cmake/Qt6CoreTools \
				-DQt6_DIR=${PKG_BUILD}/../qt6base-6.6.3/.x86_64-linux-gnu/lib/cmake/Qt6 \
				-DBUILD_WITH_PCH=OFF \
				-DQT_BUILD_EXAMPLES=OFF
				-DQT_BUILD_TESTS=OFF \
				-DQT_BUILD_TESTS_BY_DEFAULT=OFF \
				-DQT_BUILD_EXAMPLES_BY_DEFAULT=OFF"
}

make_host() {
  ninja ${NINJA_OPTS}
}
