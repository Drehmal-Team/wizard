extends Control

var MinecraftFolder = ""
var CheckTexture = load("res://textures/Checks/checked.png")
var ErrorTexture = load("res://textures/Checks/crossed.png")
var UncheckedTexture = load("res://textures/Checks/unchecked.png")

@onready var LogLabel = $VBoxContainer/MarginContMinecraftFolder/VBoxContainer/MarginContainer/VBoxContainer/MarginContainer/LogLabel
@onready var TextEditPath = $VBoxContainer/MarginContMinecraftFolder/VBoxContainer/MarginContainer/VBoxContainer/HBoxContainer2/TextEdit

@onready var TextureMods = $VBoxContainer/MarginContainerMisc/ScrollContainer/VBoxContainer/VBoxCont_MODS/HBoxContainer/TextureRect
@onready var EditMods = $VBoxContainer/MarginContainerMisc/ScrollContainer/VBoxContainer/VBoxCont_MODS/HBoxContainer2/TextEdit_MODS
@onready var TextureSaves = $VBoxContainer/MarginContainerMisc/ScrollContainer/VBoxContainer/VBoxCont_SAVES/HBoxContainer/TextureRect
@onready var EditSaves = $VBoxContainer/MarginContainerMisc/ScrollContainer/VBoxContainer/VBoxCont_SAVES/HBoxContainer2/TextEdit_SAVES
@onready var TextureRes = $VBoxContainer/MarginContainerMisc/ScrollContainer/VBoxContainer/VBoxCont_RES/HBoxContainer/TextureRect
@onready var EditRes = $VBoxContainer/MarginContainerMisc/ScrollContainer/VBoxContainer/VBoxCont_RES/HBoxContainer2/TextEdit_RES

var MinecraftDir

func _on_texture_button_find_pressed():
	$NativeFileDialog.show()

func _on_texture_button_mods_pressed():
	$NativeFileDialogMODS.show()


func _on_texture_button_saves_pressed():
	$NativeFileDialogSAVES.show()


func _on_texture_button_res_pressed():
	$NativeFileDialogRES.show()




func _on_native_file_dialog_dir_selected(dir):
	MinecraftFolder = dir
	print(dir)
	$VBoxContainer/MarginContMinecraftFolder/VBoxContainer/HBoxContainer/TextureRect.texture = CheckTexture
	TextEditPath.text = MinecraftFolder

func _on_native_file_dialog_mods_dir_selected(dir):
	TextureMods.texture = CheckTexture
	EditMods.text = dir
	Global.ModsFolderPath = dir

func _on_native_file_dialog_saves_dir_selected(dir):
	TextureSaves.texture = CheckTexture
	EditSaves.text = dir
	Global.SavesFolderPath = dir

func _on_native_file_dialog_res_dir_selected(dir):
	TextureRes.texture = CheckTexture
	EditRes.text = dir
	Global.ResFolderPath = dir


var tinyStrings = ""
var homePath = ""

func _on_texture_button_autofind_pressed():
	if OS.get_name() in ["Windows","Linux","macOS"] :
		match OS.get_name() :
			"Windows":
				tinyStrings = OS.get_data_dir().split("/")
				homePath = ""
				for i in tinyStrings:
					if i != "" :
						homePath += "/" + i
				print(DirAccess.open(MinecraftFolder).get_directories())
				MinecraftFolder = homePath + "/.minecraft"
				MinecraftFolder = ProjectSettings.globalize_path(MinecraftFolder)
			"macOS":
				tinyStrings = OS.get_data_dir().split("/")
				homePath = ""
				for i in tinyStrings:
					if i != "" :
						homePath += "/" + i
				MinecraftFolder = homePath + "/minecraft"
				MinecraftFolder = ProjectSettings.globalize_path(MinecraftFolder)
			"Linux":
				tinyStrings = OS.get_data_dir().split("/").slice(0,3)
				homePath = ""
				for i in tinyStrings:
					if i != "" :
						homePath += "/" + i
				MinecraftFolder = homePath + "/.minecraft"
				MinecraftFolder = ProjectSettings.globalize_path(MinecraftFolder)
		
		
		print(MinecraftFolder)
		MinecraftDir = DirAccess.open(MinecraftFolder)
		if DirAccess.get_open_error() != 0 :
			print(DirAccess.get_open_error())
			$VBoxContainer/MarginContMinecraftFolder/VBoxContainer/HBoxContainer/TextureRect.texture = ErrorTexture
			LogLabel.text = "There was an error with the autofind function! Please select your minecraft folder with the manual button."
			LogLabel.label_settings.font_color = Color(1,0,0,1)
		else :
			$VBoxContainer/MarginContMinecraftFolder/VBoxContainer/HBoxContainer/TextureRect.texture = CheckTexture
			TextEditPath.text = MinecraftFolder
			LogLabel.text = "Minecraft Folder found successfully !"
			LogLabel.label_settings.font_color = Color(0,1,0,1)
			
			if "mods" in MinecraftDir.get_directories() :
				EditMods.text = MinecraftFolder + "/mods"
				TextureMods.texture = CheckTexture
				LogLabel.text += "\nMods folder found successfully !"
				Global.ModsFolderPath = MinecraftFolder + "/mods"
			else :
				MinecraftDir.make_dir("mods")
				EditMods.text = MinecraftFolder + "/mods"
				TextureMods.texture = CheckTexture
				LogLabel.text += "\nMods folder not found, creating one..."
			
			if "saves" in MinecraftDir.get_directories() :
				EditSaves.text = MinecraftFolder + "/saves"
				TextureSaves.texture = CheckTexture
				LogLabel.text += "\nSaves folder found successfully !"
				Global.SavesFolderPath = MinecraftFolder + "/saves"
			else :
				MinecraftDir.make_dir("saves")
				EditSaves.text = MinecraftFolder + "/saves"
				TextureSaves.texture = CheckTexture
				LogLabel.text += "\nSaves folder not found, creating one..."
			
			if "resourcepacks" in MinecraftDir.get_directories() :
				EditRes.text = MinecraftFolder + "/resourcepacks"
				TextureRes.texture = CheckTexture
				LogLabel.text += "\nResourcepack folder found successfully !"
				Global.ResFolderPath = MinecraftFolder + "/resourcepacks"
			else :
				MinecraftDir.make_dir("resourcepacks")
				EditMods.text = MinecraftFolder + "/resourcepacks"
				TextureMods.texture = CheckTexture
				LogLabel.text += "\nResourcepack folder not found, creating one..."
		
	else:
		$VBoxContainer/MarginContMinecraftFolder/VBoxContainer/HBoxContainer/TextureRect.texture = ErrorTexture
		LogLabel.text = "Your operating system was not recognized properly ! Please select your minecraft folder with the manual button."
		LogLabel.label_settings.font_color = Color(1,0,0,1)







