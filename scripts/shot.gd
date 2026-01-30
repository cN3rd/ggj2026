extends Node2D
class_name Shot

@onready var area_2d: Area2D = $Area2D
@export var explosion: PackedScene = null
@export var shot: PackedScene
@export var homing: bool = false
@export_enum('convert', 'emit', 'consume') var shot_mode: String = 'convert'
@export var shoot_after_impact: bool = false
@export var aim_at: Node2D


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

func shoot() -> void:
	if already_hit && !shoot_after_impact:
		return
	if shot_mode != 'emit':
		already_hit = true
		area_2d.queue_free()
	var shot_layer := get_tree().get_first_node_in_group('shot_layer') as Node2D
	var shotInstance : Node2D = shot.instantiate()
	shotInstance.position = shot_layer.to_local(self.global_position)
	if homing:
		var player := get_tree().get_first_node_in_group('player') as Node2D
		shotInstance.rotation = global_position.angle_to_point(player.global_position) - PI*0.5
	elif aim_at != null:
		shotInstance.rotation = global_position.angle_to_point(aim_at.global_position) - PI*0.5
	print(shot_layer)
	shot_layer.add_child(shotInstance)
	if shot_mode == 'consume':
		queue_free()
