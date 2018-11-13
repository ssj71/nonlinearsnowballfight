extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func newtele(x,y,w,h):
	var tel = Area2D.new()
	var col = CollisionShape2D.new()
	col.shape = RectangleShape2D.new()
	col.shape.extents.x = w
	col.shape.extents.y = h
	col.position.x = x
	col.position.y = y
	tel.add_child(col)
	add_child(tel)
	if(w == 1):
		tel.connect("area_entered",get_node("../Balls"),"teleport_x")
	else:
		tel.connect("area_entered",get_node("../Balls"),"teleport_y")
	

# Called when the node enters the scene tree for the first time.
func _ready():
	for x in range(4):
		for y in range (3):
			print(x,y)
			newtele(80*x,80*(y+1),1,78)
			newtele(80*(x+1),80*y,78,1)
		newtele(80*(x+1),480,78,1)
	newtele(640,400,1,78)
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
