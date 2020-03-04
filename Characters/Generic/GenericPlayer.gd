class_name GenericPlayer
extends KinematicBody2D

export (PackedScene) var Boomerang
export (PackedScene) var Bomb

export var speed = 400
export var attacks = []
export var is_halted = false


var viewport
var player_direction: Vector2 = Vector2(1,0)

func _ready():
	viewport = get_viewport()

func handle_attacks():
	if is_halted:
		return
	if Input.is_key_pressed(KEY_D):
		$AnimatedSprite.play(attacks[randi() % attacks.size()])
		var attack_col = $Attack/AttackColliderLeft if $AnimatedSprite.is_flipped_h() else $Attack/AttackColliderRight 
		attack_col.disabled = false
		
		is_halted = true				
		yield($AnimatedSprite, "animation_finished")
		is_halted = false
		attack_col.disabled = true
		$AnimatedSprite.play("idle")
	elif Input.is_key_pressed(KEY_S):
		if(get_parent().has_node("Boomerang")):
			var boom = Boomerang.instance()
			boom.id_ref = self
			get_parent().add_child(boom)
	elif Input.is_key_pressed(KEY_X):
		if(get_parent().has_node("Bomb")):
			var bomb = Bomb.instance()
			get_parent().add_child(bomb)


#func handle_walking(delta):
#	#if(is_halted):
#	#	return
#
#	var velocity = Vector2()  # The player's movement vector.
#	if Input.is_action_pressed("ui_right"):
#		velocity.x += 1
#	if Input.is_action_pressed("ui_left"):
#		velocity.x -= 1
#	if Input.is_action_pressed("ui_down"):
#		velocity.y += 1
#	if Input.is_action_pressed("ui_up"):
#		velocity.y -= 1
#	if velocity.length() > 0:
#		move_and_collide(velocity.normalized() * speed * delta)
#		player_direction = velocity.normalized()
#		$AnimatedSprite.play("walking")
#		if(velocity.x != 0):
#			$AnimatedSprite.flip_h = velocity.x < 0
#	else:
#		$AnimatedSprite.play("idle")

#override to play animation
func handle_attack():
	print_debug("attack from parent")

func handle_walking():
	pass
	
func handle_input(delta):
	if Input.is_action_just_pressed("attack"):
		handle_attack()
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
		move_and_collide(velocity.normalized() * speed * delta)
		player_direction = velocity.normalized()
		handle_walking()
		#$AnimatedSprite.play("walking")
		if(velocity.x != 0):
			$AnimatedSprite.flip_h = velocity.x < 0
	else:
		$AnimatedSprite.play("idle")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	handle_input(delta)
	#handle_attacks()	
	#handle_walking(delta)


func _on_Attack_area_entered(area):
	print_debug(area.name)
	if(area.is_in_group("Attackable")):
		area.take_damage()


func _on_Attack_body_entered(body):
	print_debug(body.name)
	if(body.is_in_group("Attackable")):
		body.take_damage()
