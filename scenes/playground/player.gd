extends CharacterBody3D


const SPEED := 5.0
const JUMP_VELOCITY := 4.0
const GRAVITY := 10
const VAULTING_SPEED := 2.0

var mouse_delta := Vector2.ZERO
var vaulting := false
var vault_target := Vector3.ZERO

@onready var camera:Camera3D = $Camera3D
@onready var ledgeDetectorBottom:RayCast3D = $ledgeDetectorBottom
@onready var ledgeDetectorTop:RayCast3D = $ledgeDetectorTop
@onready var ledgeSpaceDetector:RayCast3D = $ledgeSpaceDetector
@onready var hitbox := $hitbox

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta:float) -> void:
	if vaulting:
		global_position = global_position.move_toward(vault_target, VAULTING_SPEED * delta)
		if global_position == vault_target:
			vaulting = false
			hitbox.disabled = false
		return
	
	if ledgeDetectorBottom.is_colliding() and not ledgeDetectorTop.is_colliding():
		ledgeSpaceDetector.force_raycast_update()
		if ledgeSpaceDetector.is_colliding():
			if ledgeSpaceDetector.get_collision_point().distance_to(ledgeSpaceDetector.global_position) >= 1.5:
				vaulting = true
				vault_target = ledgeSpaceDetector.get_collision_point()
				hitbox.disabled = true
				velocity = Vector3.ZERO
				return
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= GRAVITY * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var input_dir := Input.get_vector("walk_left", "walk_right", "walk_forward", "walk_backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func _process(delta:float) -> void:
	rotation_degrees.y -= mouse_delta.x * Settings.mouse_sensitivity
	camera.rotation_degrees.x -= mouse_delta.y * Settings.mouse_sensitivity
	camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, -90, 90)
	mouse_delta = Vector2.ZERO

func _input(event:InputEvent) -> void:
	if event is InputEventMouseMotion:
		mouse_delta = event.relative
