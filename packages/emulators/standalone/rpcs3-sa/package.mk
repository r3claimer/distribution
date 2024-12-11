# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2024 ROCKNIX (https://github.com/ROCKNIX)

PKG_NAME="rpcs3-sa"
PKG_VERSION="68b7e5971d8e279d7d385b96b5aa2feebd220506"
PKG_SITE="https://rpcs3.net"
PKG_URL="https://github.com/RPCS3/rpcs3.git"
PKG_LICENSE="GPLv3"
PKG_DEPENDS_TARGET="toolchain linux glibc systemd pulseaudio mesa xwayland libevdev curl ffmpeg libpng zlib glew-cmake libSM SDL2 enet qt6 libp11-kit yamlcpp openal-soft soundtouch llvm"
PKG_LONGDESC="PS3 Emulator appimage"

if [ "${OPENGL_SUPPORT}" = "yes" ]; then
  PKG_DEPENDS_TARGET+=" ${OPENGL} glu libglvnd"
fi

if [ "${VULKAN_SUPPORT}" = "yes" ]; then
  PKG_DEPENDS_TARGET+=" vulkan-loader vulkan-headers"
  PKG_CMAKE_OPTS_TARGET+=" -DUSE_VULKAN=ON"
else
  PKG_CMAKE_OPTS_TARGET+=" -DUSE_VULKAN=OFF"
fi

pre_configure_target() {
  PKG_CMAKE_OPTS_TARGET+=" -DCMAKE_BUILD_TYPE=Release \
                           -DCMAKE_CROSSCOMPILING=ON \
                           -DBUILD_SHARED_LIBS=OFF \
                           -DUSE_NATIVE_INSTRUCTIONS=OFF \
                           -DUSE_PRECOMPILED_HEADERS=OFF \
                           -DSTATIC_LINK_LLVM=OFF \
                           -DUSE_SYSTEM_FFMPEG=ON \
                           -DUSE_SYSTEM_CURL=ON \
                           -DUSE_SYSTEM_LIBUSB=ON \
                           -DUSE_LIBEVDEV=ON \
                           -DUSE_SYSTEM_FAUDIO=OFF \
                           -DUSE_SYSTEM_SDL=ON"
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/bin
  mkdir -p ${INSTALL}/usr/config/rpcs3
  cp -rf ${PKG_BUILD}/.${TARGET_NAME}/bin/rpcs3 ${INSTALL}/usr/bin
  cp ${PKG_DIR}/scripts/* ${INSTALL}/usr/bin
  cp -r ${PKG_DIR}/config/${DEVICE}/* ${INSTALL}/usr/config/rpcs3
  chmod +x ${INSTALL}/usr/bin/*
}
