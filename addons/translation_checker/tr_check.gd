@tool
extends EditorPlugin

func _enter_tree() -> void:
	add_tool_menu_item("Check localization for errors", check_translation)

func _exit_tree() -> void:
	remove_tool_menu_item("Check localization for errors")

func check_translation() -> void:
	var all_keys_in_scenes:Array = []
	var all_keys_in_scenes_paths:Array = []
	var all_keys_in_translation:Array = []
	
	var regex := RegEx.new()
	regex.compile("\"[A-Z_][A-Z0-9_]{1,256}\"")
	var files_list:Array = get_all_files("res://")
	for element:String in files_list:
		var file := FileAccess.open(element, FileAccess.READ)
		var content := file.get_as_text()
		file.close()
		
		var result:Array = regex.search_all(content)
		for matches:RegExMatch in result:
			all_keys_in_scenes.append( matches.get_string().rstrip("\"").lstrip("\"") )
			all_keys_in_scenes_paths.append(element)
	
	var file := FileAccess.open("res://localization/general.csv", FileAccess.READ)
	file.get_csv_line()
	while file.get_position() < file.get_length():
		all_keys_in_translation.append( file.get_csv_line()[0] )
	
	var error_message:String = ""
	for i in all_keys_in_scenes.size():
		if not all_keys_in_scenes[i] in all_keys_in_translation:
			error_message += ("ERROR KEY DOES NOT EXITS: <" + all_keys_in_scenes[i]) + ">\n"
			error_message += ("PATH: " + all_keys_in_scenes_paths[i]) + "\n\n"
	
	for element:String in all_keys_in_translation:
		if not element in all_keys_in_scenes:
			error_message += ("KEY <" + element + "> EXISTS BUT IS NOT USED" ) + "\n"
	
	print(error_message)
	if error_message.is_empty():
		OS.alert("No errors! =)")
	else:
		OS.alert(error_message)

func get_all_files(path: String) -> Array:
	var dir := DirAccess.open(path)
	dir.include_hidden = true
	var result:Array = []
	
	if dir != null:
		dir.list_dir_begin()
		var file_name := dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				result.append_array( get_all_files(dir.get_current_dir() + "/" + file_name) )
			else:
				if file_name.get_extension() in ["tscn", "gd"]:
					result.append( dir.get_current_dir() + "/" + file_name )
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access %s." % path)
	return result
