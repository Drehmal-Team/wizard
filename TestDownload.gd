extends Node

func _on_TestDL_button_pressed():
	var output = []
	OS.execute("unzip", ["/home/laerian/Desktop/test.zip","-d","/home/laerian/Desktop/test"], output)
	print(output)
	
	"""
	$HTTPRequest.request_completed.connect(_on_request_completed)
	$HTTPRequest.set_download_file("FabricAPI.zip")
	$HTTPRequest.request("https://cdn.modrinth.com/data/P7dR8mSH/versions/0.46.1%2B1.17/fabric-api-0.46.1%2B1.17.jar")
	"""
	
func _on_request_completed(result, response_code, headers, body):
	$Button.text = "It worked !"
	pass
