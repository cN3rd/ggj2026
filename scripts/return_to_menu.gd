extends Node2D

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("attack"):
		get_tree().change_scene_to_file("res://menu.tscn")

func _on_lose_button_pressed() -> void:
	get_tree().change_scene_to_file("res://menu.tscn")
