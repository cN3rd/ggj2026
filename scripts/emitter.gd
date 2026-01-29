extends Node2D
class_name Emitter

@export var shot : PackedScene
@export var shot_time: float = 1
@export var shot_layer : Node2D
@export var active : bool = true

var timer : float = 0

func _physics_process(delta: float) -> void:
	timer += delta
	if timer >= shot_time:
		var shotInstance : Node2D = shot.instantiate()
		shotInstance.position = shot_layer.to_local(self.global_position)
		shot_layer.add_child(shotInstance)
		timer -= shot_time
