
/******************************************
 ************** Synth Screens *************
 ******************************************/

// Ancient TG sprites

/datum/sprite_accessory/screen
	recommended_species = list("synthetic")
	icon = 'icons/mob/sprite_accessory/ipc_screens.dmi'
	color_src = null
	key = "ipc_screen"
	generic = "Screen"
	relevent_layers = list(BODY_ADJ_LAYER)

/datum/sprite_accessory/screen/none
	name = "None"
	icon_state = "none"

/datum/sprite_accessory/screen/blank
	name = "Blank"
	icon_state = "blank"

/datum/sprite_accessory/screen/pink
	name = "Pink"
	icon_state = "pink"

/datum/sprite_accessory/screen/green
	name = "Green"
	icon_state = "green"

/datum/sprite_accessory/screen/red
	name = "Red"
	icon_state = "red"

/datum/sprite_accessory/screen/blue
	name = "Blue"
	icon_state = "blue"

/datum/sprite_accessory/screen/yellow
	name = "Yellow"
	icon_state = "yellow"

/datum/sprite_accessory/screen/shower
	name = "Shower"
	icon_state = "shower"

/datum/sprite_accessory/screen/nature
	name = "Nature"
	icon_state = "nature"

/datum/sprite_accessory/screen/eight
	name = "Eight"
	icon_state = "eight"

/datum/sprite_accessory/screen/goggles
	name = "Goggles"
	icon_state = "goggles"

/datum/sprite_accessory/screen/heart
	name = "Heart"
	icon_state = "heart"

/datum/sprite_accessory/screen/monoeye
	name = "Mono eye"
	icon_state = "monoeye"

/datum/sprite_accessory/screen/breakout
	name = "Breakout"
	icon_state = "breakout"

/datum/sprite_accessory/screen/purple
	name = "Purple"
	icon_state = "purple"

/datum/sprite_accessory/screen/scroll
	name = "Scroll"
	icon_state = "scroll"

/datum/sprite_accessory/screen/console
	name = "Console"
	icon_state = "console"

/datum/sprite_accessory/screen/rgb
	name = "RGB"
	icon_state = "rgb"

/datum/sprite_accessory/screen/golglider
	name = "Gol Glider"
	icon_state = "golglider"

/datum/sprite_accessory/screen/rainbow
	name = "Rainbow"
	icon_state = "rainbow"

/datum/sprite_accessory/screen/sunburst
	name = "Sunburst"
	icon_state = "sunburst"

/datum/sprite_accessory/screen/static
	name = "Static"
	icon_state = "static"

//Oracle Station sprites

/datum/sprite_accessory/screen/bsod
	name = "BSOD"
	icon_state = "bsod"

/datum/sprite_accessory/screen/redtext
	name = "Red Text"
	icon_state = "retext"

/datum/sprite_accessory/screen/sinewave
	name = "Sine wave"
	icon_state = "sinewave"

/datum/sprite_accessory/screen/squarewave
	name = "Square wave"
	icon_state = "squarwave"

/datum/sprite_accessory/screen/ecgwave
	name = "ECG wave"
	icon_state = "ecgwave"

/datum/sprite_accessory/screen/eyes
	name = "Eyes"
	icon_state = "eyes"

/datum/sprite_accessory/screen/textdrop
	name = "Text drop"
	icon_state = "textdrop"

/datum/sprite_accessory/screen/stars
	name = "Stars"
	icon_state = "stars"


/******************************************
 ************* Synth Chassis **************
 ******************************************/

/datum/sprite_accessory/chassis
	recommended_species = list("synthetic")
	icon = null
	icon_state = "synthetic"
	color_src = null
	factual = FALSE
	key = "chassis"
	generic = "Chassis Type"

/datum/sprite_accessory/chassis/mcgreyscale
	name = "Morpheus Cyberkinetics(Greyscale)"
	icon_state = "mcgipc"
	color_src = 1 //Here it's used to tell apart greyscalling

/datum/sprite_accessory/chassis/bishopcyberkinetics
	name = "Bishop Cyberkinetics"
	icon_state = "bshipc"

/datum/sprite_accessory/chassis/bishopcyberkinetics2
	name = "Bishop Cyberkinetics 2.0"
	icon_state = "bs2ipc"

/datum/sprite_accessory/chassis/hephaestussindustries
	name = "Hephaestus Industries"
	icon_state = "hsiipc"

/datum/sprite_accessory/chassis/hephaestussindustries2
	name = "Hephaestus Industries 2.0"
	icon_state = "hi2ipc"

/datum/sprite_accessory/chassis/shellguardmunitions
	name = "Shellguard Munitions Standard Series"
	icon_state = "sgmipc"

/datum/sprite_accessory/chassis/wardtakahashimanufacturing
	name = "Ward-Takahashi Manufacturing"
	icon_state = "wtmipc"

/datum/sprite_accessory/chassis/xionmanufacturinggroup
	name = "Xion Manufacturing Group"
	icon_state = "xmgipc"

/datum/sprite_accessory/chassis/xionmanufacturinggroup2
	name = "Xion Manufacturing Group 2.0"
	icon_state = "xm2ipc"

/datum/sprite_accessory/chassis/zenghupharmaceuticals
	name = "Zeng-Hu Pharmaceuticals"
	icon_state = "zhpipc"

/datum/sprite_accessory/chassis/syntheticlizard
	name = "Synthetic Reptilomorph"
	icon_state = "synthliz"

/datum/sprite_accessory/chassis/syntheticanthromorph
	name = "Synthetic Anthromorph"
	icon_state = "anthromorph"

/******************************************
 *********** Synth Boot Sounds ************
 ******************************************/

/datum/sprite_accessory/synth_bootsound //special case, aren't actually sprite_accessory (being ogg files) but are updated via it
	icon = null //These datums exist for selecting bootsound on preference, and little else
	key = "bootsound"
	generic = "Boot-Up Sound Type"
	recommended_species = list("synthetic")

/datum/sprite_accessory/synth_bootsound/ipc
	key = "ipc_bootsound"
	generic = "I.P.C."
