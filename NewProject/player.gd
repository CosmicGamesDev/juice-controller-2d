extends CharacterBody2D

@export var move_speed: float = 100.0
@export var bullet_scene: PackedScene
@export var fire_rate: float = 0.15

@onready var character_sprite: Sprite2D = $CharacterSprite
@onready var gun_pivot: Node2D = $GunPivot
@onready var gun: Sprite2D = $GunPivot/Gun
@onready var fire_fx: Sprite2D = $GunPivot/Gun/FireFx

var can_shoot: bool = true

func _physics_process(_delta: float) -> void:
	var input_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = input_vector * move_speed
	move_and_slide()
	var mouse_pos = get_global_mouse_position()
	gun_pivot.look_at(mouse_pos)

	var aiming_left = mouse_pos.x < global_position.x
	character_sprite.flip_h = aiming_left

	gun.flip_v = aiming_left

	if Input.is_action_pressed("shoot") and can_shoot:
		shoot()

func shoot() -> void:
	if not bullet_scene:
		return
		
	can_shoot = false
	var bullet = bullet_scene.instantiate()
	bullet.global_position = fire_fx.global_position
	bullet.rotation = gun_pivot.rotation
	get_parent().add_child(bullet)
	
	await get_tree().create_timer(fire_rate).timeout
	can_shoot = true
