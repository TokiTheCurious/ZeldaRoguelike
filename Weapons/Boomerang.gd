extends Area2D

export var speed = 8
export var rotation_speed = 15
export var bounce_back_time = 2.0

var returning = false
var throw_direction: Vector2 = Vector2(1,0)
var return_reference: Node2D

func _ready():
	pass
	
func set_return_reference(return_ref):
	return_reference = return_ref

func set_throw_direction(direction: Vector2):
	throw_direction = direction

func _process(delta):
	rotation += rotation_speed * delta
	if(!returning):
		position += throw_direction.normalized() * speed
	else:
		if(return_reference):
			if(position == return_reference.position):
				queue_free()
			var velocity = Vector2()
			velocity.x = return_reference.position.x - position.x
			velocity.y = return_reference.position.y - position.y
			position += velocity.normalized() * speed
	
func _on_BounceBackTimer_timeout():
	returning = true

func _on_Boomerang_body_entered(body):
	print(body)
	if(returning and body.is_in_group("Player")):
		queue_free()
		
func _on_Boomerang_area_entered(area):
	returning = true
