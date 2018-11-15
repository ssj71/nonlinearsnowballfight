extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var nonlinearity = 1
var telemap = []
# 1 - squares shuffle, directions remain the same
# 2 - all sides shuffle
# 3 - teleports are non-transitive a->b but b->c

#each teleport has an id based on its position, this makes shuffling easier
#ids are assigned to all horizontal teleports, then all vertical
#    0   1   2   3
# 16   17  18  19  20
#    4   5   6   7
# 21   22  23  24  25
#    8   9   10  11
# 26   27  28  29  30
#    12  13  14  15

func teleid(pos):
	var h = (int(pos.x)%160)/80*((pos.x-80)/160 + (pos.y)/40)
	var v = (int(pos.y)%160)/80*((pos.x)/160 + (pos.y-80)/32 + 16)
	return v + h
	
func telepos(id):
	var x
	var y
	if(id<16):
		#horizontal
		x = (id*160+80)%640
		y = ((id/4)*160)
	else:
		#vertical
		id -= 16
		x = (id*160)%800
		y = ((id/5)*160+80)
	return Vector2(x,y)

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
	
func shuffle():
	if nonlinearity == 1:
		#shuffle the horizontal and vertical teleports separately
		var h = range(16)
		var v = range(16,31)
		h.shuffle()
		v.shuffle()
		telemap = [h, v]
	#TODO: elif nonlinearity == 2:
	

# Called when the node enters the scene tree for the first time.
func _ready():
	shuffle()
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

