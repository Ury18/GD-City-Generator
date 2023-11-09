# @tool
class_name CityGenerator
extends Node3D

@export var center : MeshInstance3D
@export var cell_size: int
@export var rows: int
@export var columns: int
@export var cellScene: PackedScene
@export var roadScene: PackedScene
@export var buildings: Array[PackedScene]
@onready var timer: Timer = $Timer
@export var minRoadsHorizontal = 2
@export var maxRoadsHorizontal = 2
@export var minRoadsVertical = 2
@export var maxRoadsVertical = 2
@export var roads_margin = 3
@export	var roads_padding = 0

var grid : Array[Array] = []
var roadCells : Array[Node3D] = []

# Called when the node enters the scene tree for the first time.
func _ready():
	if !Engine.is_editor_hint():
		center.visible = false

	#Build grid
	for r in rows:
		grid.push_back([])
		for c in columns:
			var cell_position : Vector3 = center.position
			cell_position.x = cell_position.x - floor( (columns/2) * cell_size) + (c * cell_size)
			cell_position.z = cell_position.z - floor((rows/2) * cell_size) + (r * cell_size)
			var cell = cellScene.instantiate()
			add_child(cell)
			cell.scale = Vector3(cell_size,cell_size,cell_size)
			cell.position = cell_position
			grid[r].push_back(cell)


	#Build Roads
	var vertical_roads := []
	var vertical_number_of_roads = floor(randi_range(minRoadsVertical, maxRoadsVertical))

	while vertical_roads.size() < vertical_number_of_roads:
		var randomIndex = randi_range(0, columns - 1)
		var skip = false
		if vertical_roads.has(randomIndex):
			skip = true

		for margin in roads_margin:
			var neighbourCellNegative = randomIndex - margin
			var neighbourCellPositive = randomIndex + margin

			if vertical_roads.has(neighbourCellNegative) || vertical_roads.has(neighbourCellPositive):
				skip = true
		if !skip:
			vertical_roads.push_back(randomIndex)

	print(vertical_roads)

	for col in vertical_roads:
		for row in grid:
			var cell = row[col]
			# print(row)
			var building = roadScene.instantiate()
			building.get_node("Mesh").scale.x += roads_padding
			building.get_node("Mesh").scale.z += roads_padding
			cell.add_child(building)
			cell.get_node("Outline").visible = false
			roadCells.push_back(cell)
			# print(cell)

			# # WAIT
			# timer.start()
			# await timer.timeout
			# await get_tree().process_frame

	var horizontal_roads := []
	var horizontal_number_of_roads = floor(randi_range(minRoadsHorizontal, maxRoadsHorizontal))

	while horizontal_roads.size() < horizontal_number_of_roads:
		var randomIndex = randi_range(0, rows - 1)
		var skip = false
		if horizontal_roads.has(randomIndex):
			skip = true

		for margin in roads_margin:
			var neighbourCellNegative = randomIndex - margin
			var neighbourCellPositive = randomIndex + margin

			if horizontal_roads.has(neighbourCellNegative) || horizontal_roads.has(neighbourCellPositive):
				skip = true
		if !skip:
			horizontal_roads.push_back(randomIndex)

	print(horizontal_roads)

	for row in horizontal_roads:
		for col in grid[row]:
			var cell = col
			# print(row)
			var building = roadScene.instantiate()
			building.get_node("Mesh").scale.x += roads_padding
			building.get_node("Mesh").scale.z += roads_padding
			cell.add_child(building)
			cell.get_node("Outline").visible = false
			roadCells.push_back(cell)

			# print(cell)

			# # WAIT
			# timer.start()
			# await timer.timeout
			# await get_tree().process_frame

	#Build buildings
	for row in grid:
		for cell in row:
			var isBuilding = randi_range(0,10)

			if !(roadCells.has(cell)):
				if isBuilding <= 8:
					var index = randi_range(0, buildings.size() - 1)
					var buildingScene = buildings[index]
					var building = buildingScene.instantiate()
					building.position = Vector3(0,0,0)
					cell.add_child(building)
				else:
					cell.get_node("Outline").visible = true



func _process(delta):
	print(Engine.get_frames_per_second())
	pass
