extends Node2D

const shot := preload("res://scrolling_shot.tscn")
var rng := RandomNumberGenerator.new()
@export var shot_time: float = 1
@export var shot_layer : Node2D

var timer : float = 0

func _physics_process(delta: float) -> void:
	timer += delta
	if timer >= shot_time:
		var shotInstance : Node2D = shot.instantiate()
		shotInstance.position = self.position
		shot_layer.add_child(shotInstance)
		timer -= shot_time
