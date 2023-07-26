extends Control


func _ready():
	pass


func _on_download_button_pressed():
	$HTTPRequestIMG.download_file = "res://assets/fabric/fabricInstaller.jar"
	$HTTPRequestIMG.request("",["User-Agent: Drehmal_Installer_beta (drehmal.net)"])

func _on_http_request_request_completed(_result, _response_code, _headers, _body):
	pass

func _on_install_button_pressed():
	pass # Replace with function body.



