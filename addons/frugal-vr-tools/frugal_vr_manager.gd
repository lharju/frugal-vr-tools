@tool
extends Node

## TODO
##	1. Initilize vr interface
##	2. Create calibration sequence
##		2.1 Room
##		2.2 Menu
##		2.3 Input

const _config_path: String = "user://xr_interface_properties.cfg" 
const _calibration_scene: PackedScene = preload("uid://cabtd1xdqqqwa")

var _interface: MobileVRInterface = null
var _config: ConfigFile = null
var _previous_scene: Node = null

var eye_height: float = 1.5:
	set(a):
		if _interface:
			eye_height = a
			_interface.eye_height = eye_height

func save_properties():
	_config.set_value("config", "display_to_lens", _interface.display_to_lens)
	_config.set_value("config", "display_width", _interface.display_width)
	_config.set_value("config", "iod", _interface.iod)
	_config.set_value("config", "k1", _interface.k1)
	_config.set_value("config", "k2", _interface.k2)
	_config.set_value("config", "offset_rect", _interface.offset_rect)
	_config.save(_config_path)
	
func load_properties():
	_config.load(_config_path)
	_interface.display_to_lens	= _config.get_value("config", "display_to_lens", 4.0)
	_interface.display_width	= _config.get_value("config", "display_width", 14.5)
	_interface.iod				= _config.get_value("config", "iod", 1.85)
	_interface.k1				= _config.get_value("config", "k1", 0.215)
	_interface.k2				= _config.get_value("config", "k2", 0.215)
	_interface.offset_rect		= _config.get_value("config", "offset_rect", Rect2(0, 0, 1, 1))	


func load_calibration()-> void:
	_previous_scene = get_tree().current_scene.duplicate()
	get_tree().change_scene_to_packed(_calibration_scene)

func end_calibration() -> void:
	get_tree().change_scene_to_node(_previous_scene)

func _ready() -> void:
	# If not running on android, skip creating the XR interface
	if not OS.has_feature("android"):
		return

	# Init the XR interface
	_interface = XRServer.find_interface("Native mobile") as MobileVRInterface
	_interface.initialize()
	if _interface and _interface.is_initialized():
		get_viewport().use_xr = true
	else:
		# HACK
		# should handle failure to init interface
		return
		
	# Load config file if it exists, else create it with default values
	_config = ConfigFile.new()
	if FileAccess.file_exists(_config_path):
		load_properties()
	else:
		save_properties()
