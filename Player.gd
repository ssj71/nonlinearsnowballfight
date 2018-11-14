extends Area2D

# Declare member variables here.
var speed = 200
var hold = 0.4
var copies = []
var direction = Vector2(1,0);

func wrap_pos(p):
	var p2 = p
	p2.x = (p.x if p.x>0 else p.x+640.0) if p.x < 640.0 else p.x-640
	p2.y = (p.y if p.y>0 else p.y+480.0) if p.y < 480.0 else p.y-480
	return p2

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
		hold += delta
	elif hold > 0.8:
		var ball = load("res://ball.tscn").instance()
		var Balls = get_node("../Balls")
		ball.position = wrap_pos(position)
		ball.origin = (ball.position/160).floor()
		ball.thrower = self
		ball.vel = min(max(hold,1.1),5)*speed*direction #bounds so that they don't run into their own, and so snowballs don't go forever
		ball.hookup(Balls)
		Balls.add_child(ball)
		hold = 0.6 # preload the hold time so they only have to hold for .5 sec before it makes it faster, but they can't shoot more than 5/sec
	elif hold<0.8:
		hold += delta
		if hold > 0.8:
			hold = 0.8
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

	direction = vel.normalized()
	position += speed * direction * delta
	#shift to another copy if nearing an edge
	if position.x < -440:
		position.x += 640
	elif position.x > 440:
		position.x -= 640
	if position.y < -280:
		position.y += 480
	elif position.y > 280:
		position.y -= 480

#func _notification(what):
#    if (what == NOTIFICATION_PREDELETE):
#		var i = 0
		
		#for i in range(4):
		#copies[i].free()