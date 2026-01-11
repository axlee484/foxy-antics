extends Node2D
class_name Boss

@onready var triggerArea = $TriggerArea
@onready var animationTree: AnimationTree = $AnimationTree
@onready var visual = $Visual
@onready var invincibleTimer = $InvincibleTimer



@export var MAX_HEALTH = 100
@export var DAMAGE = 30

var health = MAX_HEALTH

var isInvincible = false

const animTreeConditions = { 
    ON_HIT = "parameters/conditions/on_hit",
    ON_TRIGGER = "parameters/conditions/on_trigger"
}


func _on_trigger_area_area_entered(_area: Area2D) -> void:
    if animationTree[animTreeConditions.ON_TRIGGER]:
        return
    animationTree[animTreeConditions.ON_TRIGGER] = true



func resetOnHit():
    animationTree[animTreeConditions.ON_HIT] = false

func animateToBegin():
    var tween = create_tween()
    tween.tween_property(visual, "position", Vector2.ZERO, 0.5)

func takeDamage(bullet: BulletBase):
    health -= bullet.damage
    print(health)
    animateToBegin()
    animationTree[animTreeConditions.ON_HIT] = true

func _on_hit_box_area_entered(area: Area2D) -> void:
    var areaParent = area.get_parent()
    if !areaParent is BulletBase:
        return
    if isInvincible:
        return
    isInvincible = true
    invincibleTimer.start()
    takeDamage(areaParent)



func _on_invincible_timer_timeout() -> void:
    isInvincible = false
