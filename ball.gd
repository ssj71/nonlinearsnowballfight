extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var vel = Vector2(0,0)
var origin = Vector2(0,0)
var thrower
var teleported = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func hookup(parent):
	$Area2D.connect("area_entered",self,"hit")
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func hit(area):
	print(area.name)
	if area.name == "Player" && area != thrower:
		area.free()
	elif area.name.match("@Teleport@*"):
		#add to teleported list
		teleported = true
		#vel = Vector2(0,0)#kills the ball
		#thrower = null
	