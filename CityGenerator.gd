@tool
class_name CityGenerator
extends Node3D

@export var center : MeshInstance3D
@export var cell_size: int
@export var rows: int
@export var columns: int
@export var cell_placeholder: PackedScene
@onready var timer: Timer = $Timer

var grid : Array

# Called when the node enters the scene tree for the first time.
func _ready():
	if !Engine.is_editor_hint():
		center.visible = false

	for r in rows:
		for c in columns:
			var cell_position : Vector3 = center.global_position
			cell_position.z = floor(cell_position.z) - floor( (columns/2) * cell_size) + (c * cell_size)
			cell_position.x = floor(cell_position.x) - floor((rows/2) * cell_size) + (r * cell_size)
			var cell = cell_placeholder.instantiate()
			add_child(cell)
			cell.scale.x = cell_size
			cell.scale.z = cell_size
			cell.global_position = cell_position
			timer.start()
			await timer.timeout
			await get_tree().process_frame
			grid.push_back(cell)
	print("")
	pass # Replace with function body.
