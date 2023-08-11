extends Control

@onready var LogLabel = $MarginContainer/PanelContainer/VBoxContainer/MarginContainer/PanelContainer/VBoxContainer/Label
@onready var ProgBar = $MarginContainer/PanelContainer/VBoxContainer/MarginContainer/PanelContainer/VBoxContainer/Control/ProgressBar
@onready var ProgBarDeco = $MarginContainer/PanelContainer/VBoxContainer/MarginContainer/PanelContainer/VBoxContainer/Control/ProgressBarDeco
@onready var PercentLabel = $MarginContainer/PanelContainer/VBoxContainer/MarginContainer/PanelContainer/VBoxContainer/Control/Label

signal RequestFullyCompleted

var value := 0.0
var progress := 0.0
var CurrentAction = ""
var PackageProgress := 0.0
var PackageExtractProgress := 0.0
var MoveResProgress := 0.0

var ModsProgress := []

var ModsNecessUrl := 0.0
var ModsPerfUrl := 0.0
var ModsOptiUrl := 0.0

var ModsNecess := 0.0
var ModsPerf := 0.0
var ModsOpti := 0.0

var ProfileProgress := 0.0
var InstallType = Global.InstallType

var json
var urlOfJars := []
var byteSizes := []
var bytesGotten := []
var fileNames := []

var NecessList := []
var PerfList := []
var OptiList := []

