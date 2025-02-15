extends PanelContainer

@onready var clear_button: Button = $MarginContainer/HBoxContainer/CommandsMenu/ExecuteArea/VBoxContainer/HBoxContainer/ClearButton
@onready var map_container: Node = $MarginContainer/HBoxContainer/LevelMenu/MarginContainer/LevelArea
@onready var command_container: Node = $MarginContainer/HBoxContainer/CommandsMenu/CommandArea/VBoxContainer/ScrollContainer2/VBoxContainer/Movimentacao/MarginContainer/VBoxContainer

@export var maps: Dictionary = {
	"level_1": preload("res://levels/map_01.tscn"),
	"level_2": preload("res://levels/map_02.tscn"),
	"level_3": preload("res://levels/map_03.tscn"),
	"level_4": preload("res://levels/map_04.tscn")
}
@export var commands: Dictionary = {
	"level_1": [preload("res://commands/ComandoAndar.tscn")],
	"level_2": [preload("res://commands/ComandoAndar.tscn"), preload("res://commands/ComandoVirar.tscn")],
	"level_3": [preload("res://commands/ComandoAndar.tscn"), preload("res://commands/ComandoVirar.tscn"), preload("res://commands/ComandoPular.tscn")]
}

var current_map = null
var current_level = "level_1"

func _ready():
	if clear_button and not clear_button.pressed.is_connected(_on_clear_button_pressed):
		clear_button.pressed.connect(_on_clear_button_pressed)

	load_level(current_level) # Carrega o primeiro mapa e seus comandos

func _on_clear_button_pressed() -> void:
	get_tree().reload_current_scene()  # Agora recarregamos o nível sem resetar a cena inteira

func load_level(level_name: String):
	load_map(level_name)
	load_commands(level_name)

func load_map(level_name: String):
	if current_map:
		current_map.queue_free()  # Remove o mapa anterior
	
	if level_name in maps:
		current_map = maps[level_name].instantiate()
		current_map.scale = Vector2(1.6, 1.6)  # Ajusta a escala do mapa
		map_container.add_child(current_map)


func load_commands(level_name: String):
	# Remove todos os comandos anteriores
	for child in command_container.get_children():
		child.queue_free()
	
	# Adiciona os novos comandos conforme o nível
	if level_name in commands:
		for command_scene in commands[level_name]:
			var command_instance = command_scene.instantiate()
			command_container.add_child(command_instance)
