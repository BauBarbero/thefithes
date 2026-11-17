extends Node2D
class_name deadzone



func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is player:
		get_tree().reload_current_scene()
