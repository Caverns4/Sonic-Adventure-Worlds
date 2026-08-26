extends Node3D

@export var level_music: AudioStream

@onready var players_container: Node3D = $PlayersContainer
var game_hud: PackedScene = preload("res://entitites/HUD/player_hud.tscn")

var chat_visible = false

func _ready():
	for i in Global.character_selections:
		_add_player(i)
	
	if Global.players.size() > 0:
		var new_hud: GameHUD = game_hud.instantiate()
		Global.players[0].hud = new_hud
		new_hud._setup_life_counter(Global.players[0].character)
		add_child(new_hud)
	
	Global.play_music(level_music)

func _add_player(id: int):
	var player = Global.player_scenes[id-1].instantiate()

	player.position = get_spawn_point()
	players_container.add_child(player, true)


func get_spawn_point() -> Vector3:
	var spawn_point = Vector2.from_angle(randf() * 2 * PI) * 2 # spawn radius
	return Vector3(spawn_point.x, 2, spawn_point.y)
