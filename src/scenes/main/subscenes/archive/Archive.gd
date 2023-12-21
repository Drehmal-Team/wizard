extends Control

@onready var FileButton := $VBoxContainer/MarginContMinecraftFolder/VBoxContainer/VBoxFindThePath/VBoxCont_MODS/HBoxContainer/TextureButtonMODS

func _ready():
	FileButton.connect("button_down",_on_file_button_pressed)
	$VBoxContainer/MarginContMinecraftFolder/VBoxContainer/VBoxFindThePath/VBoxCont_MODS/FileDialog.hide()

func _on_file_button_pressed():
	$VBoxContainer/MarginContMinecraftFolder/VBoxContainer/VBoxFindThePath/VBoxCont_MODS/FileDialog.show()

func _on_file_dialog_return(path):
	Global.ArchivePath = path
	$VBoxContainer/MarginContMinecraftFolder/VBoxContainer/VBoxFindThePath/VBoxCont_MODS/HBoxContainer2/TextEdit_MODS.text = path
