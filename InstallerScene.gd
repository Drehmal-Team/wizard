extends Control

@onready var LogLabel = $MarginContainer/PanelContainer/VBoxContainer/MarginContainer/PanelContainer/VBoxContainer/Label
@onready var ProgBar = $MarginContainer/PanelContainer/VBoxContainer/MarginContainer/PanelContainer/VBoxContainer/Control/ProgressBar
@onready var ProgBarDeco = $MarginContainer/PanelContainer/VBoxContainer/MarginContainer/PanelContainer/VBoxContainer/Control/AspectRatioContainer/ProgressBarDeco
@onready var PercentLabel = $MarginContainer/PanelContainer/VBoxContainer/MarginContainer/PanelContainer/VBoxContainer/Control/Label
@onready var ShaderRect = $Background

signal RequestFullyCompleted

signal InstallFinished
signal ActionFinished(action)

signal MoveMods
signal InstallMods(pack)

signal DownloadRes

signal DownloadMapPackage
signal ExtractMapPackage
signal MoveRes

signal CreateProfile


var ActionList := []

var timeTime := 0.0
var timeSpentDownloading : float

var value := 0.0
var progress := 0.0
var CurrentAction = ""
var PackageProgress := 0.0
var PackageExtractProgress := 0.0
var ResProgress := 0.0
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

var tween : Tween
var json
var urlOfJars := []
var byteSizes := []
var bytesGotten := []
var fileNames := []

var NecessList := []
var PerfList := []
var OptiList := []



func _ready():
	timeTime = Time.get_unix_time_from_system()
	$MarginContainer/PanelContainer/VBoxContainer/TextureButton.hide()
	if InstallType == "" :
		InstallType = "SINGLE"	
	PercentLabel.text = ""
	ProgBar.value = 0
	ProgBarDeco.value = 0
	LogLabel.text = "Starting..."
	
	DownloadMapPackage.connect(downloadMapPackage)
	ExtractMapPackage.connect(extractMapPackage)
	MoveMods.connect(moveMods)
	InstallMods.connect(mods)
	MoveRes.connect(moveRes)
	CreateProfile.connect(createProfile)
	ActionFinished.connect(actionFinished)
	InstallFinished.connect(installComplete)
	
	await get_tree().create_timer(1).timeout
	
	
	
	# Checking different types of installs
	if InstallType == "SINGLE" :
		ActionList.append_array(["MAP_PACK","EXTRACT","MOVE_MODS"])
		if Global.NecessMods:
			ActionList.append("MODS_NECESS") 
		if Global.PerfMods:
			ActionList.append("MODS_PERF") 
		if Global.OptiMods:
			ActionList.append("MODS_OPTI") 
		ActionList.append("MOVE_RES")
		ActionList.append("PROFILE")
		
	if InstallType == "CLIENT" :
		ActionList.append_array(["RES_PACK","MOVE_MODS"])
		ActionList.append("MODS_NECESS") if Global.NecessMods else null
		ActionList.append("MODS_PERF") if Global.PerfMods else null
		ActionList.append("MODS_OPTI") if Global.OptiMods else null
		ActionList.append("PROFILE")
		
	if InstallType == "SERVER":
		print("[" + Time.get_time_string_from_system() + "]", "'SERVER' type install !?")
		print("[" + Time.get_time_string_from_system() + "]", "We don't do those yet... How the fuck did you choose that option ??")
		pass
		
	ActionFinished.emit("START")
	
