extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var vel = Vector2(0,0)
var origin = Vector2(0,0)
var thrower
var teleported = false

const SNOWBALL_DIAMETER = 15

# Called when the node enters the scene tree for the first time.
func _ready():
	$Area2D.connect("area_entered",self,"hit")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func hit(area):
	if area.name.match("Player*") && area != thrower:
		if teleported:
			print("killing ",area.name,area.index)
			get_node("../..").kill(area.index)
		else:
			print("not killing ",area.name,area.index)
		#we hit something, stop the ball
		vel = vel.normalized()
	elif area.name.match("*Teleport*"):
		teleported = true
		thrower = null #allow friendly fire
		var T = get_node("../../Teleports")
		var id = T.teleid(area.position)
		var to = -1 # teleport out id
		if id < T.VERTICAL_ID_OFFSET:
			#entering a horizontal teleport
			if vel.y > 0:
				#positive
				position.y += SNOWBALL_DIAMETER
				to = T.telemap[id] 
			else:
				#negative
				position.y -= SNOWBALL_DIAMETER
				id += T.NEGATIVE_ID_OFFSET
				to = T.telemap[id] # teleport out id
		else:
			#entering a vertical teleport
			if vel.x > 0:
				#positive
				position.x += SNOWBALL_DIAMETER
				to = T.telemap[id] # teleport out id
			else:
				#negative
				position.x -= SNOWBALL_DIAMETER
				id += T.NEGATIVE_ID_OFFSET
				to = T.telemap[id] # teleport out id
		position += T.telepos(to) - T.telepos(id)
		#vel = Vector2(0,0)#kills the ball
		#thrower = null
	