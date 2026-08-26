extends State

@export var rolling_sfx: AudioStream = preload("res://audio/player/s2br_Roll.wav")
@export var roll_decelaration_rate: float = 4.0

func can_enter_state() -> bool:
	if player.velocity.length() > 1.0: return true
	return false

func enter_state(_params: Variant) -> void:
	if _params == false: ## player is not attacking
		player.change_state("Free",false)
	else:
		player.dynamic_sfx.stream = rolling_sfx
		player.dynamic_sfx.play()
		player.floor_stop_on_slope = false

func exit_state() -> void:
	player.floor_stop_on_slope = true

func _process_state(delta: float) -> void:
	var direction: Vector3 = player.get_direction_from_Input()
	player.apply_gravity(delta)
	player.velocity = move_on_ground(delta,direction)
	if Input.is_action_just_pressed("jump"):
		player.check_jump()
	player.check_on_floor(delta,direction)
	if !player.is_on_floor():
		player.change_state("Air",false)
	elif player.velocity.length() < 1.0:
		player.change_state("Free",false)
	else:
		player.player_skin.apply_animation("Jump")

func move_on_ground(delta: float, direction: Vector3) -> Vector3:
	# keep a copy of the previous velocity
	var previous_velocity = player.velocity.dot(player.up_direction)
	var new_vel: Vector3 = player.velocity
	# direction check (check that direction is being pressed)
	if direction and !player.movement_locked:
		## Get the angle diff of the input to move direction. 1.0 means same, 0 means 90 degrees, -1 means backwards. 
		var dot: float = player.velocity.normalized().dot(direction.normalized())
		## Get the player's accelateration.
		var accel_amt: float = player.base_aceleration
		if player.is_super: accel_amt *= 1.5
		if dot < 0.5: 
			new_vel = (player.velocity.slide(player.up_direction).move_toward(
				-player.pivot.global_basis.z*new_vel.length(),accel_amt * delta
			) + (previous_velocity*player.up_direction))
		else:
			new_vel = (player.velocity.slide(player.up_direction).move_toward(
			Vector3.ZERO,delta*roll_decelaration_rate)+previous_velocity*player.up_direction)
	else:
		new_vel = (player.velocity.slide(player.up_direction).move_toward(
			Vector3.ZERO,delta*roll_decelaration_rate)+previous_velocity*player.up_direction)
	return new_vel