func actionFinished(action) -> void:
	await get_tree().create_timer(1).timeout
	if action == "START":
		print("[" + Time.get_time_string_from_system() + "]", "First actionFinished called!")
	else:
		print("[" + Time.get_time_string_from_system() + "]", ">=-=-=-=> ActionFinished call with argument : ",action)
		
	if ActionList == []:
		InstallFinished.emit()
		print("[" + Time.get_time_string_from_system() + "]", "Signal emitted : InstallFinished")
		return
	
	print("[" + Time.get_time_string_from_system() + "]","Remaining actions : ",ActionList)
	var new_action : String = ActionList[0]
	print("[" + Time.get_time_string_from_system() + "]", "New action : ", new_action)
	ActionList.remove_at(0)
	
	
	if new_action == "MAP_PACK":
		DownloadMapPackage.emit()
		print("[" + Time.get_time_string_from_system() + "]", "Signal emitted : DownloadMapPackage")
		return
	
	elif new_action == "EXTRACT":
		ExtractMapPackage.emit()
		print("[" + Time.get_time_string_from_system() + "]", "Signal emitted : ExtractMapPackage")
		return
		
	elif new_action == "MOVE_MODS":
		MoveMods.emit()
		print("[" + Time.get_time_string_from_system() + "]", "Signal emitted : MoveMods")
		return
	
	elif new_action.split("_")[0] == "MODS":
		var packType = new_action.split("_")[1]
		InstallMods.emit(packType)
		print("[" + Time.get_time_string_from_system() + "]", "Signal emitted : InstallMods, with args : "+packType)
		return

	elif new_action == "PROFILE":
		CreateProfile.emit()
		print("[" + Time.get_time_string_from_system() + "]", "Signal emitted : CreateProfile")
		return
		
	elif new_action == "RES_PACK":
		DownloadRes.emit()
		print("[" + Time.get_time_string_from_system() + "]", "Signal emitted : DownloadRes")
		return
	
	elif new_action == "MOVE_RES":
		MoveRes.emit()
		print("[" + Time.get_time_string_from_system() + "]", "Signal emitted : MoveRes")
		return
		
	print("[" + Time.get_time_string_from_system() + "]", "End of the ActionFinished function call")
	return

var dlBytes : int
var bodySize : int

func _process(_delta):
	
	if CurrentAction == "DL_RES" :
		dlBytes = signed_to_none($HTTPRequest.get_downloaded_bytes())
		bodySize = signed_to_none($HTTPRequest.get_body_size())
		
		if bodySize == -1 :
			PackageProgress = clampf(float(dlBytes) / 4187593113.0,0,1)
		else :
			PackageProgress = clampf(float(dlBytes) / float(bodySize), 0, 1)
		
		LogLabel.text = "Downloading resource package... (" + str(PackageProgress*100).pad_decimals(1) + " %)"
		
	
	if CurrentAction.split(".")[0] == "NECESS_MODS_DOWNLOAD":
		while int(CurrentAction.split(".")[1]) >= len(bytesGotten) :
			bytesGotten.append(0)
		bytesGotten[int(CurrentAction.split(".")[1])] = $HTTPRequest.get_downloaded_bytes()
		ModsNecess = sum(bytesGotten) / sum(byteSizes)
	
	if CurrentAction.split(".")[0] == "PERF_MODS_DOWNLOAD":
		while int(CurrentAction.split(".")[1]) >= len(bytesGotten) :
			bytesGotten.append(0)
		bytesGotten[int(CurrentAction.split(".")[1])] = $HTTPRequest.get_downloaded_bytes()
		ModsPerf = sum(bytesGotten) / sum(byteSizes)
		
	if CurrentAction.split(".")[0] == "OPTI_MODS_DOWNLOAD":
		while int(CurrentAction.split(".")[1]) >= len(bytesGotten) :
			bytesGotten.append(0)
		bytesGotten[int(CurrentAction.split(".")[1])] = $HTTPRequest.get_downloaded_bytes()
		ModsOpti = sum(bytesGotten) / sum(byteSizes)
	
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
	
	
	if CurrentAction == "MAP":
		timeSpentDownloading += _delta
		
		dlBytes = signed_to_none($HTTPRequest.get_downloaded_bytes())
		bodySize = signed_to_none($HTTPRequest.get_body_size())
		
		if bodySize == -1 :
			PackageProgress = clampf(float(dlBytes) / 4187593113.0,0,1)
		else :
			PackageProgress = clampf(float(dlBytes) / float(bodySize), 0, 1)
		
		LogLabel.text = "Downloading map package... (" + str(PackageProgress*100).pad_decimals(1) + " %)"
		
		if timeSpentDownloading/60 > 120 :
			LogLabel.text += " (Well, have a nice time waiting some more, hope you have a nice day.)"
		elif timeSpentDownloading/60 > 100 :
			LogLabel.text += " (Oh hey, glad you're here ! No, it's still not done.)"
		elif timeSpentDownloading/60 > 80 :
			LogLabel.text += " (Nice weather, eh ? I don't really know, I'm just trying to entertain you.)"
		elif timeSpentDownloading/60 > 60 :
			LogLabel.text += " (Also, don't forget to vary your diet, get some veggies once in a while.)"
		elif timeSpentDownloading/60 > 40 :
			LogLabel.text += " (You should sleep about 8 hours a night, by the way.)"
		elif timeSpentDownloading/60 > 20 :
			LogLabel.text += " (Make some tea if you don't like caffeine, or not sleeping.)"
		elif timeSpentDownloading/60 > 10 :
			LogLabel.text += " (You know what ? You should make yourself some coffee to wait.)"
		elif timeSpentDownloading/60 > 5 :
			LogLabel.text += " (You should go do something else meanhile...)"
		elif timeSpentDownloading/60 > 1 :
			LogLabel.text += " (It can take some time...)"
			
	if InstallType == "" :
		return
	elif InstallType == "SINGLE" :
		value = (PackageProgress*5 + PackageExtractProgress*2 + MoveResProgress*0.2 + sum(ModsProgress)/len(ModsProgress) + ProfileProgress * 0.2) / 10.4
	elif InstallType == "CLIENT" :
		value = (ResProgress + sum(ModsProgress)/len(ModsProgress) + ProfileProgress * 0.2)/2.2	
	
	progress = snapped(value*100,0.1)
	ProgBar.value = progress
	ProgBarDeco.value = remap(progress,0,100,12.5,100)
	PercentLabel.text = str(progress).pad_decimals(1) + "%"
