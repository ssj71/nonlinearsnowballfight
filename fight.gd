extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var ctl = []
var players

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(4):
		ctl.append([])
	pass # Replace with function body.

func ctl_player(i,d,w):
	var p = $Players.get_node("Player"+String(i))
	if p != null:
		p.set_direction(d)
		p.windup = w
	

func check_arrows(i):
	var d = Vector2(0,0)
	var w = false
	if Input.is_key_pressed(KEY_RIGHT):
		d.x = 1
	if Input.is_key_pressed(KEY_LEFT):
		d.x = -1
	if Input.is_key_pressed(KEY_UP):
		d.y = -1
	if Input.is_key_pressed(KEY_DOWN):
		d.y = 1
	if Input.is_key_pressed(KEY_SPACE):
		w = true
	ctl_player(i,d,w)
			
func check_aswd(i):
	var d = Vector2(0,0)
	var w = false
	if Input.is_key_pressed(KEY_D):
		d.x = 1
	if Input.is_key_pressed(KEY_A):
		d.x = -1
	if Input.is_key_pressed(KEY_W):
		d.y = -1
	if Input.is_key_pressed(KEY_S):
		d.y = 1
	if Input.is_key_pressed(KEY_SHIFT):
		w = true
	ctl_player(i,d,w)
	

# polling for inputs is horrible, but I don't have a better way right now
func _process(delta):
	for i in range(players.size()):
		if players[i] == KEY_SPACE:
			check_arrows(i)
		elif players[i] == KEY_SHIFT:
			check_aswd(i)

func kill(index):
	for i in range($Players.get_child_count()):
		if $Players.get_child(i).index == index:
			$Players.get_child(i).free()
			break
	if $Players.get_child_count() == 1:
		get_node("..").winner($Players.get_child(0).index)
	

