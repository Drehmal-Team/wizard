extends Control

@onready var ButtonLocal = $VBoxContainer/MarginContMinecraftFolder/VBoxContainer/VBoxContainer/HBoxContainer_LOCAL/TextureButton
@onready var ButtonGlobal = $VBoxContainer/MarginContMinecraftFolder/VBoxContainer/VBoxContainer/HBoxContainer_GLOBAL/TextureButton
@onready var ButtonBoth = $VBoxContainer/MarginContMinecraftFolder/VBoxContainer/VBoxContainer/HBoxContainer_BOTH/TextureButton

func _ready():
	ButtonLocal.button_pressed = true
	ButtonGlobal.button_pressed = false
	ButtonBoth.button_pressed = false
