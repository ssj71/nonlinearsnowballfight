extends Node2D
#main

var nplayers = 1
var nonlinearity = 1
var score = []
var ailevel = 1
var current_scn
var colors = []

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	var r = randi()%2
	var g = randi()%2
	var b = randi()%2
	var c
	for i in range(4):
		score.append(0)
		c  = Color(r,g,b)
		while colors.has(c):
			r = randi()%2
			g = randi()%2
			b = randi()%2
			c  = Color(r,g,b)
		colors.append(c)
	
	current_scn = load("res://menu.tscn").instance()
	add_child(current_scn)
	current_scn.set_colors(colors)
	
	
func _Play_pressed():
	remove_child(current_scn)
	current_scn = load("res://fight.tscn").instance()
	add_child(current_scn)
	var p = load("res://Player.tscn").instance()
	p.name = "Player0"
	p.index = 0
	var pc = current_scn.get_node("Players") #player collection
	pc.add_child(p)
	p.set_color(colors[0])
	#$current_scn/Players.add_child(p)
	
	p = load("res://Ralf.tscn").instance()
	p.name = "Player1"
	pc.add_child(p)
	p.index = 1
	p.get_node("Player").index = p.index
	p.set_color(colors[1])

	p = load("res://Randy.tscn").instance()
	p.name = "Player2"
	pc.add_child(p)
	p.index = 2
	p.get_node("Player").index = p.index
	p.set_color(colors[2])
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func winner(i):
	score[i] += 1
	remove_child(current_scn)
	
	current_scn = load("res://menu.tscn").instance()
	add_child(current_scn)
	current_scn.set_colors(colors)
	current_scn.set_scores(score)
	