extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

const MAX_ITEMS = 3
var selected_item: int = 1
var credits_shown: bool = false

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("down"):
		if selected_item < MAX_ITEMS:
			selected_item += 1
			animation_player.play('select_%d' % selected_item)
	if Input.is_action_just_pressed("up"):
		if selected_item > 1:
			selected_item -= 1
			animation_player.play('select_%d' % selected_item)
	if Input.is_action_just_pressed("attack"):
		match selected_item:
			1:
				get_tree().change_scene_to_packed(preload("res://main.tscn"))
			2:
				# TODO: show credits here
				get_tree().change_scene_to_packed(preload("res://credits.tscn"))
			3:
				get_tree().quit()
