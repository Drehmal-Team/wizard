extends Control

var InstallerUrl = ""
@onready var LogLabelDownload = $VBoxContainer/VBoxContainer/HBoxContainerDL/VBoxContainer/LogLabel
@onready var LogLabelInstall = $VBoxContainer/VBoxContainer/HBoxContainerInstall/VBoxContainer/LogLabel


func _ready():
	$VBoxContainer/VBoxContainer/HBoxContainerInstall/TextureButton.disabled = true
	$VBoxContainer/VBoxContainer/HBoxContainerInstall/VBoxContainer/Label2.text = "Download the installer first !"


func _on_download_button_pressed():
	_change_label(LogLabelDownload, "Finding most recent version...", Color("ORANGE"))
	$HTTPRequestVer.request("https://meta.fabricmc.net/v2/versions/installer",["User-Agent: Drehmal_Installer_beta (drehmal.net)"])
	await $HTTPRequestVer.request_completed
	_change_label(LogLabelDownload, "Most recent version found !", Color("GREEN"))
	await get_tree().create_timer(0.5).timeout
	_change_label(LogLabelDownload, "Downloading the installer...", Color("ORANGE"))
	$HTTPRequestJar.download_file = "res://assets/fabric/FabricInstaller.jar"
	$HTTPRequestJar.request(InstallerUrl,["User-Agent: Drehmal_Installer_beta (drehmal.net)"])
	await $HTTPRequestJar.request_completed
	
	_change_label(LogLabelDownload, "Installer successfully downloaded ! Move on to the next step.", Color("GREEN"))
	$VBoxContainer/VBoxContainer/HBoxContainerInstall/TextureButton.disabled = false
	$VBoxContainer/VBoxContainer/HBoxContainerInstall/VBoxContainer/Label2.text = "You've successfully downloaded the installer! Click on the Fabric button on the left to launch the Installer when you are ready."
	$VBoxContainer/VBoxContainer/HBoxContainerDL/TextureRect.texture = load("res://textures/Checks/checked.png")
	
func _on_http_request_request_completed(_result, _response_code, _headers, body):
	var json = JSON.parse_string(body.get_string_from_utf8())
	InstallerUrl = json[0]["url"]
	

func _on_install_button_pressed():
	_change_label(LogLabelInstall, "Executing the installer...", Color("ORANGE"))
	
	var thread = Thread.new()
	thread.start(install_the_jar)
	thread.wait_to_finish()
	_change_label(LogLabelInstall, "Fabric installed !", Color("GREEN"))
	$VBoxContainer/VBoxContainer/HBoxContainerInstall/TextureRect.texture = load("res://textures/Checks/checked.png")
	Global.FabricInstalled = true

func install_the_jar():
	var output := []
	OS.execute("java", PackedStringArray(["-jar", ProjectSettings.globalize_path("res://assets/fabric/FabricInstaller.jar"), "client", "-noprofile", "-mcversion", "1.17.1"]), output , true, true)

func _change_label(label : Label, txt : String, color : Color):
	label.text = txt
	label.label_settings.font_color = color
