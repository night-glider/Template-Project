extends Node3D



func _on_height_value_changed(new_value:float) -> void:
	$wall.scale.y = new_value
	$wall.position.y = new_value / 2.0
