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
@onready var FileDial = $FileDialog

var FileDialMAIN : FileDialog
var FileDialMODS : FileDialog
var FileDialSAVES : FileDialog
var FileDialRES : FileDialog

var MinecraftDir

func _ready():
	FileDialMAIN = FileDial.duplicate()
	FileDialMAIN.current_dir = OS.get_data_dir()
	FileDialMAIN.connect("dir_selected",_on_native_file_dialog_dir_selected)
	FileDialMAIN.hide()
	FileDialMAIN.position = Vector2(10.0,50.0)
	$".".add_child(FileDialMAIN)
	
	FileDialMODS = FileDial.duplicate()
	FileDialMODS.current_dir = OS.get_data_dir()
	FileDialMODS.title = "Select your mods directory..."
	FileDialMODS.connect("dir_selected",_on_native_file_dialog_mods_dir_selected)
	FileDialMODS.hide()
	FileDialMODS.position = Vector2(10.0,50.0)
	$".".add_child(FileDialMODS)
	
	FileDialSAVES = FileDial.duplicate()
	FileDialSAVES.title = "Select your saves directory..."
	FileDialSAVES.current_dir = OS.get_data_dir()
	FileDialSAVES.connect("dir_selected",_on_native_file_dialog_saves_dir_selected)
	FileDialSAVES.hide()
	FileDialSAVES.position = Vector2(10.0,50.0)
	$".".add_child(FileDialSAVES)
	
	FileDialRES = FileDial.duplicate()
	FileDialRES.title = "Select your resourcepack directory..."
	FileDialRES.current_dir = OS.get_data_dir()
	FileDialRES.connect("dir_selected",_on_native_file_dialog_res_dir_selected)
	FileDialRES.hide()
	FileDialRES.position = Vector2(10.0,50.0)
	$".".add_child(FileDialRES)

func _on_texture_button_find_pressed():
	FileDialMAIN.show()

func _on_texture_button_mods_pressed():
	FileDialMODS.show()


func _on_texture_button_saves_pressed():
	FileDialSAVES.show()


func _on_texture_button_res_pressed():
	FileDialRES.show()




func _on_native_file_dialog_dir_selected(dir):
	MinecraftFolder = dir
	print("[" + Time.get_time_string_from_system() + "]", dir)
	$VBoxContainer/MarginContMinecraftFolder/VBoxContainer/HBoxContainer/TextureRect.texture = CheckTexture
	TextEditPath.text = MinecraftFolder
	FileDialMODS.current_dir = MinecraftFolder
	FileDialSAVES.current_dir = MinecraftFolder
	FileDialRES.current_dir = MinecraftFolder

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
						homePath += i + "/"
				MinecraftFolder = homePath + ".minecraft"
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
		
		
		print("[" + Time.get_time_string_from_system() + "]", MinecraftFolder)
		MinecraftDir = DirAccess.open(MinecraftFolder)
		if DirAccess.get_open_error() != 0 :
			print("[" + Time.get_time_string_from_system() + "]", DirAccess.get_open_error())
			$VBoxContainer/MarginContMinecraftFolder/VBoxContainer/HBoxContainer/TextureRect.texture = ErrorTexture
			LogLabel.text = "There was an error with the autofind function! Please select your minecraft folder with the manual button."
			LogLabel.label_settings.font_color = Color(1,0,0,1)
		else :
			$VBoxContainer/MarginContMinecraftFolder/VBoxContainer/HBoxContainer/TextureRect.texture = CheckTexture
			TextEditPath.text = MinecraftFolder
			LogLabel.text = "Minecraft Folder found successfully !"
			LogLabel.label_settings.font_color = Color(0,1,0,1)
			Global.MinecraftFolderPath = MinecraftFolder
			
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







