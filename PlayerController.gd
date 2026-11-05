extends CharacterBody3D

var movement_velocity: float = 5
var deadzone: float = 0.3
var pressed: bool = false

@onready var camera: XRCamera3D = $XROrigin3D/XRCamera3D

func _unhandled_input(event):
	if event is InputEventScreenTouch:
		var screen_touch := event as InputEventScreenTouch
		pressed = screen_touch.pressed
		if screen_touch.double_tap:
			FrugalVRManager.load_calibration()
		if screen_touch.pressed and not pressed:
			pressed = screen_touch.pressed
			

func _ready() -> void:
	FrugalVRManager.eye_height = 1.70


func _physics_process(delta: float) -> void:
	var move_vec: Vector3 = camera.basis.y * Vector3(1, 0, 1)
	var on: float = 1 if move_vec.length() > deadzone else 0
	
	
	velocity = move_vec * on * movement_velocity
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	move_and_slide()
