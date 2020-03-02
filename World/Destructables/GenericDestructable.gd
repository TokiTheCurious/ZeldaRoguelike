extends StaticBody2D

export var Health = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

#func _process(delta):

func destroy():
	queue_free()

func take_damage():
	Health -= 1
	if(Health <= 0):
		destroy()


