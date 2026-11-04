extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var pressed: bool = false

@onready var camera: XRCamera3D = $XROrigin3D/XRCamera3D

func _unhandled_input(event):
	if event is InputEventScreenTouch:
		var screen_touch := event as InputEventScreenTouch
		pressed = screen_touch.pressed
		if screen_touch.double_tap:
			FrugalVRManager.load_calibration()



func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	#camera.global_basis.y * Vector3(1, 0, 1)
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	var direction := (transform.basis * camera.global_basis.y * Vector3(1, 0, 1))
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
