extends Area3D

signal diamond_collected

const REMAIN_PARTICLE = preload("res://gameObjects/DiamondRemain.tscn")
const GAME_MANAGER_SCRIPT: Script = preload("res://script/game_manager.gd")

var _collected: bool = false

@onready var mesh: MeshInstance3D = $Mesh
var game_manager: Node

func _ready() -> void:
    area_entered.connect(_on_area_entered)
    _find_game_manager()
    if game_manager != null:
        # Set diamond color from game manager
        var mat = mesh.get_active_material(0)
        if mat is StandardMaterial3D:
            mat.albedo_color = game_manager.diamond_color

func _find_game_manager() -> void:
    for node in get_tree().get_nodes_in_group("game_manager"):
        if node.get_script() == GAME_MANAGER_SCRIPT:
            game_manager = node
            break
    if game_manager == null:
        push_error("Cannot find the game_manager object bound to res://script/game_manager.gd")

func _process(delta: float) -> void:
    # Slowly rotate the diamond for visual effect
    mesh.rotate_y(delta)

func _on_area_entered(area: Area3D) -> void:
    if _collected:
        return
    if area.get_parent() == game_manager.line:
        _collected = true
        mesh.visible = false
        # Emit collection signal
        emit_signal("diamond_collected")
        # Spawn remain particle
        for i in 10:
            var particle = REMAIN_PARTICLE.instance()
            particle.global_transform.origin = global_transform.origin
            particle.linear_velocity = Vector3(rand_dir(), rand_dir(), rand_dir()) * 2.0
            get_parent().add_child(particle)

func rand_dir() -> float:
    return randf_range(-1, 1)