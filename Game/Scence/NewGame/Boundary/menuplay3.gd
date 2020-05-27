extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_play_pressed():
	get_tree().change_scene("res://Scence/NewGame/Boundary/Game3.tscn")


func _on_highscore_pressed():
	$Popup/PopupMenu.show()
	_load()
func _load():
	var file = File.new()
	file.open("res://Assets/Score/score_boundary.txt", File.READ)
	var line
	line = file.get_as_text()
	file.close()
	print(line)
	get_node("Popup/PopupMenu/RichTextLabel").text = str(line)



func _on_Button_pressed():
	$Popup/PopupMenu.hide()
	pass # Replace with function body.


func _on_quit_pressed():
	get_tree().change_scene("res://Scence/NewGame/menuNewGame.tscn")
