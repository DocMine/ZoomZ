extends Button

@onready var AudioPlayer = $AudioStreamPlayer

# 音效默认指定，也可以替换
@export var ClickSound:Resource = preload("res://PrefebScenes_G42/MainScene/Audios/rollover1.wav")# 点击音效
@export var FlitInSound:Resource = preload("res://PrefebScenes_G42/MainScene/Audios/click3.wav")# 鼠标掠入音效
@export var FlitOutSound:Resource = preload("res://PrefebScenes_G42/MainScene/Audios/click5.wav")# 鼠标掠出音效

var tween:Tween

# Called when the node enters the scene tree for the first time.
func _ready():
	pivot_offset = size/2
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	pressed.connect(_on_button_pressed)
	pass # Replace with function body.


func _on_mouse_entered():
	AudioPlayer.stream = FlitInSound
	AudioPlayer.play()
	if tween :
		tween.kill()
	tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1.1, 1.1), 0.2)
	pass # Replace with function body.


func _on_mouse_exited():
	AudioPlayer.stream = FlitOutSound
	AudioPlayer.play()
	if tween :
		tween.kill()
	tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1, 1), 0.1)
	pass # Replace with function body.


func _on_button_pressed():
	# 在按钮模板上写功能？将点击信号链接到两个脚本
	AudioPlayer.stream = ClickSound
	AudioPlayer.play()
	print("Button pressed")
	pass
