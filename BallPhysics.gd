extends Node2D

# Declare member variables here. Examples:
const decay = 9000000

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for ball in get_children():
		ball.position += delta*ball.vel
		var dir = ball.vel.normalized()
		#max vel is 1000px/sec, min is 300px/sec
		ball.vel -= delta*dir*(decay/ball.vel.length_squared() + 0)
		#print(ball.vel, ball.vel.normalized(),dir, ball.vel.normalized() == -dir)
		#dir = ball.vel.reverse()
		if ball.vel.length() < 100 or ball.vel.normalized() == -dir:
			remove_child(ball)

