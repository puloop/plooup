class_name Enemy extends CharacterBody2D

var Move_Speed := 50
var Attack_Damage := 10
var live_Enemy := 100
var Is_Attack:= false
@onready var player: Player = $"../Player"
@onready var sprite_animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var health_component: healtcomponent = $Component/HealthComponent


func _physics_process(delta: float) -> void:
	if ! Is_Attack and player:
		sprite_animation.play("run")
		
		var move_direction = (player.position - position).normalized()
		if move_direction:
			velocity = move_direction * Move_Speed
			if move_direction.x !=0:
				sprite_animation.flip_h=move_direction.x <0
				$areaAtacque.scale.x = -1 if move_direction.x < 0 else 1
			move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if  body is Player:
		atacar()
		
func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		Is_Attack = false	
		sprite_animation.play("run")

func atacar():
	sprite_animation.play("attack")
	Is_Attack = true

#cuando termine la animacion de ataque
func _on_animated_sprite_2d_animation_finished() -> void:
	if sprite_animation.animation == "attack":
		if Is_Attack:
			atacar()
	
