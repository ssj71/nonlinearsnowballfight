extends Node2D

var scores
var players = []

# Called when the node enters the scene tree for the first time.
func _ready():
	scores = []
	scores.append($CenterContainer/VBoxContainer2/VBoxContainer/CenterContainer2/Scores/Score1)
	scores.append($CenterContainer/VBoxContainer2/VBoxContainer/CenterContainer2/Scores/Score2)
	scores.append($CenterContainer/VBoxContainer2/VBoxContainer/CenterContainer2/Scores/Score3)
	scores.append($CenterContainer/VBoxContainer2/VBoxContainer/CenterContainer2/Scores/Score4)
	$CenterContainer/VBoxContainer2/VBoxContainer/Play.connect("pressed",get_node(".."),"_Play_pressed")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func set_scores(scorearray):
	for i in range(4):
		scores[i].text = "Player\n"+String(scorearray[i])
		
func set_colors(colorarray):
	for i in range(4):
		scores[i].modulate = colorarray[i]

func _input(event):
	if event is InputEventKey:
		if event.pressed:
			if (event.scancode == KEY_SPACE and not players.has(KEY_SPACE)) or event.scancode == KEY_SHIFT and not players.has(KEY_SHIFT):
				add_player(event.scancode)

func add_player(key):
	var p = load("res://Player.tscn").instance()
	add_child(p)
	p.set_color(scores[players.size()].modulate)
	p.position = Vector2(210 + 100*players.size(),300)
	players.append(key)

func _on_Quit_pressed():
	get_tree().quit()
	pass # Replace with function body.
