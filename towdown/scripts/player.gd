class_name Player extends CharacterBody2D

@onready var sprite_animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var health_component: healtcomponent = $Component/HealthComponent
@onready var attack_area: Area2D = $areaaAttackPlayer

# Estadísticas (Usa floats para cálculos más suaves)
var move_speed := 150.0 
var acceleration := 1200.0
var friction := 1000.0
var attack_damage := 10
var is_attacking := false

func _physics_process(delta: float) -> void:
	var move_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	# LÓGICA DE MOVIMIENTO (Inercia)
	if move_direction != Vector2.ZERO:
		velocity = velocity.move_toward(move_direction * move_speed, acceleration * delta)
		
		# Solo cambiamos a animación de Run si no estamos atacando
		if not is_attacking:
			sprite_animation.play("Run")
			
		# Flip del sprite y del área de ataque
		sprite_animation.flip_h = move_direction.x < 0
		attack_area.scale.x = -1 if move_direction.x < 0 else 1
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
		if not is_attacking:
			sprite_animation.play("Idle")

	move_and_slide()

func _input(event: InputEvent) -> void:
	# Primero verificamos si el evento es un botón del mouse
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			if not is_attacking:
				attack()
	
	# También puedes dejar el ui_accept por si quieres usar el teclado
	if event.is_action_pressed("ui_accept"):
		if not is_attacking:
			attack()

func attack():
	is_attacking = true
	sprite_animation.play("Attack")
	# Aquí podrías habilitar el collision del área de ataque momentáneamente

func _on_animated_sprite_2d_animation_finished() -> void:
	if sprite_animation.animation == "Attack":
		is_attacking = false # LIBERAMOS el estado para volver a caminar/atacar
		
		# Verificamos si hay enemigos en el área al terminar el golpe
		var targets = attack_area.get_overlapping_bodies()
		for body in targets:
			if body.has_method("take_damage"): # Asegúrate que el enemigo tenga esta función
				body.take_damage(attack_damage)
