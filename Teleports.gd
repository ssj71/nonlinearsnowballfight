extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func newtele(x,y,w,h):
	var tel = Area2D.new()
	tel.position.x = x
	tel.position.y = y
	tel.name = "Teleport"
	var col = CollisionShape2D.new()
	col.shape = RectangleShape2D.new()
	col.shape.extents.x = w
	col.shape.extents.y = h
	#var sp = Sprite.new() #tmp sprite to make sure its where we expect
	#sp.texture = load("res://icon.png")
	#col.add_child(sp)
	tel.add_child(col)
	add_child(tel)
	

# Called when the node enters the scene tree for the first time.
func _ready():
	# create the teleports
	for x in range(4):
		for y in range (3):
			newtele(160*x,160*y+80,1,76)
			newtele(160*x+80,160*y,76,1)
		newtele(160*x+80,480,76,1)
	for y in range (3):
		newtele(640,160*y+80,1,76)
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

