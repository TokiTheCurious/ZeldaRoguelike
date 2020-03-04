extends Area2D

var id_ref

func _ready():
	global_position = id_ref.global_position
	$AnimatedSprite.play("start")
	

func _process(delta):
	pass

func _on_AnimatedSprite_animation_finished():
	if($AnimatedSprite.animation == "explode"):
		queue_free()
		id_ref.bomb_instance = null

	$AnimatedSprite.play("explode")
	$ExplosionCollider.disabled = false
	

func _on_Explosion_body_entered(body):
	if(body.is_in_group("Attackable")):
		body.take_damage()
