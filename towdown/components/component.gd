class_name healtcomponent extends Node

@export var	Progress_bar : ProgressBar
@export var current_healt := 100 
@export var max_healt:= 100

func _ready() -> void:
	update_healt_bar()
	
	
func update_healt_bar():
	if Progress_bar:
		Progress_bar.value = current_healt
		
func recive_damage(amount: int):
	current_healt = clamp(current_healt - amount, 0 , max_healt)
	update_healt_bar()
	if current_healt <=0:
		ondead()
		
	
func apply_health(amount: int):
	current_healt = clamp(current_healt + amount, 0 , max_healt)
	update_healt_bar()
	
func ondead():
	print("personaje murio")
			
		
