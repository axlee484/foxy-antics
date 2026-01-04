extends CharacterBody2D


@export var GRAVITY = 300;

func applyGravity(delta: float) -> void:
    if is_on_floor():
        return;
    velocity.y += GRAVITY*delta;

func _physics_process(delta: float) -> void:
    applyGravity(delta);
    move_and_slide();

