extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var nonlinearity = 1
var telemap = []
# 1 - teleports shuffle seprately for vert/horiz, directions remain the same
# 2 - all sides shuffle
# 3 - teleports are non-transitive a->b but b->c

const VERTICAL_ID_OFFSET = 12 #12 horizontal ids before the vertical ones
const NEGATIVE_ID_OFFSET = 24 #24 ids, we store negative in the array after positive
const TELEPORT_SIZE = 160 # size of side of each square bordered by teleports
const TELEPORT_OFFSET = TELEPORT_SIZE/2 # offset of position to center teleport
const TELEPORTS_PER_ROW = 4
const WINDOW_WIDTH = 640 # pixels
const WINDOW_HEIGHT = 480 #pixels

#each teleport has an id based on its position, this makes shuffling easier
#ids are assigned to all horizontal teleports, then all vertical
#these are used for mapping
#    0   1   2   3
# 12   13  14  15  12
#    4   5   6   7
# 16   17  18  19  16
#    8   9   10  11
# 20   21  22  23  20
#    0   1   2   3

func teleid(pos):
	var h = (int(pos.x)%TELEPORT_SIZE)/TELEPORT_OFFSET*((pos.x-TELEPORT_OFFSET)/TELEPORT_SIZE + (int(pos.y)%WINDOW_HEIGHT)*TELEPORTS_PER_ROW/TELEPORT_SIZE) # horizontal ports
	var v = (int(pos.y)%TELEPORT_SIZE)/TELEPORT_OFFSET*((int(pos.x)%WINDOW_WIDTH)/TELEPORT_SIZE + (pos.y-TELEPORT_OFFSET)*TELEPORTS_PER_ROW/TELEPORT_SIZE + VERTICAL_ID_OFFSET) #vertical ports
	return v + h
	
func telepos(id):
	var x
	var y
	if(id<VERTICAL_ID_OFFSET):
		#horizontal
		x = (id*TELEPORT_SIZE+TELEPORT_OFFSET)%WINDOW_WIDTH
		y = ((id/TELEPORTS_PER_ROW)*TELEPORT_SIZE)
	else:
		#vertical
		id -= VERTICAL_ID_OFFSET
		x = (id*TELEPORT_SIZE)%WINDOW_WIDTH
		y = ((id/TELEPORTS_PER_ROW)*TELEPORT_SIZE+TELEPORT_OFFSET)
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
		telemap = range(2*NEGATIVE_ID_OFFSET)
		for i in range(2*NEGATIVE_ID_OFFSET):
			telemap[i] = -1
		var i = 0
		while i < NEGATIVE_ID_OFFSET:
			var repull = true
			while repull:
				var offset = i
				if i >= VERTICAL_ID_OFFSET:
					offset -= VERTICAL_ID_OFFSET
				var v = randi()%(VERTICAL_ID_OFFSET-offset) + i # limit the range to disclude already assigned values
				if v == i or telemap[v] != -1:
					repull = true
				else:
					repull = false
					telemap[i] = v
					telemap[v] = i
					#and the negative
					telemap[i+NEGATIVE_ID_OFFSET] = v+NEGATIVE_ID_OFFSET
					telemap[v+NEGATIVE_ID_OFFSET] = i+NEGATIVE_ID_OFFSET
			while telemap[i] != -1 and i < NEGATIVE_ID_OFFSET:
				i += 1
	#TODO: elif nonlinearity == 2:
	print(telemap)

# Called when the node enters the scene tree for the first time.
func _ready():
	# create the teleports
	for x in range(4):
		for y in range (3):
			newtele(TELEPORT_SIZE*x, TELEPORT_SIZE*y+TELEPORT_OFFSET, 1, TELEPORT_OFFSET-4) #tall skinny teleports on sides of squares
			newtele(TELEPORT_SIZE*x+TELEPORT_OFFSET, TELEPORT_SIZE*y, TELEPORT_OFFSET-4, 1) #wide teleports on top/bottom of squares
		newtele(TELEPORT_SIZE*x+TELEPORT_OFFSET, WINDOW_HEIGHT, TELEPORT_OFFSET-4, 1)
	for y in range (3):
		newtele(WINDOW_WIDTH, TELEPORT_SIZE*y+TELEPORT_OFFSET, 1, TELEPORT_OFFSET-4)
	shuffle()
	
	#test that the id<->pos conversions are right
	#for i in range(24):
	#	print(i,teleid(telepos(i)))
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

