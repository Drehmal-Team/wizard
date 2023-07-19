extends Node

var RessourcePackMode = ""
var MinecraftFolderPath = ""
var ModsFolderPath = ""
var ResFolderPath = ""
var SavesFolderPath = ""
var NecessMods = true
var PerfMods = true
var OptiMods = false

var Music = AudioStreamPlayer.new()

signal BeginInstall
signal NextStep
signal PrevStep
signal SeeMods
signal OutMods

func _ready():
	add_child(Music)
	Music.finished.connect(_finished)
	Music.stream = load("res://assets/sounds/MainMenu.ogg")
	_finished()
	Input.set_custom_mouse_cursor(load("res://textures/Cursor/Cursor.png"))
	
func _finished():
	Music.play()
	

func _on_install_begin_button_pressed():
	$VBoxContainer/MarginContainer2/MenuManagers/PanelContainer/MarginContainer/VBoxContainer_Info/ScrollContainer/VBoxInstall/Button.process_mode = 4
	SceneTransition.dissolve("res://InstallMain.tscn")
