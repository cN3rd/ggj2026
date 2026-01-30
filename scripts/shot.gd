extends Node2D
class_name Shot

@onready var area_2d: Area2D = $Area2D
@export var explosion: PackedScene = null

signal impact
@export var damage : int = 1
var already_hit : bool = false

func _ready() -> void:
	impact.connect(_on_impact)

func _on_impact() -> void:
	if explosion != null:
		var explosion_layer := get_tree().get_first_node_in_group('explosion_layer') as Node2D
		var explosionInstance : Node2D = explosion.instantiate()
		explosionInstance.position = explosion_layer.to_local(self.global_position)
		explosion_layer.add_child(explosionInstance)
	area_2d.queue_free()
