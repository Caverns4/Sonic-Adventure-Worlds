extends Node

## Match CharacterData.ID
const player_scenes: Array[PackedScene] = [
	
	preload("res://entitites/PhysicsPlayer/sonic_player.tscn"),# Sonic
	preload("res://entitites/PhysicsPlayer/miles_player.tscn"),# Miles(Mechless Tails)
	preload("res://entitites/PhysicsPlayer/knuckles_player.tscn"),# Knuckles
	preload("res://entitites/PhysicsPlayer/eggman_player.tscn"),# Eggmech (Mech Eggman)
]

var hud: GameHUD = null 
var players: Array[Physics_Player] = []
var character_selections: Array[CharacterData.ID] = []

var music_player: AudioStreamPlayer = AudioStreamPlayer.new()

var upgrade_flags: Dictionary = {
'Sonic Light Shoes' = false,
'Sonic Bounce Bracelet' = false,
'Sonic Flame Ring' = false,
'Sonic Magic Gloves' = false,
'Tails Booster' = false,
'Tails Bazooka' = false,
'Tails Laser Blaster' = false,
'Knuckles Shovel Claw' = false,
'Knuckles Air Necklace' = false,
'Knuckles Hammer Gloves' = false,
'Knuckles Sunglasses' = false,
'Eggman Jet Engine' = false,
'Eggman Large Cannon' = false,
'Eggman Protection Armor' = false,
'Eggman Laser Blaster' = false,
}



func _ready() -> void:
	add_child(music_player)
	music_player.bus = "Music"

func play_music(song: AudioStream):
	music_player.stream = song
	music_player.play()
