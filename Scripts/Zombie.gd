extends CharacterBody2D


const SPEED = 150.0

@onready var navi:NavigationAgent2D = $NavigationAgent2D
@onready var shape:Node2D = $Shape
@onready var HitBox:Area2D = $Shape/Hit_Box
@onready var HitTimer:Timer = $HitTimer
@onready var ParticleHit:GPUParticles2D = $Shape/GPUParticles2D
@onready var SoundPlayer:AudioStreamPlayer = $AudioStreamPlayer
@onready var DetectArea:Area2D = $DetectArea


@export var CheseTarget:Node2D = Node2D.new()

const AttackStream = preload("res://Audios/zattack.wav")

var damage:int = 15
var HitDelay:float = 0.5
var HaveTarget:bool = false

func _ready():
	navi.target_position = CheseTarget.global_position
	HitTimer.connect("timeout",Checkhit)
	HitTimer.wait_time = HitDelay
	pass

func _physics_process(_delta):
	if HaveTarget:
		navi.target_position = CheseTarget.global_position
		await get_tree().process_frame
		velocity = to_local(navi.get_next_path_position()).normalized() * SPEED
		shape.look_at(global_position + velocity)
	else:
		checkPlayer()
	move_and_slide()

func Checkhit():
	for body in HitBox.get_overlapping_bodies():
		if body.is_in_group("player"):
			body.GetHit(damage)
			HitAnimate()

func HitAnimate():
	ParticleHit.emitting = true
	if not SoundPlayer.playing:
		SoundPlayer.stream = AttackStream
		SoundPlayer.play(0.0)

func die():
	queue_free()
	
func checkPlayer():
	for body in DetectArea.get_overlapping_bodies():
		if body.is_in_group("player"):
			CheseTarget = body
			HaveTarget = true
