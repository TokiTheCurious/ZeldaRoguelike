extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.play("start")

func _process(delta):
	pass

func _on_AnimatedSprite_animation_finished():
	if($AnimatedSprite.animation == "explode"):
		queue_free()

	$AnimatedSprite.play("explode")
	$ExplosionCollider.disabled = false
	

func _on_Explosion_body_entered(body):
	if(body.is_in_group("Attackable")):
		body.take_damage()
