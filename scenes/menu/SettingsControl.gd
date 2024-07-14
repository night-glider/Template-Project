extends GridContainer

const lanuages_to_codes = {
	"en": 0,
	"ru": 1
}

const codes_to_languages = {
	0: "en",
	1: "ru"
}

func _ready() -> void:
	update_from_settings()

func update_from_settings() -> void:
	$MouseSens.value = Settings.mouse_sensitivity
	$music.value = Settings.music_volume
	$sounds.value = Settings.sounds_volume
	$fullscreen.button_pressed = Settings.fullscreen
	$language.selected = lanuages_to_codes.get(Settings.language, 0)

func _on_mouse_sens_value_changed(value:float) -> void:
	Settings.mouse_sensitivity = value


func _on_music_value_changed(value:float) -> void:
	Settings.music_volume = value


func _on_sounds_value_changed(value:float) -> void:
	Settings.sounds_volume = value


func _on_fullscreen_toggled(toggled_on:bool) -> void:
	Settings.fullscreen = toggled_on


func _on_cancel_pressed() -> void:
	Settings.load_from_disk()
	update_from_settings()
	visible = false

func _on_apply_pressed() -> void:
	Settings.save_to_disk()
	visible = false


func _on_language_item_selected(index: int) -> void:
	Settings.language = codes_to_languages.get(index, "en")
