extends State

@export var spindash_charge_sfx: AudioStream = preload("res://audio/player/s2br_SpindashRev.wav")
@export var minimum_speed: float = 6.0
@export var max_speed: float = 12.0
@export var max_charge: float = 1.0

var button_check: String = ""
var charge_time: float = 0.0

func can_enter_state() -> bool:
	if player.is_on_floor(): return true
	return false

func enter_state(button_name: Variant) -> void:
	charge_time = 0.0
	button_check = button_name
	player.dynamic_sfx.stream = spindash_charge_sfx
	player.dynamic_sfx.play()
	player.floor_stop_on_slope = true

func exit_state() -> void:
	player.floor_stop_on_slope = true
	var ball: MeshInstance3D = player.player_skin.jump_ball
	if ball: ball.hide()
	release_spindash()

func release_spindash() ->void:
	var dash_speed: float = max(
		((max_speed-minimum_speed)/(max_charge/charge_time))+minimum_speed,
		minimum_speed)
	var direction: float = player.pivot.global_rotation.y
	player.velocity = Vector3.FORWARD.rotated(player.up_direction,direction) * dash_speed * 3


func _process_state(delta: float) -> void:
	charge_time = move_toward(charge_time,max_charge,delta)
	var direction: Vector3 = player.get_direction_from_Input()
	player.apply_gravity(delta)
	player.velocity = move_on_ground(delta,direction)
	player.check_on_floor(delta,direction)
	if !player.is_on_floor():
		player.change_state("Air",false)
		player.direction_lock_time = 0.25
	elif !Input.is_action_pressed(button_check):
		player.change_state("Rolling",button_check)
		release_spindash()
	else:
		player.player_skin.apply_animation("Jump")

func move_on_ground(delta: float, direction: Vector3) -> Vector3:
	# keep a copy of the previous velocity
	var previous_velocity = player.velocity.dot(player.up_direction)
	var new_vel: Vector3 = player.velocity
	# direction check (check that direction is being pressed)
	if direction and !player.movement_locked:
		new_vel = (player.velocity.slide(player.up_direction).move_toward(
			Vector3.ZERO,delta*30)+previous_velocity*player.up_direction)
	return new_vel
