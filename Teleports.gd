extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var nonlinearity = 1
var telemap = []
# 1 - teleports shuffle seprately for vert/horiz, directions remain the same
# 2 - all sides shuffle
# 3 - teleports are non-transitive a->b but b->c

const VERTICAL_ID_OFFSET = int(6) #horizontal ids before the vertical ones
const NEGATIVE_ID_OFFSET = int(12) #total ids, we store negative in the array after positive
const TELEPORT_SIZE = int(240) # size of side of each square bordered by teleports
const TELEPORT_OFFSET = int(120) # offset of position to center teleport
const TELEPORTS_PER_ROW = int(3)
const TELEPORTS_PER_COL = int(2)
const WINDOW_WIDTH = int(720) # pixels
const WINDOW_HEIGHT = int(480) #pixels

#each teleport has an id based on its position, this makes shuffling easier
#ids are assigned to all horizontal teleports, then all vertical
#these are used for mapping
#   0   1   2
# 6   7   8   6
#   3   4   5
# 9  10  11  9
#   0   1   2

func teleid(pos):
	var h = (int(pos.x)%TELEPORT_SIZE)/TELEPORT_OFFSET*((pos.x-TELEPORT_OFFSET)/TELEPORT_SIZE + (int(pos.y)%WINDOW_HEIGHT)*TELEPORTS_PER_ROW/TELEPORT_SIZE) # horizontal ports
	var v = (int(pos.y)%TELEPORT_SIZE)/TELEPORT_OFFSET*((int(pos.x)%WINDOW_WIDTH)/TELEPORT_SIZE + (pos.y-TELEPORT_OFFSET)*TELEPORTS_PER_ROW/TELEPORT_SIZE + VERTICAL_ID_OFFSET) #vertical ports
	return v + h
	
func telepos(id):
	var x
	var y
	var baseid = int(id)%NEGATIVE_ID_OFFSET
	if(baseid<VERTICAL_ID_OFFSET):
		#horizontal
		x = (baseid*TELEPORT_SIZE+TELEPORT_OFFSET)%WINDOW_WIDTH
		y = ((baseid/TELEPORTS_PER_ROW)*TELEPORT_SIZE)
		if id<NEGATIVE_ID_OFFSET && y == 0:
			y = WINDOW_HEIGHT
	else:
		#vertical
		baseid -= VERTICAL_ID_OFFSET
		x = (baseid*TELEPORT_SIZE)%WINDOW_WIDTH
		y = ((baseid/TELEPORTS_PER_ROW)*TELEPORT_SIZE+TELEPORT_OFFSET)
		if id<NEGATIVE_ID_OFFSET && x == 0:
			x = WINDOW_WIDTH
	print("tpos ",x,",",y)
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
	#tmp sprite to make sure its where we expect
	#var sp = Sprite.new()
	#sp.texture = load("res://icon.png")
	#col.add_child(sp)
	tel.add_child(col)
	add_child(tel)

#get positional change for teleporting snowball
func telejump(inid, outid):
	var x = 0
	var y = 0
	return Vector2(x,y)

#get rotation vector for teleporting snowball velocity
func telerotate(inid, outid):
	var x = 0
	var y = 0
	return Vector2(x,y)
	
	
func shuffle():
	randomize()
	if nonlinearity == 1:
		#shuffle the horizontal and vertical teleports separately
		telemap = range(2*NEGATIVE_ID_OFFSET)
		for i in range(2*NEGATIVE_ID_OFFSET):
			telemap[i] = -1
		var i = 0
		var count = 0
		while i < NEGATIVE_ID_OFFSET:
			var offset = i
			if i >= VERTICAL_ID_OFFSET:
				offset -= VERTICAL_ID_OFFSET
			var v = i
			if count == VERTICAL_ID_OFFSET-2:
				#there are only 2 left, 
				for j in range(i,VERTICAL_ID_OFFSET):
					if telemap[j] != -1:
						v = j
				count = 0
			while v == i or telemap[v] != -1:
				v = randi()%(VERTICAL_ID_OFFSET-offset) + i # limit the range to disclude already assigned values
			#positive in maps to negative out
			telemap[i] = v+NEGATIVE_ID_OFFSET
			telemap[v+NEGATIVE_ID_OFFSET] = i
			#and the negative in goes out positive
			telemap[i+NEGATIVE_ID_OFFSET] = v
			telemap[v] = i+NEGATIVE_ID_OFFSET
			count += 2
			while telemap[i] != -1 and i < NEGATIVE_ID_OFFSET:
				i += 1
	#TODO: elif nonlinearity == 2:
	print(telemap)

# Called when the node enters the scene tree for the first time.
func _ready():
	# create the teleports
	for x in range(TELEPORTS_PER_ROW):
		for y in range (TELEPORTS_PER_COL):
			newtele(TELEPORT_SIZE*x, TELEPORT_SIZE*y+TELEPORT_OFFSET, 1, TELEPORT_OFFSET-4) #tall skinny teleports on sides of squares
			newtele(TELEPORT_SIZE*x+TELEPORT_OFFSET, TELEPORT_SIZE*y, TELEPORT_OFFSET-4, 1) #wide teleports on top/bottom of squares
		newtele(TELEPORT_SIZE*x+TELEPORT_OFFSET, WINDOW_HEIGHT, TELEPORT_OFFSET-4, 1)
	for y in range (TELEPORTS_PER_COL):
		newtele(WINDOW_WIDTH, TELEPORT_SIZE*y+TELEPORT_OFFSET, 1, TELEPORT_OFFSET-4)
	shuffle()
	
	#test that the id<->pos conversions are right
	for i in range(24):
		print(i,teleid(telepos(i)))
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

