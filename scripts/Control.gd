extends Control
var is_paused = false setget set_is_paused
var mouse_sensitivity = 0.3
func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		self.is_paused = !is_paused


func set_is_paused(value):
	is_paused = value
	get_tree().paused = is_paused
	visible = is_paused

# Called when the node enters the scene tree for the first time.
func _ready():
	var file = File.new()
	file.open("user://mouse_sensitivity.dat", File.READ)
	var content = file.get_as_text()
	file.close()
	mouse_sensitivity = float(content)
	
	get_node("Options_Menu/HSlider_Mouse_Sensitivity").value = mouse_sensitivity


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	


func _on_Button_pressed():
	get_tree().quit(0)


func _on_resume_butt_pressed():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	self.visible = false
	self.is_paused = false

func _on_options_butt_pressed():
	get_node("Start_Menu").visible = false
	get_node("Options_Menu").visible = true


func _on_HSlider_Mouse_Sensitivity_value_changed(value):
	print(value)
	var file = File.new()
	file.open("user://mouse_sensitivity.dat", File.WRITE)
	file.store_string(str(value))
	file.close()
	get_parent().MOUSE_SENSITIVITY = float(value)


func _on_MainMenu_butt_pressed():
	get_tree().change_scene("res://levels/Main_Menu.tscn")
