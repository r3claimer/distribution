# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2026-present ROCKNIX (https://github.com/ROCKNIX)

PKG_NAME="eka2l1-qt"
PKG_VERSION="e67f84dc605ea30afc1ab6f4f43c0f855eec79a5"
PKG_ARCH="aarch64"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/EKA2L1/EKA2L1"
PKG_URL="${PKG_SITE}.git"
PKG_GIT_CLONE_BRANCH="master"
PKG_GIT_SUBMODULES="yes"
PKG_DEPENDS_TARGET="toolchain SDL2 freetype zlib"
PKG_SECTION="emuelec/emulators"
PKG_SHORTDESC="Symbian OS / N-Gage emulator for aarch64 Linux"
PKG_TOOLCHAIN="cmake"
PKG_BUILD_FLAGS="-lto"

PKG_CMAKE_OPTS_TARGET="
  -DCMAKE_BUILD_TYPE=Release
  -DEKA2L1_BUILD_TESTS=OFF
-DEKA2L1_BUILD_VULKAN_BACKEND=ON
"

makeinstall_target() {
#  BUILD_DIR="${PKG_BUILD}/.aarch64-rocknix-linux-gnu"

  mkdir -p "${INSTALL}/usr/bin/"
#  cp -a "${BUILD_DIR}/bin/." "${INSTALL}/usr/bin/eka2l1/"
#  chmod +x "${INSTALL}/usr/bin/eka2l1/eka2l1_sdl2"

#  cp "${PKG_DIR}/scripts/ekastart.sh" "${INSTALL}/usr/bin/ekastart.sh"
#  chmod +x "${INSTALL}/usr/bin/ekastart.sh"

#  mkdir -p "${INSTALL}/usr/config/emuelec/configs/eka2l1/gptk"
#  cp -f "${PKG_DIR}/config/eka.gptk" "${INSTALL}/usr/config/emuelec/configs/eka2l1/gptk/eka.gptk"
}
