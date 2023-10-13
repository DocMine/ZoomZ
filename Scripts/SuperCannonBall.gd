extends Node2D
# 这是一个效果,打完就自己消失，不应该依赖其他东西

@onready var WarningSprite:Sprite2D = $warningShap
@onready var LaunchTimer:Timer = $LaunthTimer
@onready var TimerLabel:Label = $TimerLabel
@onready var SoundPlayer:AudioStreamPlayer = $AudioStreamPlayer

const launchStream = preload("res://Audios/weapons/launch.wav")

var BulletScene:PackedScene = load("res://Scenes/FireBall.tscn") # 火球
var bullet:Area2D


var LaunchDone:bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	LaunchTimer.one_shot = true
	LaunchTimer.start(2)
	LaunchTimer.connect("timeout", _on_launchTimeout)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if not LaunchDone:
		launchPart()
	else:
		UpdateBullet()
	

func launchPart():
	WarningSprite.offset.x = WarningSprite.get_rect().size.x / 2
	WarningSprite.scale.x = lerp(WarningSprite.scale.x, 0.8,0.05)
	TimerLabel.text = str(LaunchTimer.time_left)
	
func makeFireBall():
	bullet = BulletScene.instantiate()
	add_child(bullet)
	LaunchDone = true

func UpdateBullet():
	bullet.position.x += 10
	for body in bullet.get_overlapping_bodies():
		if body.is_in_group("zombie"):
			body.die()
	
func _on_launchTimeout():
	# 发射完成后为子弹及计时，到时间删除自身和子弹(作为子节点)
	makeFireBall()
	WarningSprite.queue_free()
	TimerLabel.queue_free()
	SoundPlayer.stream = launchStream
	SoundPlayer.play()
	await get_tree().create_timer(10).timeout
	queue_free()
