extends Node2D
class_name Shot

@onready var area_2d: Area2D = $Area2D

signal impact
@export var damage : int = 1
var already_hit : bool = false

func _ready() -> void:
	impact.connect(_on_impact)

func _on_impact() -> void:
	area_2d.queue_free()
