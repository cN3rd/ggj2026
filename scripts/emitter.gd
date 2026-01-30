extends Node2D
class_name Emitter

@export var shot : PackedScene

var timer : float = 0

func do_emit() -> void:
	var shot_layer := get_tree().get_first_node_in_group('shot_layer') as Node2D
	var shotInstance : Node2D = shot.instantiate()
	shotInstance.position = shot_layer.to_local(self.global_position)
	shot_layer.add_child(shotInstance)
