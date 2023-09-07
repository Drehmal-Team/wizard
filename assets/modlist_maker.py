##
from curses.ascii import HT
import json as js
from time import sleep
import bs4
from selenium import webdriver

Necess = {}
Perf = {}
Opti = {}
global x
x = 0

options = webdriver.FirefoxOptions()
options.add_argument('--headless')
geckoPath = "/home/laerian/.webdrivers/geckodriver.exe"
browser = webdriver.Firefox(options=options)


def get_mod_info(BaseUrl = "https://modrinth.com/mod/sodium/",id=0):
    browser.get(BaseUrl)
    html = browser.page_source
    print("[" + Time.get_time_string_from_system() + "]", f"{BaseUrl} get, parsing...")
    soup = bs4.BeautifulSoup(html,"lxml")
    
    try :
        ModName = soup.find("h1",class_="title").text
    except :
        print("[" + Time.get_time_string_from_system() + "]", "ERROR : Failed to retrieve name !")
        ModName = ""
        with open("problem" + str(id) + ".html","w") as file :
            file.write(html)
    try :
        ModDesc = soup.find("p",class_="description").text
    except :
        print("[" + Time.get_time_string_from_system() + "]", "ERROR : Failed to retrieve description !")
        ModDesc = ""
    try :
        ImgUrl = soup.find("img", class_="avatar").get("src")
    except :
        print("[" + Time.get_time_string_from_system() + "]", "ERROR : Failed to retrieve icon url !")
        ImgUrl = ""

    browser.get(BaseUrl + "/versions?g=1.17.1&l=fabric")
    html = browser.page_source
    juice = bs4.BeautifulSoup(html,"lxml")

    try :
        card = juice.find("div", id="all-versions").findChildren(class_="version-button")[0]
    except :
        print("[" + Time.get_time_string_from_system() + "]", "ERROR : Failed to retrieve version card !")
        card = ""
    try :
        DownloadUrl = card.find("a", class_="download-button").get("href")
    except :
        print("[" + Time.get_time_string_from_system() + "]", "ERROR : Failed to retrieve download URL !")
        DownloadUrl = ""
    try :
        VersionUrl = card.find("a", class_="version__title").get("href")
    except :
        print("[" + Time.get_time_string_from_system() + "]", "ERROR : Failed to retrieve version URL !")
        VersionUrl = ""
    try :
        VersionID = card.find("a", class_="version__title").text
    except :
        print("[" + Time.get_time_string_from_system() + "]", "ERROR : Failed to retrieve version ID !")
        VersionID = ""

    ModData = {
        "name" : ModName,
        "desc" : ModDesc,
        "img_url" : ImgUrl,
        "url" : BaseUrl,
        "dl_url" : DownloadUrl,
        "version_url" : "https://modrinth.com" + VersionUrl,
        "version_name" : VersionID
    }

    print("[" + Time.get_time_string_from_system() + "]", f"{BaseUrl} parsed !")

    return ModData

with open("url_list_necess.txt","r") as file :
    NecessList = file.readlines()

with open("url_list_perf.txt","r") as file :
    PerfList = file.readlines()

with open("url_list_opti.txt","r") as file :
    OptiList = file.readlines()




def get_all(listA,dictA) :
    for line in listA :
        global x
        x += 1
        print("[" + Time.get_time_string_from_system() + "]", line)
        if "\n" in line :
            line = line.replace("\n","")
        if line == "" :
            pass
        elif line[0] != "#" :
            print("[" + Time.get_time_string_from_system() + "]", f"Solving {line}...")
            ModData = get_mod_info(line,x)
            dictA[ModData["name"].lower()] = ModData
            print("[" + Time.get_time_string_from_system() + "]", )
    return dictA

final = {
	"NECESS" : get_all(NecessList,Necess)
		,
	"PERF" : get_all(PerfList,Perf)
		,
	"OPTI" : get_all(OptiList,Opti)
}

with open("modlist.json","w") as file :
    js.dump(final, file)

 ##
 # TESTS
with open("lmao" + ".html","w") as file :
    file.write("lol")