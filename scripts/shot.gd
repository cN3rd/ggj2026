extends Node2D
class_name Shot

@onready var area_2d: Area2D = $Area2D

signal hit_player
@export var damage : int = 1
var already_hit : bool = false

func _ready() -> void:
	hit_player.connect(_on_hit_player)

func _on_hit_player() -> void:
	area_2d.queue_free()
