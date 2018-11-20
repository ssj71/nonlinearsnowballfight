extends Node2D
#main

var nplayers = 1
var nonlinearity = 1
var score = []
var ailevel = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(4):
		score.append(0)
	
	var menu = load("res://menu.tscn").instance()
	add_child(menu)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
