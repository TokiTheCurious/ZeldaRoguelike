extends Area2D

export var speed = 7
export var rotation_speed = 10
export var bounce_back_time = 1

var returning = false
var return_reference
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func set_return_reference(return_ref):
	return_reference = return_ref

func _process(delta):
	rotation += rotation_speed * delta
	if(!returning):
		var velocity = Vector2(1,0)
		position += velocity.normalized() * speed
	else:
		if(return_reference):
			var velocity = Vector2()
			velocity.x = return_reference.position.x - position.x
			velocity.y = return_reference.position.y - position.y
			position += velocity.normalized() * speed
			


func _on_BounceBackTimer_timeout():
	#remove collision for walls
	#return boomerang
	returning = true
	pass



func _on_Boomerang_body_entered(body):
	if(returning and body.is_in_group("Player")):
		queue_free()
		
