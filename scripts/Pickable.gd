@tool
extends RigidBody3D
class_name Pickable


@export var object_scale: float = 1.0:
	set(a):
		object_scale = a
		for child in get_children():
			if child is Node3D:
				child.scale = Vector3(object_scale, object_scale, object_scale) 

var track_object: Marker3D = null
var saved_position: Vector3 = Vector3.ZERO
var track: bool = false:
	set(a):
		track = a
		if not track and track_object:
			saved_position = track_object.global_position
		elif track and track_object:
			saved_position = Vector3.ZERO

func _physics_process(_delta: float) -> void:
	if track_object and track:
		var dir: Vector3 = track_object.global_position - self.global_position
		self.apply_force(dir * 50. * exp(dir.length()))
	elif track_object and not track:
		var dir: Vector3 = saved_position - self.global_position
		self.apply_force(dir * 50. * exp(dir.length()))
	

func pick(a: Marker3D):
	track = true
	angular_damp = 10000
	linear_damp = 10
	gravity_scale = 0.0
	track_object = a

func drop():
	track = false
	angular_damp = 0.0
	linear_damp = 0.0
	gravity_scale = 1.0
	track_object = null
