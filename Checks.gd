extends Control

var MinecraftFolder = ""
var CheckTexture = load("res://textures/Checks/checked.png")
var ErrorTexture = load("res://textures/Checks/crossed.png")
var UncheckedTexture = load("res://textures/Checks/unchecked.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_texture_button_find_pressed():
	$NativeFileDialog.show()


func _on_native_file_dialog_dir_selected(dir):
	MinecraftFolder = dir
	print(dir)
	$VBoxContainer/MarginContMinecraftFolder/VBoxContainer/HBoxContainer/TextureRect.texture = CheckTexture
	TextEditPath.text = MinecraftFolder

@onready var LogLabel = $VBoxContainer/MarginContMinecraftFolder/VBoxContainer/MarginContainer/VBoxContainer/MarginContainer/LogLabel
@onready var TextEditPath = $VBoxContainer/MarginContMinecraftFolder/VBoxContainer/MarginContainer/VBoxContainer/HBoxContainer2/TextEdit

func _on_texture_button_autofind_pressed():
	if OS.get_name() == "Windows" or OS.get_name() == "UWP" :
		MinecraftFolder = "%appdata%\\.minecraft"
		$VBoxContainer/MarginContMinecraftFolder/VBoxContainer/HBoxContainer/TextureRect.texture = CheckTexture
		TextEditPath.text = MinecraftFolder
		LogLabel.text = "Minecraft Folder found successfully !"
		LogLabel.label_settings.font_color = Color(0,1,0,1)
	elif OS.get_name() == "Linux":
		MinecraftFolder = "~/.minecraft"
		$VBoxContainer/MarginContMinecraftFolder/VBoxContainer/HBoxContainer/TextureRect.texture = CheckTexture
		TextEditPath.text = MinecraftFolder
		LogLabel.text = "Minecraft Folder found successfully !"
		LogLabel.label_settings.font_color = Color(0,1,0,1)
	elif OS.get_name() == "macOS":
		MinecraftFolder = "~/Library/Application Support/minecraft"
		$VBoxContainer/MarginContMinecraftFolder/VBoxContainer/HBoxContainer/TextureRect.texture = CheckTexture
		TextEditPath.text = MinecraftFolder
		LogLabel.text = "Minecraft Folder found successfully !"
		LogLabel.label_settings.font_color = Color(0,1,0,1)
	else:
		LogLabel.text = "Your operating system was not recognized properly ! Please select your minecraft folder with the manual button."
		LogLabel.label_settings.font_color = Color(1,0,0,1)
