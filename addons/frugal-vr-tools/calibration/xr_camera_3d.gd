extends XRCamera3D

func _ready() -> void:
	pass


func _process(delta) -> void:
	var roll = self.global_basis.tdotz(Vector3.UP)
	
	var center: Vector2 = Vector2(0.5, 0.5)
	
	#FrugalVRManager._interface.offset_rect = Rect2(0+roll, 0, 1-2*roll, 1)
	#FrugalVRManager._interface.display_width = 14.0 + roll * 5