func _ready():
	if InstallType == "" :
		InstallType = "SINGLE"
	PercentLabel.text = ""
	ProgBar.value = 0
	ProgBarDeco.value = 0
	LogLabel.text = "Starting..."
	await get_tree().create_timer(1).timeout
	

	# Checking different types of installs
	if InstallType == "SINGLE" :
		
		"""
		# SET MAX PROGRESS USING GOALS
		
		
		
		# DOWNLOAD MAP PACKAGE
		
		CurrentAction = "MAP"
		var TempPackagePath = Global.SavesFolderPath + "/TempMapPackage.zip"
		$HTTPRequest.download_file = "/home/laerian/Desktop/Package.zip"
		
		LogLabel.text = "Downloading map package..."
		var error = $HTTPRequest.request("https://cdn.modrinth.com/data/ozGBYz2N/versions/ltP2QyBA/SE.mrpack")
		await $HTTPRequest.request_completed
		
		if error != OK :
			print("INSTALLER FAILED")
		else :
			LogLabel.text = "Map package successfully downloaded !"
		
		CurrentAction = "NONE"
		await get_tree().create_timer(0.5).timeout
		
		# EXTRACT THE MAP PACKAGE
		
		CurrentAction = "EXTRACT_MAP"
		LogLabel.text = "Extracting map package..."
		
		DirAccess.make_dir_absolute(Global.SavesFolderPath + "/Drehmal 2.2 Apotheosis")
		var output = []
		OS.execute("unzip", [TempPackagePath,"-d",Global.SavesFolderPath + "/Drehmal 2.2 Apotheosis"], output)
		PackageExtractProgress = 1
		
		LogLabel.text = "Map Package extracted !"
		
		CurrentAction = "NONE"
		await get_tree().create_timer(0.5).timeout
		
		# MOVE THE RES IF NEEDED
		
		if Global.RessourcePackMode == "BOTH" or Global.RessourcePackMode == "GLOBAL" :
			CurrentAction = "RES"
			LogLabel.text = "Moving/copying resource pack..."
			OS.execute("unzip", [Global.SavesFolderPath + "/Drehmal 2.2 Apotheosis/resources.zip","-d",Global.ResFolderPath + "/Drehmal 2.2 - Ressourcepack"], output)
			if Global.RessourcePackMode == "GLOBAL" :
				MoveResProgress = 0.7
				DirAccess.remove_absolute(Global.SavesFolderPath + "/Drehmal 2.2 Apotheosis/resources.zip")
			LogLabel.text = "Sucessfully moved/copied resource pack !"
			
			MoveResProgress = 1
			
			CurrentAction = "NONE"
			await get_tree().create_timer(0.5).timeout
		"""
		# RECURSIVELY DOWNLOAD MODS
		
		CurrentAction = "MODS"
		LogLabel.text = "Starting mod processing..."
		
		var lines
		
		FileAccess.open("res://assets/url_list_necess.txt", FileAccess.READ)
		lines = FileAccess.get_file_as_string("res://assets/url_list_necess.txt")
		NecessList = _urls_to_list(lines)
	
		FileAccess.open("res://assets/url_list_perf.txt", FileAccess.READ)
		lines = FileAccess.get_file_as_string("res://assets/url_list_perf.txt")
		PerfList = _urls_to_list(lines)
	
		FileAccess.open("res://assets/url_list_opti.txt", FileAccess.READ)
		lines = FileAccess.get_file_as_string("res://assets/url_list_opti.txt")
		OptiList = _urls_to_list(lines)
		
		if Global.NecessMods :
			LogLabel.text = "Collecting Necessary mods..."
			
			CurrentAction = "MODS_COLLECT"
			for slug in NecessList:
				
				LogLabel.text = "Collecting slug " + slug + " ..."
				$HTTPRequest.request("https://api.modrinth.com/v2/project/" + slug +"/version?loaders=[%22fabric%22]&game_versions=[%221.17.1%22]",["User-Agent: Drehmal_Installer_beta (drehmal.net)"])
				
				await RequestFullyCompleted
				
				urlOfJars.append(json[0]["files"][0]["url"])
				byteSizes.append(json[0]["files"][0]["size"])
				fileNames.append(json[0]["files"][0]["filename"])
				
				ModsNecessUrl = float(len(urlOfJars)) / float(len(NecessList))
			LogLabel.text = "All necessary mods collected !"
			await get_tree().create_timer(0.2).timeout
			
			for i in range(len(urlOfJars)) :
				LogLabel.text = "Downloading " + str(fileNames[i]) + " ..."
				CurrentAction = "NECESS_MODS_DOWNLOAD." + str(i)
				$HTTPRequest.download_file = ("/home/laerian/Desktop/" + fileNames[i])
				$HTTPRequest.request(urlOfJars[i])
				await $HTTPRequest.request_completed
			
			CurrentAction = "NONE"
			LogLabel.text = "All necessary mods downloaded !"
			ModsNecess = 1
			urlOfJars = []
			byteSizes = []
			bytesGotten = []
			fileNames = []
			await get_tree().create_timer(0.2).timeout
		
		if Global.PerfMods :
			LogLabel.text = "Collecting performance mods..."
			
			CurrentAction = "MODS_COLLECT"
			for slug in PerfList:
				
				LogLabel.text = "Collecting slug " + slug + " ..."
				$HTTPRequest.request("https://api.modrinth.com/v2/project/" + slug +"/version?loaders=[%22fabric%22]&game_versions=[%221.17.1%22]",["User-Agent: Drehmal_Installer_beta (drehmal.net)"])
				
				await RequestFullyCompleted
				
				urlOfJars.append(json[0]["files"][0]["url"])
				byteSizes.append(json[0]["files"][0]["size"])
				fileNames.append(json[0]["files"][0]["filename"])
				
				ModsPerfUrl = float(len(urlOfJars)) / float(len(PerfList))
			LogLabel.text = "All performance mods collected !"
			await get_tree().create_timer(0.2).timeout
			
			for i in range(len(urlOfJars)) :
				LogLabel.text = "Downloading " + str(fileNames[i]) + " ..."
				CurrentAction = "PERF_MODS_DOWNLOAD." + str(i)
				$HTTPRequest.download_file = ("/home/laerian/Desktop/" + fileNames[i])
				$HTTPRequest.request(urlOfJars[i])
				await $HTTPRequest.request_completed
			
			CurrentAction = "NONE"
			LogLabel.text = "All performance mods downloaded !"
			ModsNecess = 1
			urlOfJars = []
			byteSizes = []
			bytesGotten = []
			fileNames = []
			await get_tree().create_timer(0.2).timeout
			
		if Global.OptiMods :
			LogLabel.text = "Collecting optimisation mods..."
			
			CurrentAction = "MODS_COLLECT"
			for slug in OptiList:
				
				LogLabel.text = "Collecting slug " + slug + " ..."
				$HTTPRequest.request("https://api.modrinth.com/v2/project/" + slug +"/version?loaders=[%22fabric%22]&game_versions=[%221.17.1%22]",["User-Agent: Drehmal_Installer_beta (drehmal.net)"])
				
				await RequestFullyCompleted
				
				urlOfJars.append(json[0]["files"][0]["url"])
				byteSizes.append(json[0]["files"][0]["size"])
				fileNames.append(json[0]["files"][0]["filename"])
				
				ModsOptiUrl = float(len(urlOfJars)) / float(len(OptiList))
			LogLabel.text = "All necessary mods collected !"
			await get_tree().create_timer(0.2).timeout
			
			for i in range(len(urlOfJars)) :
				LogLabel.text = "Downloading " + str(fileNames[i]) + " ..."
				CurrentAction = "OPTI_MODS_DOWNLOAD." + str(i)
				$HTTPRequest.download_file = ("/home/laerian/Desktop/" + fileNames[i])
				$HTTPRequest.request(urlOfJars[i])
				await $HTTPRequest.request_completed
			
			CurrentAction = "NONE"
			LogLabel.text = "All optimisation mods downloaded !"
			ModsNecess = 1
			urlOfJars = []
			byteSizes = []
			bytesGotten = []
			fileNames = []
			await get_tree().create_timer(0.2).timeout
			
		
		CurrentAction = "NONE"
		await get_tree().create_timer(0.5).timeout
		
		# CREATE PROFILE
		
		var profilesFilePath = Global.MinecraftFolderPath + "/launcher_profiles.json"
		json = readJSON(profilesFilePath)
		
		var profiles = json["profiles"]
		var profile = {
			"name" : "Drehmal 2.2 : Apotheosis",
			"type" : "custom",
			"created" : Time.get_datetime_string_from_system() + ".000Z",
			"lastUsed" : Time.get_datetime_string_from_system() + ".000Z",
			"lastVersionId" : "fabric-loader-" + Global.FabricVersion.replace(" ","") + "-1.17.1",
			"icon" : ""
		}
		
		
		
		# FINISHED !
		
		
		pass
	if InstallType == "CLIENT" :
		pass
		
	if InstallType == "SERVER":
		print("We don't do those yet...")
		pass
		

