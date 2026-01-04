extends Node2D


@onready var camera = $Camera2D
@onready var player = $Player



func _physics_process(_delta: float) -> void:
    camera.position = player.position

