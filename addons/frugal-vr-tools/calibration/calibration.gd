extends Node3D

enum CalibrationState {ROOM, DISPLAY_TO_LENS, DISPLAY_WIDTH, IOD, K1, K2}
var calibration_state = CalibrationState.ROOM:
	set(a):
		calibration_state = a
		match calibration_state:
			CalibrationState.ROOM:
				room.show()
				circle.hide()
				square.hide()
				label_3d.hide()
			CalibrationState.DISPLAY_TO_LENS:
				room.hide()
				circle.hide()
				square.hide()
				label_3d.show()
			CalibrationState.DISPLAY_WIDTH:
				room.hide()
				circle.hide()
				square.hide()
				label_3d.show()
			CalibrationState.IOD:
				room.hide()
				circle.show()
				square.hide()
				label_3d.show()
			CalibrationState.K1:
				room.hide()
				circle.hide()
				square.show()
				label_3d.show()
			CalibrationState.K2:
				room.hide()
				circle.hide()
				square.show()
				label_3d.show()
				
@onready var room: MeshInstance3D = $Room

@onready var camera: XRCamera3D = $XROrigin3D/XRCamera3D
@onready var label_3d: Label3D = $XROrigin3D/XRCamera3D/Label3D

@onready var square: Sprite3D = $XROrigin3D/XRCamera3D/Square
@onready var circle: Sprite3D = $XROrigin3D/XRCamera3D/Circle



func _unhandled_input(event):
	if event is InputEventScreenTouch:
		var screen_touch := event as InputEventScreenTouch
		if screen_touch.pressed:
			calibration_state += 1

func _ready() -> void:
	calibration_state = CalibrationState.ROOM
			
func _process(delta: float) -> void:	
	# TODO, determine optimal calibration order
	# TODO, determine reasonable ranges for calibration parameters
	var pitch: float = camera.global_basis.tdotz(Vector3.UP)
	match(calibration_state):
		CalibrationState.ROOM:
			pass
		CalibrationState.DISPLAY_TO_LENS:
			FrugalVRManager._interface.display_to_lens = 4.0 + 2.0 * pitch
			label_3d.text = "display to lens\n%.03f" % FrugalVRManager._interface.display_to_lens
		CalibrationState.DISPLAY_WIDTH:
			FrugalVRManager._interface.display_width = 14.5 + 4.0 * pitch
			label_3d.text = "display width\n%.03f" % FrugalVRManager._interface.display_width
		CalibrationState.IOD:
			FrugalVRManager._interface.iod = 6.0 + 4.0 * pitch
			label_3d.text = "iod\n%.03f" % FrugalVRManager._interface.iod
		CalibrationState.K1:
			FrugalVRManager._interface.k1 = 0.215 + 0.5 * pitch	
			label_3d.text = "k1\n%.03f" % FrugalVRManager._interface.k1
		CalibrationState.K2:
			FrugalVRManager._interface.k2 = 0.215 + 0.5 * pitch
			label_3d.text = "k2\n%.03f" % FrugalVRManager._interface.k2
		_:
			FrugalVRManager._save_properties()
			FrugalVRManager.end_calibration()
