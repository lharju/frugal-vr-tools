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
@onready var marker_3d: Marker3D = $XROrigin3D/XRCamera3D/Path3D/PathFollow3D/Marker3D
@onready var path_3d: Path3D = $XROrigin3D/XRCamera3D/Path3D
@onready var path_follow_3d: PathFollow3D = $XROrigin3D/XRCamera3D/Path3D/PathFollow3D

func _unhandled_input(event):
	if event is InputEventScreenTouch:
		var screen_touch: InputEventScreenTouch = event as InputEventScreenTouch
		
		if screen_touch.pressed:
			hold_timer.start()
			if screen_touch.double_tap:
				hold = DOUBLE
			else:
				hold = SINGLE
		else:
			hold_timer.stop()
			if input_hold_single:
				input_hold_single = false
			if input_hold_double:
				if picked:
					picked.track = true
				input_hold_double = false
			elif hold == SINGLE:
				print("Single")
				input_single = true
			elif hold == DOUBLE:
				print("Double")
				input_double = true
			hold = NONE


func _ready() -> void:
	#FrugalVRManager.load_calibration()
	FrugalVRManager.eye_height = 1.70


func _physics_process(delta: float) -> void:
	var roll: float = camera.global_basis.tdotx(Vector3.UP)
	roll -= clamp(roll, -0.05, 0.05)
	
	var move_vec: Vector3 = Vector3.ZERO
	var on: float = 0
	
	if input_hold_double:
		if picked:
			if picked.track:
				rotating = camera.global_basis
				picked.track = false
		
			var rotating_x: float = camera.global_basis.tdotz(rotating.y)
			var rotating_y: float = camera.global_basis.tdotz(rotating.x)
			
			var dz: float = 0.05
			rotating_x -= clamp(rotating_x, -dz, dz)
			rotating_y -= clamp(rotating_y, -dz, dz)
			
			picked.apply_torque(+rotating_x * 3 * rotating.x)
			picked.apply_torque(-rotating_y * 3 * rotating.y)
		
	elif input_hold_single:
		move_vec = camera.global_basis.y * Vector3(1, 0, 1)
		on = 1 if move_vec.length() > deadzone else 0
		
	if input_double:
		if picked:
			picked.drop()
			picked = null
		elif look_raycast.is_colliding():
			var collison_object: Object = look_raycast.get_collider()
			if collison_object is Pickable:
				picked = collison_object as Pickable
				picked.pick(marker_3d)
				rotating = Basis(Vector3.ZERO, Vector3.ZERO, Vector3.ZERO)
				
		
	elif input_single:
		if look_raycast.is_colliding():
			var collison_object: Object = look_raycast.get_collider()
			if collison_object is Interractable:
				(collison_object as Interractable).interact()
				
		
	elif picked:
		
		path_follow_3d.progress_ratio = clamp(path_follow_3d.progress_ratio - roll * 2 * delta, 0.0, 1.0)
	else:
		path_follow_3d.progress = 0.5
	
		
		
		
	
	velocity.z = move_toward(velocity.z, move_vec.z * movement_velocity * on, delta * 100)
	velocity.x = move_toward(velocity.x, move_vec.x * movement_velocity * on, delta * 100)
	if not is_on_floor():
		velocity += get_gravity() * delta
	move_and_slide()


func _on_hold_timer_timeout() -> void:
	match hold:
		SINGLE:
			print("Single Hold")
			input_hold_single = true
			hold = NONE
		DOUBLE:
			print("Double Hold")
			input_hold_double = true
			hold = NONE
		_:
			pass
	hold = NONE
