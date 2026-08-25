class_name GameHUD
extends CanvasLayer

@onready var score_counter: Label = $Top/ScoreCounter
@onready var time_counter: Label = $Top/TimeCounter
@onready var ring_counter: Label = $Top/RingCount
@onready var life_icon: TextureRect = $Bottom/LifeIcon
@onready var life_counter: Label = $Bottom/LifeCounter

var level_timer: float = 0.0

func _physics_process(delta: float) -> void:
	level_timer += delta

	var hud_time = level_timer
	var hud_time_minutes:int = int(hud_time / 60)
	var hud_time_seconds:int = int(hud_time) % 60
	var hud_time_hundredths:int = int(hud_time * 100) % 100
	time_counter.text = "TIME: %2d'%02d\"%02d" % [hud_time_minutes,hud_time_seconds,hud_time_hundredths]

func _setup_life_counter(character: int) -> void:
	$Bottom/LifeIcon.texture = load(CharacterData.data[character].get('icon',''))


func _update_rings(ring_count: int) -> void:
	ring_counter.text = "RINGS: " + str(ring_count).lpad(4)
