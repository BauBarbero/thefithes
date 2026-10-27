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

var state = stateMachine.IDLE

@onready var player = $".."
@onready var animation = $"../AnimationPlayer"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var direction := Input.get_axis("ui_left", "ui_right")
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
			if Input.is_action_just_pressed("ui_accept"):
				state = stateMachine.ATTACK
			if Input.is_action_just_pressed("ui_up") and player.is_on_floor():
				state = stateMachine.JUMP
			if not direction:
				stateMachine.IDLE
		stateMachine.JUMP:
			if player.is_on_floor() and player.velocity.y >= 0:
				player.velocity.y = JUMP_VELOCITY
				animation.play("jump")
			if Input.is_action_just_pressed("ui_accept"):
				state = stateMachine.ATTACK
			if player.velocity.y > 0:
				state = stateMachine.FALL
			if direction:
				state = stateMachine.RUN
		stateMachine.FALL:
			if direction:
				state = stateMachine.RUN
			if player.is_on_floor() and player.velocity.y >= 0:
				state = stateMachine.IDLE
		stateMachine.ATTACK:
			if direction:
				state = stateMachine.RUN
			else:
				player.velocity.x = move_toward(player.velocity.x, 0, SPEED)
			if Input.is_action_just_pressed("ui_up") and player.is_on_floor():
				state = stateMachine.JUMP
	player.move_and_slide()
