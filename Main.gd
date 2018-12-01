extends Node2D
#main

var players = []
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
	players = current_scn.players
	if players.size() == 0:
		return
		
	remove_child(current_scn)
	current_scn = load("res://fight.tscn").instance()
	add_child(current_scn)
	current_scn.players = players
	
	
	var pc = current_scn.get_node("Players") #player collection
	var p
	var pp
	for i in range(players.size()):
		p = load("res://Player.tscn").instance()
		p.name = "Player"+String(i)
		p.index = i
		p.position = Vector2(210 + 100*i,300)
		pc.add_child(p)
		p.set_color(colors[i])
	
	#extra randy NPC if solo
	if players.size() == 1:
		p = load("res://Randy.tscn").instance()
		p.name = "Player1"
		pc.add_child(p)
		p.index = 1
		pp = p.get_node("Player")
		pp.position = Vector2(310,300)
		pp.index = p.index
		p.set_color(colors[1])
	
	p = load("res://Ralf.tscn").instance()
	p.name = "Player2"
	pc.add_child(p)
	p.index = 2
	pp = p.get_node("Player")
	pp.position = Vector2(410,300)
	pp.index = p.index
	p.set_color(colors[2])

	p = load("res://Randy.tscn").instance()
	p.name = "Player3"
	pc.add_child(p)
	p.index = 3
	pp = p.get_node("Player")
	pp.position = Vector2(510,300)
	pp.index = p.index
	p.set_color(colors[3])
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
	for p in players:
		current_scn.add_player(p)
	