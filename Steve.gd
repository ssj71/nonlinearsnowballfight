extends Node2D

var tim
var index

# Steve is Strategic (but not yet actually)

# Called when the node enters the scene tree for the first time.
func _ready():
	var p = load("res://Player.tscn").instance()
	add_child(p)
	p.runspeed = 170
	randomize()
	var d = Vector2( 2*(randi()%2)-1, 2*(randi()%2)-1 )
	p.set_direction(d.normalized())
	tim = Timer.new()
	tim.connect( "timeout", self, "_ding")
	tim.wait_time = .5
	add_child(tim)
	#tim.set_wait_time(.5)
	tim.start()
	pass # Replace with function body.



func set_color(c):
	$Player.set_color(c)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _ding():
	var r = randi()%2
	if(r == 0):
		var d = Vector2( (randi()%3)-1, (randi()%3)-1 )
		$Player.set_direction(d.normalized())
	elif(r == 1):
		$Player.windup = !$Player.windup