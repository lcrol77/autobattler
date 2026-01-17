class_name UnitGrid
extends Node

signal unit_grid_changed

@export var size: Vector2i

var units: Dictionary

func _ready() -> void:
	for i in size.x:
		for j in size.y:
			units[Vector2i(i,j)] = null

func add_unit(tile: Vector2i, unit: Node) -> void:
	units[tile] = unit
	unit.tree_exited.connect(_on_unit_tree_exited.bind(unit,tile))
	unit_grid_changed.emit()

func is_tile_occupied(tile: Vector2i) -> bool:
	return units[tile] != null

func is_grid_full() -> bool:
	return units.keys().all(is_tile_occupied)

func get_first_empty_tile() -> Vector2i:
	for tile in units:
		if not is_tile_occupied(tile):
			return tile
	# No empty tiles
	return Vector2i(-1,-1)

func get_all_units()-> Array[Unit]:
	var units_array: Array[Unit] = []
	for unit:  Unit in units.values():
		if unit:
			units_array.append(unit)
	return units_array

func remove_unit(tile: Vector2i) -> void:
	var unit := units[tile] as Node
	if not unit:
		return
	unit.tree_exited.connect(_on_unit_tree_exited)
	units[tile] = null
	unit_grid_changed.emit()

func _on_unit_tree_exited(unit: Node, tile: Vector2i) -> void:
	if unit.is_queued_for_deletion():
		units[tile] = null
		unit_grid_changed.emit()
