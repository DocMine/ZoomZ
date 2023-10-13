extends VBoxContainer

@onready var PlayBut:Button = $Play
@onready var ExitBut:Button = $Exit

@export var GameScene:PackedScene = preload("res://Scenes/Level_1.tscn")
@export var OptionScene:PackedScene = preload("res://PrefebScenes_G42/MainScene/Scenes/ActiveButton.tscn")
@export var AboutScene:PackedScene = preload("res://PrefebScenes_G42/MainScene/Scenes/ActiveButton.tscn")

func _ready():
	PlayBut.pressed.connect(on_PlayBut_Pressed)
	ExitBut.pressed.connect(on_ExitBut_Pressed)
	

func on_PlayBut_Pressed():
	print("Play")
	get_tree().change_scene_to_packed(GameScene)
	pass
	
func on_ExitBut_Pressed():
	print("exitbut")
	get_tree().quit()
	pass
