extends CharacterBody3D

var movement_velocity: float = 5
var deadzone: float = 0.1
enum {NONE, SINGLE, DOUBLE}

var picked: Pickable = null
var hold: int = NONE
var rotating: Basis = Basis(Vector3.ZERO, Vector3.ZERO, Vector3.ZERO)

var input_single: bool = false:
	get():
		if input_single:
			input_single = false
			return true
		return false
		
var input_double: bool = false:
	get():
		if input_double:
			input_double = false
			return true
		return false
		
var input_hold_single: bool = false
var input_hold_double: bool = false

@onready var camera: XRCamera3D = $XROrigin3D/XRCamera3D
@onready var hold_timer: Timer = $HoldTimer
@onready var look_raycast: RayCast3D = $XROrigin3D/XRCamera3D/RayCast3D
@onready var rotate_image: Sprite3D = $XROrigin3D/XRCamera3D/Sprite3D
@onready var marker_3d: Marker3D = $XROrigin3D/XRCamera3D/Marker3D

func _unhandled_input(event):
	if event is InputEventScreenTouch:
		var screen_touch: InputEventScreenTouch = event as InputEventScreenTouch
		
		
		# double tap is never registered with presed as false
		if screen_touch.pressed:
			hold_timer.start()
			if screen_touch.double_tap: # Double tap
				hold = DOUBLE
			else:
				hold = SINGLE
		else:
			hold_timer.stop()
			if input_hold_single or input_hold_double:
				input_hold_double = false
				input_hold_single = false
			elif hold == SINGLE:
				input_single = true
			elif hold == DOUBLE:
				input_double = true
				




func _ready() -> void:
	FrugalVRManager.eye_height = 1.70


func _physics_process(delta: float) -> void:
	var move_vec: Vector3 = camera.global_basis.y * Vector3(1, 0, 1)
	var on: float = 1 if move_vec.length() > deadzone and input_hold_single else 0
	var roll: float = camera.global_basis.tdotx(self.global_basis.x)
	
	
	


	
	
	if input_single and not picked:
		if look_raycast.is_colliding():
			var collison_object := look_raycast.get_collider()
			if collison_object is Pickable:
				picked = collison_object as Pickable
				picked.pick(marker_3d)
				rotating = Basis(Vector3.ZERO, Vector3.ZERO, Vector3.ZERO)
	elif input_double and picked:
		picked.drop()
		picked = null
		rotating = Basis(Vector3.ZERO, Vector3.ZERO, Vector3.ZERO)
	elif input_hold_single and picked:
		picked.track = false
		if rotating.get_scale().length() == 0.0:
			rotating = camera.global_basis
			
		var rotating_x = camera.global_basis.tdotz(rotating.y) * rotating.x
		var rotating_y = camera.global_basis.tdotz(rotating.x) * rotating.y
		picked.apply_torque(rotating_x)
		picked.apply_torque(rotating_y)
	
	elif input_hold_single and not picked:
		velocity.x = move_toward(velocity.x, move_vec.x * movement_velocity, delta * 100)
		velocity.z = move_toward(velocity.z, move_vec.z * movement_velocity, delta * 100)
	elif picked:
		picked.track = true
	

		
		
	if not is_on_floor():
		velocity += get_gravity() * delta
	move_and_slide()


func _on_hold_timer_timeout() -> void:
	match hold:
		SINGLE:
			input_hold_single = true
			hold = NONE
		DOUBLE:
			input_hold_single = true
			hold = NONE
		_:
			pass
