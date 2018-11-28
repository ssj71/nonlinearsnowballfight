extends Area2D

var hold = 0.4
var copies = []
var direction = Vector2(1,0)
var stop = true
var windup = false
var index
var runspeed = SPEED

const SPEED = 200
const WINDOW_WIDTH = 720 # pixels
const WINDOW_HEIGHT = 480 #pixels

#find on-screen position (actual may be off screen and only a copy is in view)
func wrap_pos(p):
	var p2 = p
	p2.x = (p.x if p.x>0 else p.x+WINDOW_WIDTH) if p.x < WINDOW_WIDTH else p.x-WINDOW_WIDTH
	p2.y = (p.y if p.y>0 else p.y+WINDOW_HEIGHT) if p.y < WINDOW_HEIGHT else p.y-WINDOW_HEIGHT
	return p2

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(true)
	for i in range(3):
		copies.append($CollisionShape2D.duplicate())
		add_child(copies[i]);
		#$CollisionShape2D.get_transform().translated(Vector2(0,0))
		#$CollisionShape2D.position = 
	copies.append($CollisionShape2D)
	copies[0].position = Vector2(WINDOW_WIDTH, WINDOW_HEIGHT);
	copies[1].position = Vector2(0, WINDOW_HEIGHT);
	copies[2].position = Vector2(WINDOW_WIDTH, 0);
	copies[3].position = Vector2(0, 0);
	
func set_color(c):
	for i in range(4):
		copies[i].get_node("AnimatedSprite").modulate = c

func set_direction(d):
	if d.length() != 0:
		stop = false
		direction = d.normalized()
		if d.x > 0:
			for i in range(4):
				copies[i].get_child(0).flip_h = false
				copies[i].get_child(0).animation = "run"
		elif d.x < 0:
			for i in range(4):
				copies[i].get_child(0).flip_h = true
				copies[i].get_child(0).animation = "run"
		else:
			for i in range(4):
				copies[i].get_child(0).animation = "run"
	else:
		stop = true
		for i in range(4):
			copies[i].get_child(0).animation = "stand"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if windup:
		hold += delta
	elif hold > 0.8:
		var ball = load("res://ball.tscn").instance()
		var Balls = get_node("../../BallPhysics")
		if Balls == null:
			Balls = get_node("../../../BallPhysics")
		ball.position = wrap_pos(position)
		ball.origin = (ball.position/160).floor()
		ball.thrower = self
		ball.vel = min(max(hold,1.1),2.5)*SPEED*direction #bounds so that they don't run into their own, and so snowballs don't go forever
		Balls.add_child(ball)
		hold = 0.6 # preload the hold time so they only have to hold for .5 sec before it makes it faster, but they can't shoot more than 5/sec
	elif hold<0.8:
		hold += delta
		if hold > 0.8:
			hold = 0.8
	if stop:
		return

	position += runspeed * direction * delta
	#shift to another copy if nearing an edge
	if position.x < -.8*WINDOW_WIDTH:
		position.x += WINDOW_WIDTH
	elif position.x > .8*WINDOW_WIDTH:
		position.x -= WINDOW_WIDTH
	if position.y < -.8*WINDOW_HEIGHT:
		position.y += WINDOW_HEIGHT
	elif position.y > .8*WINDOW_HEIGHT:
		position.y -= WINDOW_HEIGHT

#func _notification(what):
#    if (what == NOTIFICATION_PREDELETE):
#		var i = 0
		
		#for i in range(4):
		#copies[i].free()