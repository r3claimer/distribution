# SPDX-License-Identifier: Apache-2.0
# Copyright (C) 2022 - Fewtarius

PKG_NAME="emulators"
PKG_LICENSE="Apache-2.0"
PKG_SITE="www.jelos.org"
PKG_SECTION="emulation" # Do not change to virtual or makeinstall_target will not execute.
PKG_LONGDESC="Emulation metapackage."
PKG_TOOLCHAIN="manual"

PKG_EMUS="flycast-sa hatarisa hypseus-singe hypseus-singe moonlight openbor pico-8 ppsspp-sa
          vice-sa"

PKG_RETROARCH="core-info libretro-database retroarch retroarch-assets retroarch-joypads retroarch-overlays     \
              slang-shaders"

LIBRETRO_CORES="2048-lr 81-lr a5200-lr atari800-lr beetle-gba-lr beetle-lynx-lr beetle-ngp-lr beetle-pce-lr    \
                beetle-pce-fast-lr beetle-pcfx-lr bsnes-lr bsnes-mercury-performance-lr beetle-supafaust-lr    \
                beetle-supergrafx-lr beetle-vb-lr beetle-wswan-lr beetle-saturn-lr bluemsx-lr cannonball-lr    \
                cap32-lr crocods-lr daphne-lr dinothawr-lr dosbox-svn-lr dosbox-pure-lr duckstation-lr         \
                easyrpg-lr fake08-lr fbalpha2012-lr fbalpha2019-lr fbneo-lr fceumm-lr flycast2021-lr fmsx-lr   \
                freechaf-lr freeintv-lr freej2me-lr fuse-lr gambatte-lr gearboy-lr gearcoleco-lr gearsystem-lr \
                genesis-plus-gx-lr genesis-plus-gx-wide-lr gme-lr gw-lr handy-lr hatari-lr mame2000-lr         \
                mame2003-plus-lr mame2010-lr mame2015-lr melonds-lr meowpc98-lr mesen-lr mgba-lr mrboom-lr     \
                mupen64plus-lr mupen64plus-nx-lr neocd_lr nestopia-lr np2kai-lr nxengine-lr o2em-lr opera-lr   \
                parallel-n64-lr pcsx_rearmed-lr picodrive-lr pokemini-lr potator-lr prboom-lr prosystem-lr     \
                ppsspp-lr puae-lr px68k-lr quasi88-lr quicknes-lr race-lr reminiscence-lr sameboy-lr           \
                sameduck-lr scummvm-lr smsplus-gx-lr snes9x-lr snes9x2002-lr snes9x2005_plus-lr snes9x2010-lr  \
                stella-lr stella-2014-lr swanstation-lr tic80-lr tgbdual-lr tyrquake-lr uzem-lr vba-next-lr    \
                vbam-lr vecx-lr vice-lr yabasanshiro-lr virtualjaguar-lr xmil-lr xrick-lr"

