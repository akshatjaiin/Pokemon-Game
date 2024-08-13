extends CharacterBody2D
@onready var animation_player = $AnimationPlayer
@onready var animated_sprite_2d = $AnimatedSprite2D

var walk_speed := 10.0
const TILE_SIZE := 16
var initial_position := Vector2(0, 0)
var input_direction := Vector2(0, 0)
var is_moving := false
var percent_moved_to_next_tile := 0.0
@onready var animated_sprite := $AnimatedSprite2D


func _ready():
	initial_position = position

func _physics_process(delta):
	if not is_moving:
		process_player_input()
	else:
		move(delta)

func process_player_input():
	input_direction = Vector2.ZERO
	
	# Horizontal movement
	if Input.is_action_pressed("ui_right"):
		input_direction.x = 1
	elif Input.is_action_pressed("ui_left"):
		input_direction.x = -1
	
	# Vertical movement (only if no horizontal movement)
	if input_direction == Vector2.ZERO:
		if Input.is_action_pressed("ui_down"):
			input_direction.y = 1
		elif Input.is_action_pressed("ui_up"):
			animated_sprite.play("run_up")
			input_direction.y = -1
	
	if input_direction != Vector2.ZERO:
		initial_position = position
		is_moving = true
		
	else:
		animated_sprite.play("idle")

func move(delta):
	percent_moved_to_next_tile += walk_speed * delta / TILE_SIZE
	if percent_moved_to_next_tile >= 1.0:
		position = initial_position + TILE_SIZE * input_direction
		percent_moved_to_next_tile = 0.0
		is_moving = false
		input_direction = Vector2.ZERO
		animated_sprite.play("idle")
	else:
		position = initial_position + TILE_SIZE * input_direction * percent_moved_to_next_tile
