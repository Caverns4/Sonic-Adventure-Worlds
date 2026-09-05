class_name Physics_Player
extends Character

@export var character: CharacterData.ID = 0 as CharacterData.ID
@export_category("Objects")
@export var player_skin: CharacterAvatar

@export_group("Ground movement")
@export var top_speed: float = 6.0
@export var base_aceleration: float = 12.0
@export var turn_sharpness: float = 10 ## TODO

@export_group("Air movement")
@export var jump_vel: float = 6.5
@export var jump_hold_vel: float = 20.0

@export_group("Character abilities")
## Homing Attack for Sonic/Shadow/Amy/Metal, Flying for Tails, Gliding for Knuckles, glide for Mechs
@export var a_button_air_ability: String = ""
## Spindash for Sonic/Shadow, Tailspin attack for Tails, punch/kick for Knuckles/Rouge, attack for Eggman
@export var x_button_ground_ability: String = ""
## Bounce Attack for Sonic, dive for Knuckles/Rouge, shoot for mechs 
@export var x_button_air_ability: String = ""
## Roll for Sonic, Shadow, Tails, Knuckles, Amy, Metal
@export var y_button_ground_ability: String = "Rolling"
## Dropdash for Sonic, Chaos Spear for Shadow, Super transformation for Sonic/Shadow,
@export var y_button_air_ability: String = ""

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")*3.0
var gravity_vector:Vector3 = ProjectSettings.get_setting("physics/3d/default_gravity_vector")

# Variables involving the player's current state
var angle: float = 0.0
var stick: bool = true
var frozen: bool = false
var cooldown_time: float = 0.0
var direction_lock_time: float = 0.0

var in_air: bool = true:
	set(value):
		in_air = value
		if !in_air:
			jumping = false
			if player_skin and player_skin.anim_override:
				player_skin.anim_override = false
var ground_length: float = 1.0
var aire_length: float = 0.5
var margin: float = 0.1

var is_super: bool = false

@onready var casters: Array = [$Pivot/FrontCheck,$Pivot/BackCheck,$Pivot/BackCheck2]
@onready var camera_rig: Node3D = $CameraRig
@onready var camera: Camera3D = $CameraRig/SpringArm3D/Camera3D
@onready var jump_sfx: = $JumpSFX
@onready var brake_sfx: AudioStreamPlayer3D = $BrakeSFX
@onready var land_sfx: AudioStreamPlayer3D = $LandSFX
@onready var dynamic_sfx: AudioStreamPlayer3D = $DynamicSFX
@onready var hud: GameHUD

var ring_count: int = 0 :
	set(value):
		ring_count = value
		if hud: hud._update_rings(value)

var ground_timer: float = 0.0

## The point at which walking becomes running
var speed_margin: float = 16.0

var movement_locked: bool = false
var jumping: bool = false

func _ready():
	Global.players.append(self)
	speed_margin = 5.4*3
	for i in casters:
		i.position -= i.position.normalized()*margin
	super()


func _process(_delta):
	_check_fall_and_respawn()

func is_running() -> bool:
	return velocity.length() > 15.0

func _physics_process(delta):
	if frozen: return
	direction_lock_time = move_toward(direction_lock_time,0.0,delta)
	cooldown_time = move_toward(cooldown_time,0.0,delta)
	
	super(delta)
	if in_air == is_on_floor(): in_air = !in_air
	if Input.is_action_just_pressed("test_left"):
		is_super = !is_super
		player_skin.update_super_state(is_super)

func can_turn_super() -> bool:
	if character == CharacterData.ID.SONIC:
		return true
	return false

func freeze():
	velocity.x = 0
	velocity.z = 0


func get_direction_from_Input() -> Vector3:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir: Vector2 = Vector2.ZERO
	var direction: Vector3 = velocity.normalized()
	if direction_lock_time <= 0:
		input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
		if abs(input_dir.x) < 0.125:
			input_dir.x = 0
		if abs(input_dir.y) < 0.125:
			input_dir.y = 0
	
		# calculate the forward direction based on input and direction from the floor and the camera
		var calcForward = camera.global_position.direction_to(global_position).slide(up_direction)
		direction = ((calcForward.rotated(up_direction,deg_to_rad(90))*-input_dir.x)+(calcForward*-input_dir.y)).normalized()
	return direction

