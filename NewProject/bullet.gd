extends Area2D

@export var speed: float = 800.0
@export var damage: int = 25
@export var lifetime: float = 2.0

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	
	await get_tree().create_timer(lifetime).timeout
	queue_free()

func _physics_process(delta: float) -> void:
	position += transform.x * speed * delta

func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D and body.is_in_group("player"):
		return

	if body.has_method("take_damage"):
		body.take_damage(damage)
	
	queue_free()
