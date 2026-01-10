extends Node



enum BULLET_TYPE {
    PLAYER,
    ENEMY
}

const bullets = {
    playerBullet = preload("res://bullet/playerBullet/player_bullet.tscn"),
    enemyBullet = preload("res://bullet/enemyBullet/enemy_bullet.tscn")
}

const explosionScene = preload("res://characterExplode/character_explode.tscn")


func _ready() -> void:
    SignalManager.on_enemy_hit.connect(createExplosion)




func _addToRoot(node: Node2D):
    get_tree().root.add_child(node)

func _deferred_addToRoot(args):
    call_deferred("_addToRoot", args)

func addBullet(bullet):
    _deferred_addToRoot(bullet)


func createBullet(bulletType: BULLET_TYPE, _position: Vector2, speed: float, direction: Vector2):
    var bullet: BulletBase
    match bulletType:
        BULLET_TYPE.PLAYER:
            bullet = bullets.playerBullet.instantiate()
        BULLET_TYPE.ENEMY:
            bullet = bullets.enemyBullet.instantiate()

    bullet.setup(speed, direction, _position)
    addBullet(bullet)







func addExplosion(explosion):
    _deferred_addToRoot(explosion)


func createExplosion(_points: float, position: Vector2):
    var explosion:Node2D = explosionScene.instantiate()
    explosion.global_position = position
    addExplosion(explosion)

    