func _urls_to_list(txt : String) -> Array:
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
func sum(list : Array) -> float:
	var suma := 0.0
	for each in list :
		suma += each
	return suma
	
func readJSON(json_file_path):
	var file = FileAccess.open(json_file_path, FileAccess.READ)
	var content = file.get_as_text()
	var finish = JSON.parse_string(content)
	return finish

func writeJSON(dict, json_file_path) -> void:
	var file = FileAccess.open(json_file_path, FileAccess.WRITE) 
	var stringified = JSON.stringify(dict, "\t")
	file.store_string(stringified)
	file.close()

var TempPackagePath

func downloadMapPackage():
	print("[" + Time.get_time_string_from_system() + "]", "Function downloadMapPackage called")
	CurrentAction = "MAP"
	TempPackagePath = Global.SavesFolderPath + "/TempMapPackage.tar.gz"
	$HTTPRequest.download_file = TempPackagePath
	
	LogLabel.text = "Downloading map package..."
	timeSpentDownloading = 0
	error = $HTTPRequest.request(Global.config["MapPackageUrl"],["User-Agent: Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/116.0"])
	await $HTTPRequest.request_completed
	$HTTPRequest.download_file = ""
	
	if error != OK :
		print("[" + Time.get_time_string_from_system() + "]", "INSTALLER FAILED")
	else :
		LogLabel.text = "Map package successfully downloaded !"
		print("[" + Time.get_time_string_from_system() + "]", "Map package succesfully downloaded")
	
	CurrentAction = "NONE"
	
	await get_tree().create_timer(0.5).timeout
	ActionFinished.emit("MAP_PACK")
	print("[" + Time.get_time_string_from_system() + "]", "ActionFinished signal emitted from downloadMapPackage function")
	return

var output = []

