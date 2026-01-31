extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

const MAX_ITEMS = 3
var selected_item: int = 1
var credits_shown: bool = false

func _process(_delta: float) -> void:
	if credits_shown:
		if Input.is_action_just_pressed("attack"):
			_on_return_btn_pressed();
		return
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
				credits_shown = true;
				animation_player.play('credits-in')
			3:
				get_tree().quit()


func _on_return_btn_pressed() -> void:
	if !credits_shown: return
	animation_player.play('credits-out')
	credits_shown = false
