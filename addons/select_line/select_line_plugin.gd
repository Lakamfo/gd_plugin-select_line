@tool
extends EditorPlugin

var started_line : int = 0
var selection_line : int = 0

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():
		if Input.is_action_pressed("ui_select_line"):
			if EditorInterface.get_script_editor().get_current_editor() == null:
				return
			
			var code_editor : CodeEdit = EditorInterface.get_script_editor().get_current_editor().get_base_editor()
			var line : int = code_editor.get_caret_line()
			var next_column : int = (
				code_editor.get_line(line).length()
				if code_editor.get_line(line + 1).length() < code_editor.get_line(line).length() 
				else code_editor.get_line(line + 1).length()
			)
			
			if ((selection_line + started_line) != line + 1) or !code_editor.has_selection(0):
				selection_line = 0
			
			if selection_line <= 0:
				started_line = line
			
			code_editor.select(started_line, 0, started_line + selection_line, next_column)
			code_editor.set_caret_line(started_line + selection_line)
			code_editor.set_caret_column(0)
			
			selection_line += 1

func _enter_tree() -> void:
	# Adds a action to InputMap
	var event = InputEventKey.new()
	
	event.keycode = 74 # 74 = J
	event.ctrl_pressed = true
	
	InputMap.add_action("ui_select_line")
	InputMap.action_add_event("ui_select_line", event)
	
	var command_palette = EditorInterface.get_command_palette()
	var command_callable = Callable(self, "dummy")
	
	command_palette.add_command("Select Line", "Script Text Editor/Select Line", command_callable, "Ctrl+J")

func _exit_tree() -> void:
	var command_palette = EditorInterface.get_command_palette()
	
	command_palette.remove_command("Select Line")

func dummy():
	#Command callable
	pass
