extends CharacterBody2D


const SPEED = 300.0

var Hp:int = 100
@onready var shape:Node2D = $shape
@onready var HPBar:ProgressBar = $ProgressBar
@onready var SoundPlayer:AudioStreamPlayer = $AudioStreamPlayer
@onready var Muzzle:Node2D = $shape/muzzle
@onready var FreezeTimer:Timer = $FreezeTgimer

const HitSoundStream = preload("res://Audios/Human_Hitted.wav")
const DieSoundStream = preload("res://Audios/Human_die.wav")
const CannonBall = preload("res://Scenes/SuperCannonBall.tscn")

const ChargeStream = preload("res://Audios/weapons/charge.wav")


var FreezeTime:float = 2

var Is_Dead:bool = false
var CanMove:bool = true # 用来限制玩家时候能移动


func _ready():
	FreezeTimer.connect("timeout", _on_FreezeTimeout)

func _physics_process(_delta):
	if CanMove:
		var direction =Vector2(Input.get_axis("ui_left", "ui_right"),Input.get_axis("ui_up", "ui_down")) 
		if direction:
			velocity = direction * SPEED
		else:
			velocity = velocity.lerp(Vector2.ZERO,0.1)
	move_and_slide()

func _process(_delta):
	LookMounse()
	UpdateUI()
	if Input.is_action_just_pressed("ui_accept"):
		if GlobalVars.bullets>0:
			shoot()
	pass

func LookMounse():
	if CanMove:
		shape.look_at(get_global_mouse_position())

func UpdateUI():
	HPBar.value = Hp

func GetHit(Damage:int):
	print("hitted")
	if not Is_Dead:
		if not SoundPlayer.playing:
			SoundPlayer.stream = HitSoundStream
			SoundPlayer.play(0.0)
		Hp -= Damage
		if Hp < 0:
			Is_Dead = true
			Die()
			await SoundPlayer.finished
			get_tree().change_scene_to_packed(load("res://PrefebScenes_G42/MainScene/MainScene.tscn"))
		
func Die():
	SoundPlayer.stream = DieSoundStream
	SoundPlayer.play(0.0)


func shoot():
	# 射击过程中无法移动
	GlobalVars.bullets-=1
	var c = CannonBall.instantiate()
	get_tree().current_scene.add_child(c)
	c.global_position = Muzzle.global_position
	c.rotation = shape.rotation
	SoundPlayer.stream = ChargeStream
	SoundPlayer.play(0.0)
	FreezeTimer.start(FreezeTime)
	CanMove = false
	velocity = Vector2.ZERO


func _on_FreezeTimeout():
	CanMove = true
