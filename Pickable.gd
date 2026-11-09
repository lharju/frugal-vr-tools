extends RigidBody3D
class_name Pickable


var track_object: Marker3D = null
var track: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _physics_process(_delta: float) -> void:
	if track_object and track:
		var dir := track_object.global_position - self.global_position
		#self.apply_constant_force(dir * 50. * exp(dir.length())) a
		self.apply_force(dir * 50. * exp(dir.length()))
	
	
func pick(a: Marker3D):
	track = true
	angular_damp = 0.95
	linear_damp = 0.95
	track_object = a
	
func drop():
	track = false
	angular_damp = 0.0
	linear_damp = 0.0
	track_object = null
	
