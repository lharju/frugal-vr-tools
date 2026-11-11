extends Area3D

@onready var marker_3d: Marker3D = $Marker3D

func _on_body_entered(body: Node3D) -> void:
	if body is Pickable:
		body.global_position = marker_3d.global_position
