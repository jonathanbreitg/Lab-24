extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var file_read = File.new()
	file_read.open("user://mouse_sensitivity.dat", File.READ)
	var content = file_read.get_as_text()
	file_read.close()
	get_node("Options_Menu/HSlider_Mouse_Sensitivity").value = float(content)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_HSlider_Mouse_Sensitivity_value_changed(value):
	print(value)
	var file = File.new()
	file.open("user://mouse_sensitivity.dat", File.WRITE)
	file.store_string(str(value))
	file.close()
