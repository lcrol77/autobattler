class_name Arena
extends Node2D

const CELL_SIZE := Vector2(32,32)
const HALF_CELL_SIZE := Vector2(16,16)
const QUARTER_CELL_SIZE := Vector2(8,8)

@onready var unit_mover: UnitMover = $UnitMover
@onready var unit_spawner: UnitSpawner = $UnitSpawner
@onready var sell_portal: SellPortal = $SellPortal
@onready var shop: Shop = %Shop

func _ready() -> void:
	unit_spawner.unit_spawned.connect(unit_mover.setup_unit)
	unit_spawner.unit_spawned.connect(sell_portal.setup_unit)
	shop.unit_bought.connect(unit_spawner.spawn_unit)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		var units := get_tree().get_nodes_in_group("units")
		units[1].animations.play_combine_animation(units[0].global_position + QUARTER_CELL_SIZE)
		units[2].animations.play_combine_animation(units[0].global_position + QUARTER_CELL_SIZE)
