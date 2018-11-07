extends KinematicBody2D

# Declare member variables here.
var speed = 200
var hold = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_key_pressed(KEY_SPACE):
		hold = hold + delta
	elif hold != 0:
		#var ball = RigidBody2D
		#var sp = Sprite
		#ball.x = position.x
		#ball.y = position.y
		#sp.
		#ball.add_child( Sprite )
		#get_parent().add_child(ball)
		hold = 0
	var vel = Vector2(0, 0)
	if Input.is_key_pressed(KEY_RIGHT):
		vel.x = 1
		$AnimatedSprite.flip_h = false
	if Input.is_key_pressed(KEY_LEFT):
		vel.x = -1
		$AnimatedSprite.flip_h = true
	if Input.is_key_pressed(KEY_UP):
		vel.y = -1
	if Input.is_key_pressed(KEY_DOWN):
		vel.y = 1
	if vel == Vector2(0,0):
		$AnimatedSprite.animation = "stand"
		return
	$AnimatedSprite.animation = "run"

	position = position + speed * vel.normalized() * delta
