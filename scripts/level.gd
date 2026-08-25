extends Node3D

@export var level_music: AudioStream

@onready var players_container: Node3D = $PlayersContainer

var chat_visible = false

func _ready():
	for i in Global.character_selections:
		_add_player(i)
	Global.play_music(level_music)

func _add_player(id: int):
	var player = Global.player_scenes[id-1].instantiate()

	player.position = get_spawn_point()
	players_container.add_child(player, true)


func get_spawn_point() -> Vector3:
	var spawn_point = Vector2.from_angle(randf() * 2 * PI) * 2 # spawn radius
	return Vector3(spawn_point.x, 2, spawn_point.y)
