extends Node2D

func parse_files(folder_path):
	# Construct the full paths to the CSV and bitmap files
	var csv_file_path = folder_path + "/data.csv"
	var bitmap_file_path = folder_path + "/image.png" # Adjust file extension as needed
	
	# Parse the CSV file
	if FileAccess.file_exists(csv_file_path):
		var file = FileAccess.open(csv_file_path, FileAccess.READ)
		if file:
			var csv_data = parse_csv(file.get_as_text())
			print("CSV Data: ", csv_data)
			file.close()
		else:
			printerr("Failed to open CSV file!")
	
	# Load the bitmap file
	if FileAccess.file_exists(bitmap_file_path):
		var image = Image.new()
		var err = image.load(bitmap_file_path)
		
		if err == OK:
			var image_texture = ImageTexture.new()
			image_texture.create_from_image(image)
			
			# Ensure the node exists before setting the texture
			var texture_rect = get_node_or_null("TextureRect")
			if texture_rect:
				texture_rect.texture = image_texture
			else:
				printerr("TextureRect node not found!")
		else:
			printerr("Failed to load image: " + err)

func parse_csv(csv_text):
	# Implement CSV parsing logic here
	var lines = csv_text.split("\n")
	var data = {}
	
	for line in lines:
		var parts = line.split(";")
		if parts.size() > 0:
			data[parts[0]] = parts
	
	return data
