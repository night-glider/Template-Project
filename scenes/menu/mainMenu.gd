extends Control

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	$settings.visible = false

func _on_start_tutorial_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/playground/TestingPlayground.tscn")


func _on_settings_pressed() -> void:
	$settings.visible = not $settings.visible


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_settings_resized() -> void:
	$Panel.size = $settings.size + Vector2(20, 20)
	$Panel.position = $settings.position - Vector2(10, 10)


func _on_settings_visibility_changed() -> void:
	$Panel.visible = $settings.visible
