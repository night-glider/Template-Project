extends Control

var prev_mouse_mode := Input.MOUSE_MODE_VISIBLE

func _ready() -> void:
	visible = false
	$settings.visible = false

func _process(delta:float) -> void:
	if Input.is_action_just_pressed("pause"):
		toggle()

func toggle() -> void:
	$settings.update_from_settings()
	if visible:
		Input.mouse_mode = prev_mouse_mode
	else:
		prev_mouse_mode = Input.mouse_mode
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	visible = !visible
	get_tree().paused = visible

func _on_continue_pressed() -> void:
	toggle()

func _on_settings_pressed() -> void:
	$settings.visible = not $settings.visible

func _on_quit_pressed() -> void:
	toggle()
	get_tree().change_scene_to_file("res://scenes/menu/mainMenu.tscn")

func _on_settings_resized() -> void:
	$Panel.size = $settings.size + Vector2(20, 20)
	$Panel.position = $settings.position - Vector2(10, 10)

func _on_settings_visibility_changed() -> void:
	$Panel.visible = $settings.visible

