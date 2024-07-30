PKG_NAME="mali-midgard"
PKG_VERSION="2c2accf67356463ee661627b8705429256011dcb"
PKG_LICENSE="GPL"
PKG_SITE="https://developer.arm.com/downloads/-/mali-drivers/midgard-kernel"
PKG_URL="https://github.com/LibreELEC/mali-midgard/archive/${PKG_VERSION}.zip"
PKG_LONGDESC="mali-midgard: Linux drivers for Mali Midgard GPUs"
PKG_ARCH="aarch64"
PKG_DEPENDS_TARGET="toolchain linux"
PKG_NEED_UNPACK="${LINUX_DEPENDS}"
PKG_TOOLCHAIN="manual"
PKG_IS_KERNEL_PKG="yes"

make_target() {
  kernel_make KDIR=$(kernel_path) -C ${PKG_BUILD}/driver/product/kernel/drivers/gpu/arm/midgard \
       CONFIG_MALI_MIDGARD=m CONFIG_MALI_REAL_HW=y CONFIG_MALI_DEVFREQ=n CONFIG_MALI_GATOR_SUPPORT=y
}

makeinstall_target() {
  DRIVER_DIR=${PKG_BUILD}/driver/product/kernel/drivers/gpu/arm/midgard

  mkdir -p ${INSTALL}/$(get_full_module_dir)/${PKG_NAME}
    cp ${DRIVER_DIR}/mali_kbase.ko ${INSTALL}/$(get_full_module_dir)/${PKG_NAME}
}
