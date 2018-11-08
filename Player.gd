extends KinematicBody2D

# Declare member variables here.
var speed = 200
var hold = 0
var copies = []

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(3):
		copies.append($CollisionShape2D.duplicate())
		add_child(copies[i]);
		#$CollisionShape2D.get_transform().translated(Vector2(0,0))
		#$CollisionShape2D.position = 
	copies.append($CollisionShape2D)
	copies[0].position = Vector2(640,480);
	copies[1].position = Vector2(0,480);
	copies[2].position = Vector2(640,0);
	copies[3].position = Vector2(0,0);
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
		for i in range(4):
			copies[i].get_child(0).flip_h = false
	if Input.is_key_pressed(KEY_LEFT):
		vel.x = -1
		for i in range(4):
			copies[i].get_child(0).flip_h = true
	if Input.is_key_pressed(KEY_UP):
		vel.y = -1
	if Input.is_key_pressed(KEY_DOWN):
		vel.y = 1
	if vel == Vector2(0,0):
		for i in range(4):
			copies[i].get_child(0).animation = "stand"
		return
	for i in range(4):
		copies[i].get_child(0).animation = "run"

	position += speed * vel.normalized() * delta
	if position.x < -440:
		position.x += 640
	elif position.x > 440:
		position.x -= 640
	if position.y < -280:
		position.y += 480
	elif position.y > 280:
		position.y -= 480
	#position.x = min(max(position.x,0),640)
	#position.y = min(max(position.y,0),480)
