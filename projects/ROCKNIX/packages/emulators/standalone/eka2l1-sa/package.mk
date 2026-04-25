# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2026-present ROCKNIX (https://github.com/ROCKNIX)

PKG_NAME="eka2l1-sa"
PKG_VERSION="d2e7abb191bf41ffa1413100154590e0930aebfa"
PKG_ARCH="aarch64"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/AveyondFly/EKA2L1"
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
  -DEKA2L1_BUILD_SDL2_FRONTEND=ON
-DEKA2L1_BUILD_VULKAN_BACKEND=ON
"

pre_configure_target() {
  sed -i '/add_subdirectory(qt)/d' ${PKG_BUILD}/src/emu/CMakeLists.txt
  sed -i '/target_include_directories(buildvm/d' ${PKG_BUILD}/src/external/CMakeLists.txt
  sed -i '/add_subdirectory(programs)/d' ${PKG_BUILD}/src/external/mbedtls/CMakeLists.txt
  sed -i '/add_subdirectory(tests)/d' ${PKG_BUILD}/src/external/mbedtls/CMakeLists.txt
#  echo "// stub" > ${PKG_BUILD}/src/emu/drivers/src/graphics/backend/context_glx.cpp
  echo "// stub" > ${PKG_BUILD}/src/emu/drivers/src/graphics/backend/vulkan/graphics_vulkan.cpp

  cat > ${PKG_BUILD}/src/external/ffmpeg/CMakeLists.txt << 'EOF'
if (NOT DEFINED FFMPEG_CORE_NAME)
    set(FFMPEG_CORE_NAME ffmpeg)
endif()
add_library(${FFMPEG_CORE_NAME} INTERFACE)
target_include_directories(${FFMPEG_CORE_NAME} INTERFACE "${CMAKE_CURRENT_SOURCE_DIR}/include")
target_link_libraries(${FFMPEG_CORE_NAME} INTERFACE avformat avcodec avutil swscale swresample z)
EOF
}

make_target() {
  BUILD_DIR="${PKG_BUILD}/.aarch64-rocknix-linux-gnu"
  LUAJIT_SRC="${PKG_BUILD}/src/external/luajit/src"
  LUAJIT_CMAKE_BUILD="${BUILD_DIR}/src/external/luajit-cmake"
  MINILUA_BIN="${LUAJIT_CMAKE_BUILD}/minilua/minilua"
  BUILDVM_BIN="${LUAJIT_CMAKE_BUILD}/buildvm/buildvm"

  cd "${BUILD_DIR}"

  ninja minilua || true
  gcc "${LUAJIT_SRC}/host/minilua.c" -o "${MINILUA_BIN}" -lm
  ninja -t restat

  ninja buildvm || true
  gcc \
    -I"${LUAJIT_SRC}" \
    -I"${LUAJIT_CMAKE_BUILD}" \
    -DLUAJIT_TARGET=LUAJIT_ARCH_arm64 \
    -DLJ_ARCH_HASFPU=1 \
    -DLJ_ABI_SOFTFP=0 \
    -DLUAJIT_NUMMODE=2 \
    "${LUAJIT_SRC}/host/buildvm.c" \
    "${LUAJIT_SRC}/host/buildvm_asm.c" \
    "${LUAJIT_SRC}/host/buildvm_fold.c" \
    "${LUAJIT_SRC}/host/buildvm_lib.c" \
    "${LUAJIT_SRC}/host/buildvm_peobj.c" \
    -o "${BUILDVM_BIN}" -lm
  ninja -t restat

  ninja ${NINJA_OPTS} ${PKG_MAKE_OPTS_TARGET}
}

makeinstall_target() {
  BUILD_DIR="${PKG_BUILD}/.aarch64-rocknix-linux-gnu"

  mkdir -p "${INSTALL}/usr/bin/"
#  cp -a "${BUILD_DIR}/bin/." "${INSTALL}/usr/bin/eka2l1/"
#  chmod +x "${INSTALL}/usr/bin/eka2l1/eka2l1_sdl2"

#  cp "${PKG_DIR}/scripts/ekastart.sh" "${INSTALL}/usr/bin/ekastart.sh"
#  chmod +x "${INSTALL}/usr/bin/ekastart.sh"

#  mkdir -p "${INSTALL}/usr/config/emuelec/configs/eka2l1/gptk"
#  cp -f "${PKG_DIR}/config/eka.gptk" "${INSTALL}/usr/config/emuelec/configs/eka2l1/gptk/eka.gptk"
}
