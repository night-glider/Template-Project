extends Node

const CONFIG_PATH := "user://settings.cfg"
const MAIN_OPTIONS:PackedStringArray = [
	"mouse_sensitivity", 
	"music_volume", 
	"sounds_volume", 
	"fullscreen",
	"language"]

var mouse_sensitivity:float = 0.1
var music_volume:float = 1:
	set(val):
		music_volume = val
		AudioServer.set_bus_volume_db(1, linear_to_db(music_volume))
var sounds_volume:float = 1:
	set(val):
		sounds_volume = val
		AudioServer.set_bus_volume_db(2, linear_to_db(sounds_volume))
var fullscreen:bool = false:
	set(val):
		if val == fullscreen:
			return
		fullscreen = val
		if fullscreen:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
var language:String = "en":
	set(val):
		TranslationServer.set_locale(val)
		language = val

func _ready() -> void:
	load_from_disk()

func load_from_disk() -> void:
	var config := ConfigFile.new()
	config.load(CONFIG_PATH)
	
	for option in MAIN_OPTIONS:
		var val:Variant = config.get_value("main", option, get(option))
		set(option, val)


func save_to_disk() -> void:
	var config := ConfigFile.new()
	
	for option in MAIN_OPTIONS:
		config.set_value("main", option, get(option))
	config.save(CONFIG_PATH)
