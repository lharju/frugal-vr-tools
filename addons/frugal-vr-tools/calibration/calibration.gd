extends Node3D

var calibration_state: int = 0
enum {NONE, DISPLAY_TO_LENS, DISPLAY_WIDTH, IOD, K1, K2}

@onready var camera: XRCamera3D = $XROrigin3D/XRCamera3D
@onready var label_3d: Label3D = $XROrigin3D/XRCamera3D/Label3D
@onready var sprite_3d: Sprite3D = $XROrigin3D/XRCamera3D/Sprite3D


func _unhandled_input(event):
	if event is InputEventScreenTouch:
		var screen_touch := event as InputEventScreenTouch
		if screen_touch.pressed:
			calibration_state += 1
			sprite_3d.show()
			label_3d.show()

func _ready() -> void:
	calibration_state = 0
	sprite_3d.hide()
	label_3d.hide()
			
func _process(delta: float) -> void:	
	# TODO, determine optimal calibration order
	# TODO, determine reasonable ranges for calibration parameters	
	var pitch: float = camera.global_basis.tdotz(Vector3.UP)
	match(calibration_state):
		NONE:
			pass
		DISPLAY_TO_LENS:
			FrugalVRManager._interface.display_to_lens = 4.0 + 2.0 * pitch
			label_3d.text = "DtL\n%.03f" % FrugalVRManager._interface.display_to_lens
		DISPLAY_WIDTH:
			FrugalVRManager._interface.display_width = 14.5 + 4.0 * pitch
			label_3d.text = "DW\n%.03f" % FrugalVRManager._interface.display_width
		IOD:
			FrugalVRManager._interface.iod = 6.0 + 4.0 * pitch
			label_3d.text = "iod\n%.03f" % FrugalVRManager._interface.iod
		K1:
			FrugalVRManager._interface.k1 = 0.215 + 0.5 * pitch	
			label_3d.text = "k1\n%.03f" % FrugalVRManager._interface.k1
		K2:
			FrugalVRManager._interface.k2 = 0.215 + 0.5 * pitch
			label_3d.text = "k2\n%.03f" % FrugalVRManager._interface.k2
		_:
			FrugalVRManager.save_properties()
			FrugalVRManager.end_calibration()