### Emulators or cores for specific devices
case "${DEVICE}" in
  AMD64)
    [ "${ENABLE_32BIT}" == "true" ] && EMUS_32BIT="lutris-wine"
    PKG_EMUS+=" cemu-sa citra-sa dolphin-sa duckstation-sa melonds-sa minivmacsa mupen64plus-sa pcsx2-sa       \
                primehack rpcs3-sa ryujinx-sa scummvmsa xemu-sa yuzu-sa"
    LIBRETRO_CORES+=" beetle-psx-lr bsnes-hd-lr citra-lr desmume-lr dolphin-lr flycast-lr lrps2-lr mame-lr     \
                      minivmac-lr play-lr"
  ;;
  RK358*)
    [ "${ENABLE_32BIT}" == "true" ] && EMUS_32BIT="box86 flycast-lr pcsx_rearmed-lr"
    PKG_EMUS+=" aethersx2-sa duckstation-sa pcsx_rearmed-lr box64 scummvmsa yabasanshiro-sa box64 portmaster"
    LIBRETRO_CORES+=" beetle-psx-lr bsnes-hd-lr citra-lr dolphin-lr mame-lr"
    PKG_RETROARCH+=" retropie-shaders"
  ;;
  RK356*)
    [ "${ENABLE_32BIT}" == "true" ] && EMUS_32BIT="box86 flycast-lr pcsx_rearmed-lr"
    PKG_DEPENDS_TARGET+=" common-shaders duckstation-sa glsl-shaders mupen64plus-sa scummvmsa box64 portmaster"
    PKG_EMUS+=" dolphin-sa drastic-sa yabasanshiro-sa"
    PKG_RETROARCH+=" retropie-shaders"
  ;;
  S922X*)
    [ "${ENABLE_32BIT}" == "true" ] && EMUS_32BIT="box86 flycast-lr pcsx_rearmed-lr"
    PKG_EMUS+=" aethersx2-sa citra-sa dolphin-sa duckstation-sa drastic-sa mupen64plus-sa yabasanshiro-sa     \
                box64 portmaster"
    LIBRETRO_CORES+=" beetle-psx-lr bsnes-hd-lr dolphin-lr flycast-lr"
    PKG_RETROARCH+=" retropie-shaders"
  ;;
  RK3326*)
    [ "${ENABLE_32BIT}" == "true" ] && EMUS_32BIT="flycast-lr pcsx_rearmed-lr"
    PKG_DEPENDS_TARGET+=" common-shaders glsl-shaders"
    PKG_EMUS+=" drastic-sa mupen64plus-sa scummvmsa yabasanshiro-sa portmaster"
    LIBRETRO_CORES+=" flycast-lr"
    PKG_RETROARCH+=" retropie-shaders"
  ;;
esac

PKG_DEPENDS_TARGET+=" ${PKG_EMUS} ${EMUS_32BIT} ${PKG_RETROARCH} ${LIBRETRO_CORES}"

