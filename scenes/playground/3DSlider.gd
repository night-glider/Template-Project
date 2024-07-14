@tool
extends Node3D

signal value_changed(new_value:float)

@onready var up := $up
@onready var down := $down
@onready var label_node := $label
@onready var value_node := $value

@export var min_value:float = 1
@export var max_value:float = 9999
@export var value:float = 1:
	set(val):
		value = clamp(val, min_value, max_value)
		if not is_inside_tree():
			await ready
		value_node.text = str(value) + tr(value_postfix)
		value_changed.emit(value)
@export var value_postfix := "":
	set(val):
		value_postfix = val
		if not is_inside_tree():
			await ready
		value_node.text = str(value) + tr(value_postfix)
@export var step:float = 1
@export var label:String = "LABEL":
	set(val):
		label = val
		if not is_inside_tree():
			await ready
		label_node.text = val
@export var label_size:float = 0.2:
	set(val):
		label_size = val
		if not is_inside_tree():
			await ready
		up.position.x = label_size
		down.position.x = -label_size


func _process(delta:float) -> void:
	if not Engine.is_editor_hint() and Input.is_action_just_pressed("GUI_interact") and up.modulate == Color.YELLOW:
		value += step
	if not Engine.is_editor_hint() and Input.is_action_just_pressed("GUI_interact") and down.modulate == Color.YELLOW:
		value -= step

func _on_up_hit_box_mouse_entered() -> void:
	up.modulate = Color.YELLOW

func _on_down_hit_box_area_entered(area:Area3D) -> void:
	down.modulate = Color.YELLOW


func _on_down_hit_box_area_exited(area:Area3D) -> void:
	down.modulate = Color.WHITE


func _on_up_hit_box_area_entered(area:Area3D) -> void:
	up.modulate = Color.YELLOW


func _on_up_hit_box_area_exited(area:Area3D) -> void:
	up.modulate = Color.WHITE
