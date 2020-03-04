extends Area2D

export var speed = 8
export var rotation_speed = 15
export var bounce_back_time = 2.0

var returning = false
var throw_direction: Vector2 = Vector2(1,0)
var id_ref: Node2D

func _ready():
	global_position = id_ref.global_position if id_ref else Vector2.ZERO
	throw_direction = id_ref.player_direction if id_ref else Vector2(1,0)
	pass
	

func set_throw_direction(direction: Vector2):
	throw_direction = direction

func _process(delta):
	rotation += rotation_speed * delta
	if(!returning):
		position += throw_direction.normalized() * speed
	else:
		if(id_ref):
			if(global_position.distance_to(id_ref.global_position) < 5):
				queue_free()
				id_ref.boomerang_instance = null
			var velocity = Vector2()
			velocity.x = id_ref.global_position.x - global_position.x
			velocity.y = id_ref.global_position.y - global_position.y
			global_position += velocity.normalized() * speed
	
func _on_BounceBackTimer_timeout():
	returning = true
		
func _on_Boomerang_area_entered(area):
	print("boomerang area entered")
	returning = true


func _on_Boomerang_area_shape_entered(area_id, area, area_shape, self_shape):
	print("boomerang shape entered")
	
	returning = true


func _on_Boomerang_body_entered(body):
	returning = true
	print("boomerang body entered")
