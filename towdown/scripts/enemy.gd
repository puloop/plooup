class_name Enemy extends CharacterBody2D

# Referencias a componentes y nodos
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var health_component = $Component/HealthComponent

# Ajustes de movimiento
@export var speed := 60.0
@export var acceleration := 400.0

var player: Player = null

func _ready() -> void:
	# Buscamos al jugador en la escena. 
	# Asumimos que el Player tiene el class_name Player configurado.
	player = get_tree().get_first_node_in_group("player")
	
	# Si no usas grupos, podrías buscarlo por nombre en la raíz, 
	# pero los grupos son más eficientes.
	if not player:
		# Intento alternativo si no está en grupo
		var nodes = get_tree().get_nodes_in_group("player")
		if nodes.size() > 0:
			player = nodes[0]

func _physics_process(delta: float) -> void:
	if player:
		# 1. Calcular la dirección hacia el jugador
		var direction = (player.global_position - global_position).normalized()
		
		# 2. Moverse hacia él con aceleración
		velocity = velocity.move_toward(direction * speed, acceleration * delta)
		
		# 3. Orientar el sprite según la dirección
		if direction.x != 0:
			sprite.flip_h = direction.x < 0
		
		# 4. Reproducir animación si tienes una de caminar
		if sprite.has_animation("Walk"):
			sprite.play("Walk")
		else:
			sprite.play("default") # O la que tengas por defecto
			
		move_and_slide()

# Función para que el Player le haga daño al enemigo
func take_damage(amount: int):
	if health_component:
		health_component.recive_damage(amount)
		# Podrías añadir un efecto de retroceso (knockback) aquí para que se sienta mejor
		velocity -= (player.global_position - global_position).normalized() * 150
