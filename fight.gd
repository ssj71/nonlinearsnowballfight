extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var ctl = []

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(4):
		ctl.append([])
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var d = Vector2(0,0)
	if Input.is_key_pressed(KEY_RIGHT):
		d.x = 1
	if Input.is_key_pressed(KEY_LEFT):
		d.x = -1
	if Input.is_key_pressed(KEY_UP):
		d.y = -1
	if Input.is_key_pressed(KEY_DOWN):
		d.y = 1
	#todo, what if p1 is dead
	if $Players.get_node("Player0") != null:
		$Players/Player0.set_direction(d)
		if Input.is_key_pressed(KEY_SPACE):
			$Players/Player0.windup = true
		else:
			$Players/Player0.windup = false
	#if $Players.get_child_count() == 1:
		#round over

func kill(index):
	for i in range($Players.get_child_count()):
		if $Players.get_child(i).index == index:
			$Players.get_child(i).free()
			break
	if $Players.get_child_count() == 1:
		get_node("..").winner($Players.get_child(0).index)
	

