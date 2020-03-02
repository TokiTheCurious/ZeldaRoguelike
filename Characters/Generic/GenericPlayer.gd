class_name GenericPlayer
extends KinematicBody2D

export (PackedScene) var Boomerang

export var speed = 400
export var attacks = []
export var is_halted = false

var viewport

func _ready():
	viewport = get_viewport()

func handle_attacks():
	if is_halted:
		return
	if Input.is_key_pressed(KEY_D):
		$AnimatedSprite.play(attacks[randi() % attacks.size()])
		is_halted = true				
		yield($AnimatedSprite, "animation_finished")
		is_halted = false
		$AnimatedSprite.play("idle")
	elif Input.is_key_pressed(KEY_S):
		if(!viewport.get_node("Boomerang")):
			print_debug('spawn boomerang')
			var boom = Boomerang.instance()
			boom.set_position(position)
			boom.set_return_reference($".")
			viewport.add_child(boom)
				

func handle_walking(delta):
	if(is_halted):
		return
	var velocity = Vector2()  # The player's movement vector.
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	if velocity.length() > 0:
		position += velocity.normalized() * speed * delta
		$AnimatedSprite.play("walking")
		if(velocity.x != 0):
			$AnimatedSprite.flip_h = velocity.x < 0
	else:
		$AnimatedSprite.play("idle")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	handle_attacks()	
	handle_walking(delta)
