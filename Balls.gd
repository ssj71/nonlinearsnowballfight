extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var teleporten = []
var decay = 300

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	for child in get_children():
		child.position += delta*child.vel
		var dir = child.vel.normalized()
		#max vel is 1000px/sec, min is 300px/sec
		child.vel -= delta*decay*dir/child.vel.length_squared()
		
		if child.vel.length() < 1:
			remove_child(child)
		
		
