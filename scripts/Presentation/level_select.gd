extends Control

@export var scene_paths: PackedStringArray

@onready var level_container: VBoxContainer = %MenuContainer
@onready var loading_screen: PanelContainer = $LoadScreen
var level_button: PackedScene = preload("res://scenes/ui/level_select/level_select_button.tscn")

@onready var entrance_button: Button = %EntranceID
@onready var player_1_button: Button = %Player1Button
@onready var player_2_button: Button = %Player2Button
@onready var option_buttons: Array[Button] = [entrance_button,
player_1_button,player_2_button]

var display_modes: Array[String] = ["Hardware","Emulator"]
var display_mode_index: int = 0

var character_selection: Array[int] = [1,0,0,0]
var entrance_id: int = 0

func _ready() -> void:
	for i in level_container.get_children():
		i.queue_free()
	var index: int = 0
	for i in scene_paths:
		var next_level: Button = level_button.instantiate()
		next_level.scene_to_load = i
		next_level.start_level.connect(load_scene)
		next_level.play_menu_sound.connect(play_menu_sound)
		var butt_text: String = str(index).pad_zeros(3) + ": " + String(next_level.scene_to_load).trim_prefix("res://scenes/level/").trim_suffix(".tscn")
		butt_text = (butt_text.replace("_"," ")).to_upper()
		next_level.text = butt_text
		level_container.add_child(next_level)
		index += 1
	index = 0
	for i in option_buttons:
		i.button_id = index
		i.button_change.connect(option_button_pressed)
		if index == 0:
			i.update_text(display_modes[0])
		else:
			i.update_text(CharacterData.ID.find_key(character_selection[index-1]))
		index += 1
	await get_tree().process_frame
	level_container.get_child(0).grab_focus()


func load_scene(scene_path: String) -> void:
	Global.character_selections.clear()
	for i in character_selection:
		if i > 0:
			Global.character_selections.push_back(i)
	loading_screen.show()
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file(scene_path)

func option_button_pressed(button_id: int) -> void:
	if button_id == 0:
		#entrance_id = wrapi(entrance_id+1,0,31)
		display_mode_index = wrapi(display_mode_index+1,0,2)
		option_buttons[button_id].update_text(display_modes[display_mode_index])
	else:
		var index: int = button_id-1
		var character_id: int = wrapi(character_selection[index]+1,1,CharacterData.ID.size())
		character_selection[index] = character_id
		option_buttons[button_id].update_text(str(CharacterData.ID.find_key(character_id)))

func play_menu_sound() -> void:
	$MenuTick.play()
