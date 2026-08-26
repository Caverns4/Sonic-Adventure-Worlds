extends State


@export var max_charge: float = 0.25
@export var dash_speed: float = 10.0
@export var dropdash_charge_sfx: AudioStream = preload("res://audio/player/DropDash.wav")
@export var dropdash_sfx: AudioStream = preload("res://audio/player/s2br_DashRelease.wav")

var charge_time: float = 0.0
var button_check: String = ""

func enter_state(button_name: Variant) -> void:
	button_check = button_name
	player.direction_lock_time = 0.0
	charge_time = 0

func _process_state(delta: float) -> void:
	var direction: Vector3 = player.get_direction_from_Input()
	player.apply_gravity(delta)
	player.velocity = move_in_air(delta,direction)
	player.check_on_floor(delta,direction)

	if player.is_on_floor():
		if charge_time >= max_charge:
			player.change_state("Rolling",button_check)
			player.dynamic_sfx.stream = dropdash_sfx
			player.dynamic_sfx.play()
		else:
			player.change_state("Free",false)
			player.land_sfx.play()
	elif !Input.is_action_pressed(button_check):
		player.change_state("Jumping",true)
	else:
		player.player_skin.apply_animation("Jump")
		if charge_time < max_charge:
			charge_time += delta
			if charge_time >= max_charge:
				player.dynamic_sfx.stream = dropdash_charge_sfx
				player.dynamic_sfx.play()
				var ball: MeshInstance3D = player.player_skin.jump_ball
				if ball: ball.show()

func exit_state() -> void:
	var ball: MeshInstance3D = player.player_skin.jump_ball
	if ball: ball.hide()
	if charge_time >= max_charge and player.is_on_floor():
		var direction: float = player.pivot.global_rotation.y
		player.velocity = Vector3.FORWARD.rotated(player.up_direction,direction) * dash_speed * 3


func move_in_air(delta: float, direction: Vector3) -> Vector3:
	# keep a copy of the previous velocity
	var previous_velocity = player.velocity.dot(player.up_direction)
	var new_vel: Vector3 = player.velocity
	# direction check (check that direction is being pressed)
	if direction and !player.movement_locked:
		## Get the angle diff of the input to move direction. 1.0 means same, 0 means 90 degrees, -1 means backwards. 
		var dot: float = player.velocity.normalized().dot(direction.normalized())
		## Get the player's accelateration.
		var accel_amt: float =player. base_aceleration - (dot-1)*8
		var current_top_speed: float = player.top_speed*3.0
		if player.is_super:
			accel_amt *= 1.5
			current_top_speed *= 1.5
		new_vel = (player.velocity.slide(player.up_direction).move_toward(
			-player.pivot.global_basis.z*current_top_speed,accel_amt * delta
		) + (previous_velocity*player.up_direction))
	else:
		new_vel = (player.velocity.slide(player.up_direction).move_toward(
			Vector3.ZERO,delta*30)+previous_velocity*player.up_direction)
	return new_vel
