class_name CharacterData
extends RefCounted

enum ID{
	NULL,
	SONIC,
	MILES,
	KNUCKLES,
	AMY, # TODO
	EGGMAN, # TODO
	METAL_SONIC, # TODO
}

const data: Dictionary = {
	ID.NULL: {
		'name': "???",
		'icon': "res://assets/icons/zanki_chao.png"
	},
	ID.SONIC: {
		'name': "Sonic",
		'icon': "res://assets/icons/zanki_sonic.png"
	},
	ID.MILES: {
		'name': "Miles",
		'icon': "res://assets/icons/zanki_tails.png"
	},
	ID.KNUCKLES: {
		'name': "Knuckles",
		'icon': "res://assets/icons/zanki_knuckle.png"
	},
	ID.AMY: {
		'name': "Amy",
		'icon': "res://assets/icons/zanki_amy.png"
	},
	ID.EGGMAN: {
		'name': "Eggman",
		'icon': "res://assets/icons/zanki_egg.png"
	},
	ID.METAL_SONIC: {
		'name': "Metal Sonic",
		'icon': "res://assets/icons/zanki_metal.png"
	},
}