func extractMapPackage():
	print("[" + Time.get_time_string_from_system() + "]", "Function extractMapPackage called")
	CurrentAction = "EXTRACT_MAP"
	LogLabel.text = "Extracting map package... (this can freeze the installer, don't be alarmed)"
	await get_tree().create_timer(0.5).timeout
	
	var dirName = await createFolder(Global.SavesFolderPath + "/Drehmal 2.2 Apotheosis")
	output = []
	OS.execute("tar", ["-xvf", TempPackagePath,"-C", Global.SavesFolderPath], output)
	print("[" + Time.get_time_string_from_system() + "]", "Output from tar :")
	print(" --- ", output)
	print()
	PackageExtractProgress = 0.7
	DirAccess.remove_absolute(TempPackagePath)
	PackageExtractProgress = 1
	
	LogLabel.text = "Map Package extracted !"
	
	CurrentAction = "NONE"
	
	ActionFinished.emit("EXTRACT")
	print("[" + Time.get_time_string_from_system() + "]", "ActionFinished signal emitted from extract map package")
	return
	
func moveRes():
	print("[" + Time.get_time_string_from_system() + "]", "Function moveRes called !")
	CurrentAction = "RES"
	LogLabel.text = "Moving/copying resource pack..."
	DirAccess.copy_absolute(Global.SavesFolderPath + "/Drehmal 2.2 Apotheosis/resources.zip", Global.ResFolderPath + "/Drehmal 2.2 -- Resource Pack")
	if Global.RessourcePackMode == "GLOBAL" :
		MoveResProgress = 0.7
		DirAccess.remove_absolute(Global.SavesFolderPath + "/Drehmal 2.2 Apotheosis/resources.zip")
	LogLabel.text = "Sucessfully moved/copied resource pack !"
	
	MoveResProgress = 1
	
	CurrentAction = "NONE"
	
	ActionFinished.emit("MOVE_RES")
	print("[" + Time.get_time_string_from_system() + "]", "ActionFinished signal emitted from moveRes !")
	return
	
var lines
var error : Error
var started_mods = false

func mods(mode):
	print("[" + Time.get_time_string_from_system() + "]", "Function mods called")
	var urlList = []
	var urlRaw : String
	var denom : String
	var pref : String
	
	print("[" + Time.get_time_string_from_system() + "]", "Download file set to :", $HTTPRequest.download_file)
	
	match mode:
		"NECESS":
			urlRaw = "otVJckYQ : cit-resewn
BVzZfTc1 : entitytexturefeatures
YBz7DOs8 : fabricskyboxes
Orvt0mRa : indium
yBW8D80W : lambdynamiclights
P7dR8mSH : fabric-api
PRN43VSY : animatica"
			denom = "Necessary"
			pref = "NECESS"
		"PERF":
			urlRaw = "PtjYWJkn : sodium-extra
Bh37bMuy : reeses-sodium-options
LQ3K71Q1 : dynamic-fps
NNAgCjsB : entityculling
hvFnDODi : lazydfu
gvQqBUqZ : lithium
H8CaAYZC : starlight
AANobbMI : sodium
OVuFYfre : ebe"
			denom = "Performance"
			pref = "PERF"
		"OPTI":
			urlRaw = "FWumhS4T : smoothboot-fabric
