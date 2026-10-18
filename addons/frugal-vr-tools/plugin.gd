@tool
extends EditorPlugin

const AUTOLOADS: Dictionary[String, String] = {
	"FrugalVRManager": "res://addons/frugal-vr-tools/frugal_vr_manager.gd"
}

func _enable_plugin():
	ProjectSettings.set_setting("xr/shaders/enabled", true)
	ProjectSettings.set_setting("display/window/vsync/vsync_mode", DisplayServer.VSyncMode.VSYNC_DISABLED)
	for key: String in AUTOLOADS.keys():
		add_autoload_singleton(key, AUTOLOADS[key])

func _disable_plugin():
	for key: String in AUTOLOADS.keys():
		remove_autoload_singleton(key)

func _enter_tree():
	pass

func _exit_tree():
	pass
