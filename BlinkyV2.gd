extends KinematicBody2D

export var player_tools: Array = []

export (PackedScene) var Boomerang
export (PackedScene) var Bomb

export var speed = 400
export var attacks = []
export var is_halted = false
export var selected_tool_index: int = 0

var viewport = get_viewport()
var player_direction: Vector2 = Vector2(1,0)
var state_machine

var bomb_instance
var boomerang_instance

# Called when the node enters the scene tree for the first time.
func _ready():
	state_machine = $AnimationTree.get("parameters/playback")
	player_tools = [Bomb, Boomerang]
	viewport = get_viewport()

func use_tool():
	var parent = get_parent()
	var has_boomerang = parent.has_node("Boomerang")
	match player_tools[selected_tool_index]:
		Bomb:
			#if(!bomb_instance):
			bomb_instance = Bomb.instance()
			bomb_instance.id_ref = self
			get_parent().add_child(bomb_instance)		
		Boomerang:
			if(!boomerang_instance):
				var boomerang_instance = Boomerang.instance()
				boomerang_instance.id_ref = self
				get_parent().add_child(boomerang_instance)
		_:
			print_debug("Unknown tool")

func handle_action_input(delta):
	#Actions that cannot be executed while player is halted
	if !is_halted:	
		if Input.is_action_pressed("attack"):
			state_machine.travel("attack1")
			return
		if Input.is_action_just_pressed("main_tool"):
			print_debug("use_tool")
			use_tool()
		var velocity = Vector2()  # The player's movement vector.
		if Input.is_action_pressed("ui_right"):
			velocity.x += 1
			$Sprite.scale.x *= 1 if $Sprite.scale.x > 0 else -1
		if Input.is_action_pressed("ui_left"):
			velocity.x -= 1
			$Sprite.scale.x *= -1 if $Sprite.scale.x > 0 else 1
		if Input.is_action_pressed("ui_down"):
			velocity.y += 1
		if Input.is_action_pressed("ui_up"):
			velocity.y -= 1
		handle_walking(velocity, delta)
	#Actions that can be executed no matter what
	if Input.is_action_just_pressed("switch_tool"):
		switch_tool()

func switch_tool():
	selected_tool_index = (selected_tool_index + 1) % player_tools.size()
	print(selected_tool_index)

func handle_walking(velocity, delta):
	if(velocity.length() > 0):
		move_and_collide(velocity.normalized() * speed * delta)
		player_direction = velocity.normalized()
		state_machine.travel("walking")
	else:
		state_machine.travel("idle")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	handle_action_input(delta)

func _on_Attack_area_entered(area):
	print_debug(area.name)
	if(area.is_in_group("Attackable")):
		area.take_damage()

func _on_Attack_body_entered(body):
	print_debug(body.name)
	if(body.is_in_group("Attackable")):
		body.take_damage()
