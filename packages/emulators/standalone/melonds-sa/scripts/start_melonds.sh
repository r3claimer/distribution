#!/bin/bash

# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2022-present JELOS (https://github.com/JustEnoughLinuxOS)

. /etc/profile

set_kill set "-9 melonDS"

#load gptokeyb support files
control-gen_init.sh
source /storage/.config/gptokeyb/control.ini
get_controls

if [ ! -d "/storage/.config/melonDS" ]; then
    mkdir -p "/storage/.config/melonDS"
        cp -r "/usr/config/melonDS" "/storage/.config/"
fi

if [ ! -d "/storage/roms/savestates/nds" ]; then
    mkdir -p "/storage/roms/savestates/nds"
fi

#Make sure melonDS gptk config exists
if [ ! -f "/storage/.config/melonDS/melonDS.gptk" ]; then
  cp -r "/usr/config/melonDS/melonDS.gptk" "/storage/.config/melonDS/melonDS.gptk"
fi

#Emulation Station Features
  GAME=$(echo "${1}"| sed "s#^/.*/##")
  PLATFORM=$(echo "${2}"| sed "s#^/.*/##")
  GRENDERER=$(get_setting graphics_backend "${PLATFORM}" "${GAME}")
  SORIENTATION=$(get_setting screen_orientation "${PLATFORM}" "${GAME}")
  SLAYOUT=$(get_setting screen_layout "${PLATFORM}" "${GAME}")
  SWAP=$(get_setting screen_swap "${PLATFORM}" "${GAME}")
  SROTATION=$(get_setting screen_rotation "${PLATFORM}" "${GAME}")
  SHOWFPS=$(get_setting show_fps "${PLATFORM}" "${GAME}")
  VSYNC=$(get_setting vsync "${PLATFORM}" "${GAME}")
  CONFIG_TOML="/storage/.config/melonDS/melonDS.toml"

  #Graphics Backend
	if [ "$GRENDERER" = "opengl" ]; then
  		sed -i '/^UseGL/c\UseGL = true' "${CONFIG_TOML}"
	else
  		sed -i '/^UseGL/c\UseGL = false' "${CONFIG_TOML}"
	fi

  #Screen Orientation
	if [ "$SORIENTATION" > "0" ]
	then
		sed -i "/^ScreenLayout/c\ScreenLayout = $SORIENTATION" "${CONFIG_TOML}"
	else
		sed -i '/^ScreenLayout/c\ScreenLayout = 2' "${CONFIG_TOML}"
        fi

  #Screen Layout
	if [ "$SLAYOUT" > "0" ]; then
		sed -i "/^ScreenSizing/c\ScreenSizing = $SLAYOUT" "${CONFIG_TOML}"
	else
		sed -i '/^ScreenSizing/c\ScreenSizing = 0' "${CONFIG_TOML}"
	fi

ScreenLayout  #Screen Swap
	if [ "$SWAP" = "1" ]
	then
		sed -i '/^ScreenSwap/c\ScreenSwap = true' "${CONFIG_TOML}"
	else
		sed -i '/^ScreenSwap/c\ScreenSwap = false' "${CONFIG_TOML}"
	fi

  #Screen Rotation
	if [ "$SROTATION" > "0" ]
	then
		sed -i "/^ScreenRotation/c\ScreenRotation = $SROTATION" "${CONFIG_TOML}"
	else
		sed -i '/^ScreenRotation/c\ScreenRotation = 0' "${CONFIG_TOML}"
	fi

  #Vsync
        if [ "$VSYNC" = "0" ]; then
                sed -i '/^VSync/c\VSync=0' "${CONFIG_TOML}"
	else
                sed -i '/^VSync/c\VSync=1' "${CONFIG_TOML}"
        fi

  #Show FPS
	if [ "$SHOWFPS" = "1" ]
	then
		export GALLIUM_HUD="simple,fps"
	fi

#Set QT Platform to Wayland
  export QT_QPA_PLATFORM=wayland
  @PANFROST@
  @HOTKEY@
  @LIBMALI@

#Run MelonDS emulator
$GPTOKEYB "melonDS" -c "/storage/.config/melonDS/melonDS.gptk" &
/usr/bin/melonDS -f "${1}"
kill -9 "$(pidof gptokeyb)"
