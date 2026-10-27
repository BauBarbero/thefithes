extends Node
enum stateMachine {
	IDLE,
	RUN,
	JUMP,
	FALL,
	ATTACK,
	HIT,
}

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var con = true
var state = stateMachine.IDLE

@onready var hitbox_pivot = $"../Pivot" # El nodo Node2D que agrupa al HitComponent
@onready var player = $".."
@onready var animation = $"../AnimationPlayer"
@onready var sprite = $"../Sprite2D"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction != 0:
		hitbox_pivot.scale.x = direction
	if not player.is_on_floor():
		player.velocity += player.get_gravity() * delta
	match state:
		stateMachine.IDLE:
			animation.play("idle")
			player.velocity.x = move_toward(player.velocity.x, 0, SPEED)
			if direction:
				state = stateMachine.RUN
			if Input.is_action_just_pressed("ui_up"):
				state = stateMachine.JUMP
			if Input.is_action_just_pressed("ui_accept"):
				state = stateMachine.ATTACK
		stateMachine.RUN:
			animation.play("run")
			player.velocity.x = direction * SPEED
			if direction == -1:
				sprite.flip_h = true
			elif direction == 1:
				sprite.flip_h = false
			if Input.is_action_just_pressed("ui_accept"):
				state = stateMachine.ATTACK
			if Input.is_action_just_pressed("ui_up") and player.is_on_floor():
				
				state = stateMachine.JUMP
			if not direction:
				state = stateMachine.IDLE
		stateMachine.JUMP:
			animation.play("jump")
			if player.is_on_floor() and player.velocity.y >= 0:
				player.velocity.y = JUMP_VELOCITY
			if direction:
				player.velocity.x = direction * SPEED
				if direction == -1:
					sprite.flip_h = true 
				elif direction == 1:
					sprite.flip_h = false
			else:
				player.velocity.x = move_toward(player.velocity.x, 0, SPEED)
			
			if Input.is_action_just_pressed("ui_accept"):
				state = stateMachine.ATTACK
			if player.velocity.y > 0:
				state = stateMachine.FALL
		stateMachine.FALL:
			if direction:
				player.velocity.x = direction * SPEED
				if direction == -1:
					sprite.flip_h = true 
				elif direction == 1:
					sprite.flip_h = false
			else:
				player.velocity.x = move_toward(player.velocity.x, 0, SPEED)
			if player.is_on_floor() and player.velocity.y >= 0:
				state = stateMachine.IDLE
		stateMachine.ATTACK:
			player.velocity.x = move_toward(player.velocity.x, 0, SPEED)
			if con:
				animation.play("basic_attack")
				con = false
			if not animation.is_playing():
				con = true
				if direction:
					state = stateMachine.RUN
				else:
					state = stateMachine.IDLE
	player.move_and_slide()
