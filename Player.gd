extends AnimatedSprite

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var speed = 100
var vel = Vector2()


# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_key_pressed(KEY_RIGHT):
		vel = Vector2(speed, 0)
		flip_h = false
	elif Input.is_key_pressed(KEY_LEFT):
		vel = Vector2(-speed, 0)
		flip_h = true
	elif Input.is_key_pressed(KEY_UP):
		vel = Vector2(0, -speed)
	elif Input.is_key_pressed(KEY_DOWN):
		vel = Vector2(0, speed)
	else:
		animation = "stand"
		return
	animation = "run"
	position = position + vel * delta
