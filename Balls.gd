extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var teleporten = []
var decay = 1000

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for ball in get_children():
		ball.position += delta*ball.vel
		var dir = ball.vel.normalized()
		#max vel is 1000px/sec, min is 300px/sec
		ball.vel -= delta*decay*dir/ball.vel.length_squared()
		if ball.vel.length() < 1:
			remove_child(ball)
	
