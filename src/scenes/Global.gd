extends Node

var configRaw := "RessourcePackUrl=https://www.drehmal.net/_files/archives/a539b0_813ec06a45c34d31a634264df7f58649.zip?dn=Primordial%20Pack%202.2%20BETA.zip
MapPackageUrl=https://download1322.mediafire.com/bg7si122bxmgGvFSqrJ0XD2VdPME6IzknC55N-2ZjOinxnjfbt4vzpyv1-G0q4SznMSPpryjLMmp1ANe4Hpg8O_1IktFJTihqPprIwgjjcIs7rd6PFtoriGlfvAVrzzqrNoItKtN6USttxQ2pqxoV6MpV7Z2J4Gv3VjajF0mO6am/z2a85i5ccsntb5k/Drehmal+2.2+Apotheosis+Beta+-+1.0.1.tar.gz"
var config : Dictionary
var RessourcePackMode := "LOCAL"
var MinecraftFolderPath := ""
var ModsFolderPath := ""
var ResFolderPath := ""
var SavesFolderPath := ""
var NecessMods := true
var PerfMods := false
var OptiMods := false
var RamValue := 0
var FabricInstalled := false
var FabricVersion := ""
var InstallType : String
var TimeSpent := 0.0
var ArchivePath := ""


var Music = AudioStreamPlayer.new()

signal BeginInstall
signal NextStep
signal PrevStep
signal SeeMods
signal OutMods



func _ready():
	add_child(Music)
	Music.set_volume_db(-5.0)
	Music.finished.connect(_finished)
	Music.stream = load("res://assets/sounds/MainMenu.ogg")
	_finished()
	Input.set_custom_mouse_cursor(load("res://textures/Cursor/Cursor.png"))
	
	config = await var_to_dict(configRaw)
	print("["+Time.get_time_string_from_system()+"]",  "Config values are :")
	for key in config.keys():
		print(" --- ",key," : ",config[key])
	print()
	
func _finished():
	Music.play()

func play_sound(type):
	if type in ["FRWD","BACK"]:
		var path : String
		if type == "FRWD":
			var files = ["res://assets/sounds/Frwd/frwd_01.ogg", "res://assets/sounds/Frwd/frwd_02.ogg", "res://assets/sounds/Frwd/frwd_03.ogg", "res://assets/sounds/Frwd/frwd_04.ogg", "res://assets/sounds/Frwd/frwd_05.ogg", "res://assets/sounds/Frwd/frwd_06.ogg", "res://assets/sounds/Frwd/frwd_07.ogg"]
			path = files[randi() % files.size()]
		var SFX = AudioStreamPlayer.new()
		add_child(SFX)
		SFX.stream = load(path)
		SFX.set_volume_db(0.0 - 12.0)
		SFX.play()
		await SFX.finished
		SFX.queue_free()
	else :
		print("[" + Time.get_time_string_from_system() + "]", "Argument not valid !")

func play_from_path(path, vol = 0.0):
	var SFX = AudioStreamPlayer.new()
	add_child(SFX)
	SFX.set_volume_db(vol)
	SFX.stream = load(path)
	SFX.play()
	await SFX.finished
	SFX.queue_free()

func var_to_dict(mainString) -> Dictionary:
	var endDict : Dictionary = {}
	mainString = mainString.replace(" ","")
	for line in mainString.split("\n") :
		if line != "" and line[0] != "#":
			var key = line.split("=")[0]
			var element = line.split("=")[1]
			endDict[key] = element
	return endDict