func apply_gravity(delta: float ) -> void:
	# Add the gravity.
	velocity += gravity * delta * Vector3.DOWN
	if jumping and Input.is_action_pressed("jump") and velocity.y > 0.0:
		velocity += (jump_hold_vel * delta) * up_direction


func check_jump() -> void:
	var jump_height_now: float = jump_vel
	if is_super and character == CharacterData.ID.SONIC:
		jump_height_now = 8.0
	# Handle jump.
	if is_on_floor():
		velocity += up_direction*jump_height_now * 1.5
		jumping = true
		movement_locked = false
		player_skin.play_jump_animation("Jump")
		jump_sfx.play()

func check_ground_abilities() -> void:
	if Input.is_action_just_pressed("jump"):
		check_jump()
	elif Input.is_action_just_pressed("attack") and can_enter_state(x_button_ground_ability):
		change_state(x_button_ground_ability,"attack")
	elif Input.is_action_just_pressed("special") and can_enter_state(y_button_ground_ability):
		change_state(y_button_ground_ability,"special")

func check_air_abilities() -> void:
	if Input.is_action_just_pressed("jump")and can_enter_state(a_button_air_ability):
		change_state(a_button_air_ability,"jump")
	elif Input.is_action_just_pressed("attack") and can_enter_state(x_button_air_ability):
		change_state(x_button_air_ability,"attack")
	elif Input.is_action_just_pressed("special") and can_enter_state(y_button_air_ability):
		change_state(y_button_air_ability,"special")


func check_on_floor(delta,direction: Vector3) -> void:
	var wasOnFloor = is_on_floor()
	move_and_slide()
	var disconect = velocity.dot(up_direction) >= 1
	velocity = get_real_velocity()
	
	# ground casting
	for i in casters:
		i.target_position.y = -ground_length if ground_timer > 0 else -aire_length
		i.force_raycast_update()
	
	# check that all floor casteres are colliding
	if $Pivot/FrontCheck.is_colliding() and $Pivot/BackCheck.is_colliding() and $Pivot/BackCheck2.is_colliding() and !disconect:
		# detect if velocity is over speed margin
		if velocity.length() >= speed_margin:
			up_direction = calculate_normal($Pivot/FrontCheck.get_collision_point(),$Pivot/BackCheck.get_collision_point(),$Pivot/BackCheck2.get_collision_point()).normalized()
		else:
			up_direction = -gravity_vector
		
		# realign with floor
		global_transform = align_with_y(global_transform, up_direction)
		# remove any vertical velocity
		velocity = velocity.slide(up_direction)
		
		# snap to floor (prevents air hovering)
		if is_on_floor() or stick:
			stick = true
			apply_floor_snap()
	# if the raycasts fail but we're still on the floor then use
	# godots built in ground detection
	elif is_on_floor() and !disconect:
		if !wasOnFloor:
			up_direction = get_floor_normal()
		stick = true # enable stick for our floor snapping logic
		apply_floor_snap()
		# remove vertical velocity
		velocity = velocity.slide(up_direction)
	# in the air
	else:
		# reset up direction and align ourselves to our up direction
		up_direction = Vector3.UP
		global_transform = align_with_y(global_transform, up_direction)
		stick = false
	
	# calculate the looking angle (if direction has any influence)
	if direction and !movement_locked:
		angle = -direction.signed_angle_to(-global_basis.z,global_transform.basis.y)
		pivot.rotation.y = angle
	
	# ground check related (buffer time for landing)
	if is_on_floor():
		ground_timer = 1.0
	else:
		ground_timer = move_toward(ground_timer,0.0,4.0*delta)

func align_with_y(xform, new_y):
	xform.basis.y = new_y
	xform.basis.x = -xform.basis.z.cross(new_y)
	xform.basis = xform.basis.orthonormalized()
	return xform

func calculate_normal(a = Vector3.ZERO, b = Vector3.ZERO, c = Vector3.ZERO):
	var u = b - a
	var v = c - a
	return u.cross(v)

func _snap_camera_behind_player():
	camera_rig.rotation.y = pivot.rotation.y

func _check_fall_and_respawn():
	if global_transform.origin.y < -300.0:
		_respawn()

func _respawn():
	global_transform.origin = Vector3(0,1,0)
	velocity = Vector3.ZERO
	stick = false
	up_direction = Vector3.UP
	global_transform = align_with_y(global_transform,up_direction)
	camera_rig.global_position = global_position
