extends Control

@onready var AmmoLabel:Label = $Label


func _process(_delta):
	AmmoLabel.text = "AMMO LEFT: " + str(GlobalVars.bullets)
	pass
