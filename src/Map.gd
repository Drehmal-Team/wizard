# Using this because Fabric.gd does -- required for child node processes, might need to change
extends Control

# k-v pair of shard number:url
var MAP_SHARDS = { 
	0: 'https://5b92a8a6-6d33-4119-8522-53f0f5e49ea3.usrfiles.com/archives/5b92a8_8e925ea6299e47418cdaa66028baedd5.gz',
	1: 'https://5b92a8a6-6d33-4119-8522-53f0f5e49ea3.usrfiles.com/archives/5b92a8_e5a2493e8de946499cd71da713dfb19a.gz',
	2: 'https://5b92a8a6-6d33-4119-8522-53f0f5e49ea3.usrfiles.com/archives/5b92a8_c1eeae44689847579b8b9efa810dd0ae.gz',
	3: 'https://5b92a8a6-6d33-4119-8522-53f0f5e49ea3.usrfiles.com/archives/5b92a8_57ea04020fe24d198768333dffeef9bb.gz',
	4: 'https://5b92a8a6-6d33-4119-8522-53f0f5e49ea3.usrfiles.com/archives/5b92a8_3c187c3db300467eab209935ca0e2a3b.gz',
	5: 'https://5b92a8a6-6d33-4119-8522-53f0f5e49ea3.usrfiles.com/archives/5b92a8_d45d6dce2cab4242ac754b4b24f8b062.gz',
	6: 'https://5b92a8a6-6d33-4119-8522-53f0f5e49ea3.usrfiles.com/archives/5b92a8_d841d94fd8334f58b63ab8aa83ab5662.gz',
	7: 'https://5b92a8a6-6d33-4119-8522-53f0f5e49ea3.usrfiles.com/archives/5b92a8_716e90b4fa9d4d70b61e457a5ddbce06.gz',
	8: 'https://5b92a8a6-6d33-4119-8522-53f0f5e49ea3.usrfiles.com/archives/5b92a8_8934d61b88594e7ebcd8e157d9e5dcef.gz',
	9: 'https://5b92a8a6-6d33-4119-8522-53f0f5e49ea3.usrfiles.com/archives/5b92a8_8674399f1aaf4bdc90c10db48f5b29eb.gz',
	10: 'https://5b92a8a6-6d33-4119-8522-53f0f5e49ea3.usrfiles.com/archives/5b92a8_2e05191da7f84d4a829c0a887a216d2f.gz',
	11: 'https://5b92a8a6-6d33-4119-8522-53f0f5e49ea3.usrfiles.com/archives/5b92a8_e10c25be92704b45bf34c49cf6f2685e.gz',
}
var DREHMAL_VERSION_FILENAME = 'drehmal-2.2-apotheosis-beta-1.0.1'

func get_map_files():
	# Define and create map shards path, should be a subdir under the installer folder
	var map_shards_path = "user://shards"
	DirAccess.make_dir_absolute(map_shards_path)
	# Likewise, define and create the Drehmal saves folder, should be a subdir under the user's MC/saves dir
	var map_path = "%s/Drehmal 2.2 Apotheosis" % Global.SavesFolderPath
	DirAccess.make_dir_absolute(map_path)
	# Blank array for os-level 'tar' command -- used for extracting the map tarball
	var tar_output = []
	# Iterate over each key in the 'MAP_SHARDS' dictionary
	for shard in MAP_SHARDS:
		# Define path to save the current map shard to
		var shard_path = "%s/%s-%s.tar.gz" % [map_shards_path, DREHMAL_VERSION_FILENAME, shard]
		print("Downloading drehmal.net shard #%s" % shard)
		# Download the shard tarball, wait for complete execution
		$HTTPRequest.download_file = shard_path
		$HTTPRequest.request(MAP_SHARDS[shard])
		await $HTTPRequest.request_completed
		
		print("Extracting map shard #%s" % shard)
		# Wipe the tar cmd output arr, will be appended to
		tar_output = []
		# Execute os-level 'tar' cmd to extract the tarball.
		# NOTE: can consider downloading the map as uncompressed shards to eliminate os-level scripting at the cost of filesize
		# Compressed: 3.88GB, Uncompressed: 5.44GB
		OS.execute("tar", ["-xvf", shard_path, "-C", map_path], tar_output)
		print("[%s] Tar command output:" % Time.get_time_string_from_system())
		print(" --- ", tar_output, "")
		
		print("Removing map shard tarball #%s" % shard)
		# Remove the shard once extracted -- no longer needed by the client, clear up disk space
		DirAccess.remove_absolute(shard_path)