makeinstall_target() {
  ### Flush cache from previous builds
  clean_es_cache

  ### Panasonic 3DO
  add_emu_core 3do retroarch opera true
  add_es_system 3do

  ### Nintendo 3DS
  add_emu_core 3ds retroarch citra true
  add_emu_core 3ds citra citra-sa false
  add_es_system 3ds

  ### Commodore Amiga
  add_emu_core amiga retroarch puae true
  case ${TARGET_ARCH} in
    aarch64)
      add_emu_core amiga amiberry false
    ;;
  esac
  add_es_system amiga

  ### Commodore Amiga CD32
  add_emu_core amigacd32 retroarch puae true
  case ${TARGET_ARCH} in
    aarch64)
      add_emu_core amigacd32 retroarch uae4arm false
    ;;
  esac
  add_es_system amigacd32

  ### Amstrad CPC
  add_emu_core amstradcpc retroarch crocods true
  add_emu_core amstradcpc retroarch cap32 false
  add_es_system amstradcpc

  ### Arcade
  add_emu_core arcade retroarch mame2003_plus true
  add_emu_core arcade retroarch mame2000 false
  add_emu_core arcade retroarch mame2010 false
  add_emu_core arcade retroarch mame2015 false
  add_emu_core arcade retroarch mame false
  add_emu_core arcade retroarch fbneo false
  add_emu_core arcade retroarch fbalpha2012 false
  add_emu_core arcade retroarch fbalpha2019 false
  add_es_system arcade

  ### Atari 2600 Libretro
  add_emu_core atari2600 retroarch stella true
  add_es_system atari2600

  ### Atari 5200 Libretro
  add_emu_core atari5200 retroarch a5200 true
  add_emu_core atari5200 retroarch atari800 false
  add_es_system atari5200

  ### Atari 7800
  add_emu_core atari7800 retroarch prosystem true
  add_es_system atari7800

  ## Atari 800
  add_emu_core atari800 retroarch atari800 true
  add_es_system atari800

  ## Atari ST
  add_emu_core atarist retroarch hatari true
  add_emu_core atarist hatarisa hatarisa false
  add_es_system atarist

  ## Sammy Atomiswave
  add_emu_core atomiswave retroarch flycast true
  add_emu_core atomiswave retroarch flycast2021 false
  add_emu_core atomiswave flycast flycast-sa false
  add_es_system atomiswave

  ### Fairchild Channel F
  add_emu_core channelf retroarch freechaf true
  add_es_system channelf

  ### ColecoVision
  add_emu_core colecovision retroarch bluemsx true
  add_emu_core colecovision retroarch gearcoleco false
  add_emu_core colecovision retroarch smsplus false
  add_es_system colecovision

  ### Commodore 128
  add_emu_core c128 retroarch vice_x128 true
  add_emu_core c128 vicesa x128 false
  add_es_system c128

  ### Commodore 16
  add_emu_core c16 retroarch vice_xplus4 true
  add_emu_core c16 vicesa xplus4 false
  add_es_system c16

  ### Commodore 64
  add_emu_core c64 retroarch vice_x64 true
  add_emu_core c64 vicesa x64sc false
  add_es_system c64

  ### Commodore PET
  add_emu_core pet retroarch vice_xpet true
  add_es_system pet

  ### Commodore VIC-20
  add_emu_core vic20 retroarch vice_xvic true
  add_emu_core vic20 vicesa vice_xvic false
  add_es_system vic20

  ### Capcom Playsystem 1
  add_emu_core cps1 retroarch fbneo true
  add_emu_core cps1 retroarch mame2003_plus false
  add_emu_core cps1 retroarch mame2010 false
  add_emu_core cps1 retroarch fbalpha2012 false
  add_emu_core cps1 retroarch mba_mini false
  case ${TARGET_ARCH} in
    aarch64)
      add_emu_core cps1 AdvanceMame AdvanceMame false
    ;;
  esac
  add_es_system cps1

  ### Capcom Playsystem 2
  add_emu_core cps2 retroarch fbneo true
  add_emu_core cps2 retroarch mame2003_plus false
  add_emu_core cps2 retroarch mame2010 false
  add_emu_core cps2 retroarch fbalpha2012 false
  add_emu_core cps2 retroarch mba_mini false
  case ${TARGET_ARCH} in
    aarch64)
      add_emu_core cps2 AdvanceMame AdvanceMame false
    ;;
  esac
  add_es_system cps2

  ### Capcom Playsystem 3
  add_emu_core cps3 retroarch fbneo true
  add_emu_core cps3 retroarch mame2003_plus false
  add_emu_core cps3 retroarch mame2010 false
  add_emu_core cps3 retroarch fbalpha2012 false
  add_emu_core cps3 retroarch mba_mini false
  case ${TARGET_ARCH} in
    aarch64)
      add_emu_core cps3 AdvanceMame AdvanceMame false
    ;;
  esac
  add_es_system cps3

  ### Daphne
  add_emu_core daphne hypseus hypseus true
  add_emu_core daphne retroarch daphne false
  add_es_system daphne

  ### Sega Dreamcast
  add_emu_core dreamcast retroarch flycast true
  add_emu_core dreamcast retroarch flycast2021 false
  add_emu_core dreamcast flycast flycast-sa false
  add_es_system dreamcast

  ### EasyRPG
  add_emu_core easyrpg retroarch easyrpg true
  add_es_system easyrpg

  ### Nintendo Famicom
  add_emu_core famicom retroarch nestopia true
  add_emu_core famicom retroarch fceumm false
  add_emu_core famicom retroarch quicknes false
  add_emu_core famicom retroarch mesen false
  add_es_system famicom

  ### Nintendo Famicom Disk System
  add_emu_core fds retroarch nestopia true
  add_emu_core fds retroarch fceumm false
  add_emu_core fds retroarch quicknes false
  add_es_system fds

  ### Final Burn Neo
  add_emu_core fbn retroarch fbneo true
  add_emu_core fbn retroarch mame2003_plus false
  add_emu_core fbn retroarch mame2010 false
  add_emu_core fbn retroarch mame2015 false
  add_emu_core fbn retroarch mame false
  add_emu_core fbn retroarch fbalpha2012 false
  add_emu_core fbn retroarch fbalpha2019 false
  add_es_system fbn

  ### Nintendo Game and Watch
  add_emu_core gameandwatch retroarch gw
  add_es_system gameandwatch

  ### Nintendo GameBoy
  add_emu_core gb retroarch gambatte true
  add_emu_core gb retroarch sameboy false
  add_emu_core gb retroarch gearboy false
  add_emu_core gb retroarch tgbdual false
  add_emu_core gb retroarch mgba false
  add_emu_core gb retroarch vbam false
  add_es_system gb

  ### Nintendo GameBoy Hacks
  add_emu_core gbh retroarch gambatte true
  add_emu_core gbh retroarch sameboy false
  add_emu_core gbh retroarch gearboy false
  add_emu_core gbh retroarch tgbdual false
  add_emu_core gbh retroarch mgba false
  add_emu_core gbh retroarch vbam false
  add_es_system gbh

  ### Nintendo GameBoy Advance
  add_emu_core gba retroarch mgba true
  add_emu_core gba retroarch gbsp false
  add_emu_core gba retroarch vbam false
  add_emu_core gba retroarch vba_next false
  add_emu_core gba retroarch beetle_gba false
  add_es_system gba

  ### Nintendo GameBoy Advance Hacks
  add_emu_core gbah retroarch mgba true
  add_emu_core gbah retroarch gbsp false
  add_emu_core gbah retroarch vbam false
  add_emu_core gbah retroarch vba_next false
  add_emu_core gbah retroarch beetle_gba false
  add_es_system gbah

  ### Nintendo GameBoy Color
  add_emu_core gbc retroarch gambatte true
  add_emu_core gbc retroarch sameboy false
  add_emu_core gbc retroarch gearboy false
  add_emu_core gbc retroarch tgbdual false
  add_emu_core gbc retroarch mgba false
  add_emu_core gbc retroarch vbam false
  add_es_system gbc

  ### Nintendo GameCube
  case ${DEVICE} in
    AMD64|RK358*|RK356*|S922X*)
      add_emu_core gamecube dolphin dolphin-sa-gc true
      add_emu_core gamecube primehack primehack false
      add_emu_core gamecube retroarch dolphin false
      add_es_system gamecube
    ;;
  esac

  ### Nintendo Wii
  case ${DEVICE} in
    AMD64|RK358*|RK356*|S922X*)
      add_emu_core wii dolphin dolphin-sa-gc true
      add_emu_core wii primehack primehack false
      add_emu_core wii retroarch dolphin false
      add_es_system wii
    ;;
  esac

  ### Nintendo Wii U
  case ${DEVICE} in
    AMD64)
      add_emu_core wiiu cemu cemu-sa true
      add_es_system wiiu
    ;;
  esac

  ### Nintendo Switch
  case ${DEVICE} in
    AMD64)
      add_emu_core switch yuzu yuzu-sa true
      add_emu_core switch ryujinx ryujinx-sa false
      add_es_system switch
    ;;
  esac

  ### Sega GameGear
  add_emu_core gamegear retroarch gearsystem true
  add_emu_core gamegear retroarch genesis_plus_gx false
  add_emu_core gamegear retroarch picodrive false
  add_emu_core gamegear retroarch smsplus false
  add_es_system gamegear

  ### Sega GameGear Hacks
  add_emu_core ggh retroarch gearsystem true
  add_emu_core ggh retroarch genesis_plus_gx false
  add_emu_core ggh retroarch picodrive false
  add_emu_core ggh retroarch smsplus false
  add_es_system ggh

  ### Intellivision
  add_emu_core intellivision retroarch freeintv true
  add_es_system intellivision

  ### Sun Microsystems J2ME
  add_emu_core j2me retroarch freej2me true
  add_es_system j2me

  ### Atari Jaguar
  add_emu_core atarijaguar retroarch virtualjaguar true
  add_es_system virtualjaguar

  ### Atari Lynx
  add_emu_core atarilynx retroarch handy true
  add_emu_core atarilynx retroarch beetle_lynx false
  add_es_system atarilynx

  ### Arcade (MAME)
  add_emu_core mame retroarch mame2003_plus true
  add_emu_core mame retroarch mame2010 false
  add_emu_core mame retroarch mame2015 false
  add_emu_core mame retroarch mame false
  add_emu_core mame retroarch fbneo false
  add_emu_core mame retroarch fbalpha2012 false
  add_emu_core mame retroarch fbalpha2019 false
  add_es_system mame

  ### Sega MegaDrive
  add_emu_core megadrive-japan retroarch genesis_plus_gx true
  add_emu_core megadrive-japan retroarch genesis_plus_gx_wide false
  add_emu_core megadrive-japan retroarch picodrive
  add_es_system megadrive-japan

  ### Microsoft MS-DOS
  add_emu_core pc retroarch dosbox_pure
  add_emu_core pc retroarch dosbox_svn
  add_es_system pc

  ### Nintendo MSU-1
  add_emu_core snesmsu1 retroarch snes9x true
  add_emu_core snesmsu1 retroarch beetle_supafaust false
  add_es_system snesmsu1

  ### Microsoft MSX
  add_emu_core msx retroarch bluemsx true
  add_emu_core msx retroarch fmsx false
  add_es_system msx

  ### Microsoft MSX 2
  add_emu_core msx2 retroarch bluemsx true
  add_emu_core msx2 retroarch fmsx false
  add_es_system msx2

  ### Sega Naomi
  add_emu_core naomi retroarch flycast true
  add_emu_core naomi retroarch flucast2021 false
  add_emu_core naomi flycast flycast-sa false
  add_es_system naomi

  ### SNK NeoGeo
  add_emu_core neogeo retroarch fbneo true
  add_emu_core neogeo retroarch mame2003_plus false
  add_emu_core neogeo retroarch fbalpha2012 false
  add_emu_core neogeo retroarch fbalpha2019 false
  add_emu_core neogeo retroarch mame2010 false
  add_emu_core neogeo retroarch mame2015 false
  add_emu_core neogeo retroarch mame false
  add_es_system neogeo

  ### SNK NeoCD
  add_emu_core neocd retroarch neocd true
  add_emu_core neocd retroarch fbneo false
  add_es_system neocd

  ### SNK NeoGeo Pocket
  add_emu_core ngp retroarch beetle_ngp true
  add_emu_core ngp retroarch race false
  add_es_system ngp

  ### SNK NeoGeo Pocket Color
  add_emu_core ngc retroarch beetle_ngp true
  add_emu_core ngc retroarch race false
  add_es_system ngc

  ### Nintendo 64
  add_emu_core n64 retroarch mupen64plus_next true
  add_emu_core n64 retroarch mupen64plus false
  add_emu_core n64 retroarch parallel_n64 false
  add_emu_core n64 mupen64plus-sa m64p_gliden64 false
  add_emu_core n64 mupen64plus-sa m64p_gl64mk2 false
  add_emu_core n64 mupen64plus-sa m64p_rice false
  add_es_system n64

  ### Nintendo DS
  add_emu_core nds retroarch melonds true
  add_emu_core nds retroarch desmume false
  add_emu_core nds melonds melonds-sa false
  add_es_system nds

  ### Create es_systems
  mk_es_systems

  mkdir -p ${INSTALL}/usr/config/emulationstation
  cp -f ${ESTMP}/es_systems.cfg ${INSTALL}/usr/config/emulationstation
}