GNxdLCoP : cull-leaves
uXXizFIs : ferrite-core
DZ81JNQ1 : audio-engine-tweaks
NRjRiSSD : memoryleakfix
VSNURh3q : c2me-fabric"
			denom = "Optimisation"
			pref = "OPTI"
		"":
			print("[" + Time.get_time_string_from_system() + "]", "[ERROR] Mods function called with null string parameter")
			return ERR_INVALID_PARAMETER
	
	urlList = _urls_to_list(urlRaw)
	
	LogLabel.text = "Collecting " + denom.to_lower() + " mods..."
	
	CurrentAction = "MODS_COLLECT"
	for slug in urlList:
		
		LogLabel.text = "Collecting slug " + slug + " ..."
		$HTTPRequest.download_file = ""
		error = $HTTPRequest.request("https://api.modrinth.com/v2/project/" + slug +"/version?loaders=[%22fabric%22]&game_versions=[%221.17.1%22]",["User-Agent: Drehmal_Installer_beta (drehmal.net)"])
		if error != OK :
			print("[" + Time.get_time_string_from_system() + "]", "Failed to resolve slug : ", slug)
			print("[" + Time.get_time_string_from_system() + "]", "Reason : ",error)
			break
		await RequestFullyCompleted
		
		urlOfJars.append(json[0]["files"][0]["url"])
		byteSizes.append(json[0]["files"][0]["size"])
		fileNames.append(json[0]["files"][0]["filename"])
		
		match mode:
			"Necess":
				ModsNecessUrl = float(len(urlOfJars)) / float(len(urlList))
			"Perf":
				ModsPerfUrl = float(len(urlOfJars)) / float(len(urlList))
			"Opti":
				ModsOptiUrl = float(len(urlOfJars)) / float(len(urlList))
		
	LogLabel.text = "All " + denom + " mods collected !"
	await get_tree().create_timer(0.2).timeout
	
	for i in range(len(urlOfJars)) :
		LogLabel.text = "Downloading " + str(fileNames[i]) + " ..."
		CurrentAction = pref + "_MODS_DOWNLOAD." + str(i)
		$HTTPRequest.download_file = (Global.ModsFolderPath + "/" + fileNames[i])
		$HTTPRequest.request(urlOfJars[i],["User-Agent: Drehmal_Installer_beta (drehmal.net)"])
		await $HTTPRequest.request_completed
	
	if mode == "Necess" :
		LogLabel.text = "Downloading CEM (YoungSoulluoS Fork) ..."
		CurrentAction = "CEM"
		$HTTPRequest.download_file = (Global.ModsFolderPath + "/cem-0.7.1_S8_1.17.jar")
		$HTTPRequest.request("https://github.com/YoungSoulluoS/cem_Fork/releases/download/Soul_Fork_10_1.19.4/cem-0.7.1_S8_1.17.jar",["User-Agent: Drehmal_Installer_beta (drehmal.net)"])
		await $HTTPRequest.request_completed
	
	
	
	CurrentAction = "NONE"
	LogLabel.text = "All necessary mods downloaded !"
	match mode:
		"Necess":
			ModsNecess = 1
		"Perf":
			ModsPerf = 1
		"Opti":
			ModsOpti = 1
	urlOfJars = []
	byteSizes = []
	bytesGotten = []
	fileNames = []
	
	$HTTPRequest.download_file = ""
	ActionFinished.emit("MODS_"+mode)
	print("[" + Time.get_time_string_from_system() + "]", "ActionFinished signal emitted from mods with arg MODS_"+mode)
	return

func moveMods():
	print("[" + Time.get_time_string_from_system() + "]", "Function moveMods called")
	var dirpath : String
	var pastMods := DirAccess.get_files_at(Global.ModsFolderPath)
	if pastMods != PackedStringArray([]):
		LogLabel.text = "Detecting mods in the mods folder ! Moving them to a new folder..."
		await get_tree().create_timer(1.0).timeout
		# CREATING FOLDER
		dirpath = await createFolder(Global.ModsFolderPath + "/Before_Drehmal")
		
		for file in pastMods:
			LogLabel.text = "Moving " + file + " ..."
			print("[" + Time.get_time_string_from_system() + "]", "Moving ", file)
			error = move_file(Global.ModsFolderPath + "/" + file, dirpath)
			if error != OK :
				print("[" + Time.get_time_string_from_system() + "]", "Failed!")
				print("[" + Time.get_time_string_from_system() + "]", "Error : ", error)
				LogLabel.text = "Failed moving " + file + " : " + str(error)
			await get_tree().create_timer(0.2).timeout
			
			
	ActionFinished.emit("MOVE_MODS")
	print("[" + Time.get_time_string_from_system() + "]", "ActionFinished signal emitted from moveMods")
	return

