extends Node2D

# Ralf runs
var index

# Called when the node enters the scene tree for the first time.
func _ready():
	var p = load("res://Player.tscn").instance()
	add_child(p)
	p.runspeed = 100
	randomize()
	var d = Vector2( 2*(randi()%2)-1, 2*(randi()%2)-1 )
	p.set_direction(d.normalized())



func set_color(c):
	$Player.set_color(c)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass