extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var nonlinearity = 1
var telemap = []
# 1 - teleports shuffle seprately for vert/horiz, directions remain the same
# 2 - all sides shuffle
# 3 - teleports are non-transitive a->b but b->c

#each teleport has an id based on its position, this makes shuffling easier
#ids are assigned to all horizontal teleports, then all vertical
#    0   1   2   3
# 12   13  14  15  12
#    4   5   6   7
# 16   17  18  19  16
#    8   9   10  11
# 20   21  22  23  20
#    0   1   2   3

func teleid(pos):
	var h = (int(pos.x)%160)/80*((pos.x-80)/160 + (int(pos.y)%480)/40) # horizontal ports
	var v = (int(pos.y)%160)/80*((int(pos.x)%640)/160 + (pos.y-80)/40 + 12) #vertical ports
	return v + h
	
func telepos(id):
	var x
	var y
	if(id<12):
		#horizontal
		x = (id*160+80)%640
		y = ((id/4)*160)
	else:
		#vertical
		id -= 12
		x = (id*160)%640
		y = ((id/4)*160+80)
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
	randomize()
	if nonlinearity == 1:
		#shuffle the horizontal and vertical teleports separately
		telemap = range(48)
		for i in range(48):
			telemap[i] = -1
		var i = 0
		while i < 24:
			var repull = true
			while repull:
				var offset = i
				if i >= 12:
					offset -= 12
				var v = randi()%(12-offset) + i
				if v == i or telemap[v] != -1:
					repull = true
				else:
					repull = false
					telemap[i] = v
					telemap[v] = i
					#and the negative
					telemap[i+24] = v+24
					telemap[v+24] = i+24
			while telemap[i] != -1 and i < 24:
				i += 1
	#TODO: elif nonlinearity == 2:
	print(telemap)

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
	shuffle()
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