func createProfile():
	CurrentAction = "PROFILE"
	LogLabel.text = "Creating Minecraft profile..."
	var profilesFilePath = Global.MinecraftFolderPath + "/launcher_profiles.json"#Global.MinecraftFolderPath + "/launcher_profiles.json"
	json = readJSON(profilesFilePath)
	
	var profile = {
		"name" : "Drehmal 2.2 : Apotheosis",
		"type" : "custom",
		"javaArgs": "-Xmx" + str(Global.RamValue) + "G",
		"created" : Time.get_datetime_string_from_system() + ".000Z",
		"lastUsed" : Time.get_datetime_string_from_system() + ".000Z",
		"lastVersionId" : "fabric-loader-" + Global.FabricVersion.replace(" ","").replace("\r","") + "-1.17.1",
		# "lastVersionId" : "1.17.1",
		"icon" : "data:image/png;base64,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"
	}
	
	json["profiles"]["drehmal-2.2-apotheosis"] = profile
	writeJSON(json, profilesFilePath)
	
	ProfileProgress = 1.0
	CurrentAction = "NONE"
	LogLabel.text = "Minecraft profile created !"
	
	ActionFinished.emit("CREATE_PROFILE")
	print("[" + Time.get_time_string_from_system() + "]", "ActionFinished signal emitted from createProfile")
	return

func downloadRes():
	
	CurrentAction = "DL_RES"
	LogLabel.text = "Downloading Resource Pack..."
	var resFilePath := Global.ResFolderPath + "/Drehmal 2.2 -- Resource Pack"
	$HTTPRequest.download_file = resFilePath
	$HTTPRequest.request(Global.config["RessourcePackUrl"],["User-Agent: Drehmal_Installer_beta (drehmal.net)"])
	await $HTTPRequest.request_completed
	
	$HTTPRequest.download_file = ""
	LogLabel.text = "Resource Pack successfully downloaded !"
	CurrentAction = "NONE"
	ResProgress = 1
	
	ActionFinished.emit("RES")
	print("[" + Time.get_time_string_from_system() + "]", "ActionFinished signal emitted from downloadRes")
	return

func installComplete():
	Global.TimeSpent = Time.get_unix_time_from_system() - timeTime
	CurrentAction = "COMPLETED"
	LogLabel.text = "Drehmal successfully installed !"
	$MarginContainer/PanelContainer/VBoxContainer/TextureButton.show()
	
	tween = create_tween()
	tween.tween_property(self, "modulate", Color(20.0/100.0, 59.6/100.0, 29.4/100.0), 0.5).set_ease(Tween.EASE_IN)
	await tween.finished
	
	tween = create_tween()
	tween.tween_property(self, "modulate", Color(1,1,1), 2).set_ease(Tween.EASE_OUT)
	await tween.finished

func signed_to_none(x):
	if x < -1 :
		return x + 4294967296
	else:
		return x


func move_file(file : String, folder : String):
	if not DirAccess.dir_exists_absolute(folder):
		return ERR_DOES_NOT_EXIST
	elif not FileAccess.file_exists(file) :
		return ERR_FILE_NOT_FOUND
	
	var filename = ""
	if file.split("/")[-1] == "" :
		filename = file.split("/")[-2]
	else:
		filename = file.split("/")[-1]
		
	if folder[-1] != "/" :
		filename = "/" + filename
	
	DirAccess.copy_absolute(file,folder + filename)
	DirAccess.remove_absolute(file)
	
	return OK

func createFolder(path) -> String:
	var dirpath = path
	if DirAccess.dir_exists_absolute(path) :
		var getTfOut := false
		var addit := 2
		while not getTfOut :
			if DirAccess.dir_exists_absolute(path + "_" + str(addit)) :
				addit += 1
			else :
				DirAccess.make_dir_absolute(path + "_" + str(addit))
				dirpath = path + "_" + str(addit)
				getTfOut = true
			
	else : 
		DirAccess.make_dir_absolute(dirpath)
	return dirpath
		

func _on_texture_button_pressed_leave():
	SceneTransition.dissolve("res://InstallComplete.tscn")
