extends CharacterBody3D

var movement_velocity: float = 5
var deadzone: float = 0.3
var pressed: bool = false

var input_single: bool = false:
	get():
		if input_single:
			input_single = false
			return true
		return false
var input_hold: bool = false

@onready var camera: XRCamera3D = $XROrigin3D/XRCamera3D
@onready var hold_timer: Timer = $HoldTimer

func _unhandled_input(event):
	if event is InputEventScreenTouch:
		var screen_touch := event as InputEventScreenTouch
		
		if screen_touch.double_tap:
			FrugalVRManager.load_calibration()
		
		if screen_touch.pressed:
			if not pressed:
				hold_timer.start()
				pressed = screen_touch.pressed
		elif not screen_touch.pressed:
			if pressed:
				hold_timer.stop()
				pressed = false
				input_single = true
			else:
				input_hold = false
		




func _ready() -> void:
	FrugalVRManager.eye_height = 1.70


func _physics_process(delta: float) -> void:
	var move_vec: Vector3 = camera.basis.y * Vector3(1, 0, 1)
	var on: float = 1 if move_vec.length() > deadzone and input_hold else 0
	
	
	velocity.x = move_toward(velocity.x, move_vec.x * movement_velocity * on, delta * 100)
	velocity.z = move_toward(velocity.z, move_vec.z * movement_velocity * on, delta * 100)
	

	
	if not is_on_floor():
		velocity += get_gravity() * delta
	elif input_single:
		velocity.y = 5
		
	move_and_slide()


func _on_hold_timer_timeout() -> void:
	if pressed:
		input_hold = true
		pressed = false
