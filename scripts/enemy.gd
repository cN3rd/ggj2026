extends Node2D

@export var health : int = 10
@onready var area_2d: Area2D = $Area2D
@export var explosion: PackedScene = null
@export var shot: PackedScene
@export var homing: bool = false
@export var aim_at: Node2D


var killed : bool = false
var active : bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area_2d.area_entered.connect(_on_area_entered)


func shoot() -> void:
	if killed:
		return
	var shot_layer := get_tree().get_first_node_in_group('shot_layer') as Node2D
	var shotInstance : Node2D = shot.instantiate()
	shotInstance.position = shot_layer.to_local(self.global_position)
	if homing:
		var player := get_tree().get_first_node_in_group('player') as Node2D
		shotInstance.rotation = global_position.angle_to_point(player.global_position) - PI*0.5
	elif aim_at != null:
		shotInstance.rotation = global_position.angle_to_point(aim_at.global_position) - PI*0.5
	shot_layer.add_child(shotInstance)

func activate() -> void:
	active = true
	visible = true
	process_mode = Node.PROCESS_MODE_INHERIT

func _on_area_entered(area: Area2D) -> void:
	if killed || !active:
		return
	var shotImpact: Shot = area.get_parent() as Shot
	if shotImpact == null:
		return
	if shotImpact.already_hit:
		return
	shotImpact.already_hit = true
	shotImpact.impact.emit()
	var damage := shotImpact.damage
	if health > damage:
		health -= damage
	else:
		if explosion != null:
			var explosion_layer := get_tree().get_first_node_in_group('explosion_layer') as Node2D
			var explosionInstance : Node2D = explosion.instantiate()
			explosionInstance.position = explosion_layer.to_local(self.global_position)
			explosion_layer.add_child(explosionInstance)
		health = 0
		killed = true
		queue_free()