func _process(_delta):
	
	if CurrentAction.split(".")[0] == "NECESS_MODS_DOWNLOAD":
		while int(CurrentAction.split(".")[1]) >= len(bytesGotten) :
			bytesGotten.append(0)
		bytesGotten[int(CurrentAction.split(".")[1])] = $HTTPRequest.get_downloaded_bytes()
		ModsNecess = sum(bytesGotten) / sum(byteSizes)
	
	ModsProgress = []
	if Global.NecessMods :
		ModsProgress.append(ModsNecessUrl)
		ModsProgress.append(ModsNecess)
	if Global.PerfMods :
		ModsProgress.append(ModsPerfUrl)
		ModsProgress.append(ModsPerf)
	if Global.OptiMods :
		ModsProgress.append(ModsOptiUrl)
		ModsProgress.append(ModsOpti)
	
	print(ModsProgress)
	
	if CurrentAction == "MAP":
		if $HTTPRequest.get_body_size() == -1 :
			PackageProgress = clamp($HTTPRequest.get_downloaded_bytes() / 9002192,0,1)
		else :
			PackageProgress = clampf(float($HTTPRequest.get_downloaded_bytes()) / float($HTTPRequest.get_body_size()), 0, 1)
	
	if InstallType == "" :
		return
	elif InstallType == "SINGLE" :
		value = (PackageProgress + PackageExtractProgress + MoveResProgress + sum(ModsProgress)/len(ModsProgress) + ProfileProgress)/6.0
	
	progress = snapped(value*100,0.1)
	ProgBar.value = progress
	ProgBarDeco.value = progress
	PercentLabel.text = str(progress).pad_decimals(1) + "%"
	
	
	
func _urls_to_list(txt : String):
	var tempList = []
	for line in txt.split("\n") :
		if "\n" in line :
			line.replace("\n","")
		if line == "":
			pass
		elif line[0] != "#" :
			tempList.append(line.split(" : ")[0])
	return tempList



func _on_http_request_request_completed(_result, _response_code, _headers, body):
	if CurrentAction == "MODS_COLLECT":
		json = JSON.parse_string(body.get_string_from_utf8())
		emit_signal("RequestFullyCompleted")



func sum(list : Array):
	var suma := 0.0
	for each in list :
		suma += each
	return suma
	
func readJSON(json_file_path):
	var file = FileAccess.open(json_file_path, FileAccess.READ)
	var content = file.get_as_text()
	var json = JSON.new()
	var finish = json.parse_string(content)
	return finish
