extends CharacterBody2D
@onready var animation = $AnimationPlayer
var is_hurt = false

func _process(delta: float) -> void:
	if not is_hurt:
		animation.play("idle")

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area is HitComponent and not is_hurt:
		is_hurt = true 
		animation.play("hurt") 
		
		await animation.animation_finished
		
		is_hurt = false    
