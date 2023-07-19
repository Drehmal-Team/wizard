##
import json as js
import requests

with open("modlist.json","r") as file :
    modlist = js.load(file)

for pack in modlist :
    for mode in modlist[pack] :
        mod = modlist[pack][mode]
        if mod["img_url"] != "" and mod["name"] != "":
            pic_url = mod["img_url"]
            mod_name = mod["name"].lower().replace(" ","_")
            with open(f"../textures/ModIcons/{mod_name}.png", 'wb') as handle:
                response = requests.get(pic_url, stream=True)

                if not response.ok:
                    print(response)

                for block in response.iter_content(1024):
                    if not block:
                        break

                    handle.write(block)
            mod["img_path"] = f"res://textures/ModIcons/{mod_name}.png"