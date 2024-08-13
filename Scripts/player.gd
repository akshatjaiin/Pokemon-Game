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
		animated_sprite.play("run_right")
	elif Input.is_action_pressed("ui_left"):
		input_direction.x = -1
		animated_sprite.play("run_left")
	
	# Vertical movement (only if no horizontal movement)
	if input_direction == Vector2.ZERO:
		if Input.is_action_pressed("ui_down"):
			input_direction.y = 1
			animated_sprite.play("run_down")
		elif Input.is_action_pressed("ui_up"):
			input_direction.y = -1
			animated_sprite.play("run_up")
	
	if input_direction != Vector2.ZERO:
		initial_position = position
		is_moving = true
	else:
		# Check for idle state based on the last movement direction
		if input_direction.x == 1:
			animated_sprite.play("idle_right")
		elif input_direction.x == -1:
			animated_sprite.play("idle_left")
		elif input_direction.y == 1:
			animated_sprite.play("idle_down")
		elif input_direction.y == -1:
			animated_sprite.play("idle_up")

func move(delta):
	percent_moved_to_next_tile += walk_speed * delta / TILE_SIZE
	if percent_moved_to_next_tile >= 1.0:
		position = initial_position + TILE_SIZE * input_direction
		percent_moved_to_next_tile = 0.0
		is_moving = false
		input_direction = Vector2.ZERO
		
		# Set to idle state after movement completes
		if input_direction.x == 1:
			animated_sprite.play("idle_right")
		elif input_direction.x == -1:
			animated_sprite.play("idle_left")
		elif input_direction.y == 1:
			animated_sprite.play("idle_down")
		elif input_direction.y == -1:
			animated_sprite.play("idle_up")
		else:
			animated_sprite.play("idle_up")
	else:
		position = initial_position + TILE_SIZE * input_direction * percent_moved_to_next_tile
