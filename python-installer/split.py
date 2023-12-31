import os
from shutil import copy2, copytree
import tarfile
import os.path
from pathlib import Path

# Use a Mebibyte/Gibibyte converter
SPLIT_FOLDER_LIMIT = 524288000 # In bytes
DREHMAL_VERSION_NAME = 'drehmal-2.2-apotheosis-beta-1.0.1'
# DREHMAL_VERSION_NAME = 'Drehmal 2.2 Apotheosis Beta - 1.0.1'

def split_folder(src, dest = 'split'):
    folder_size = 0
    for dir_path, dir_names, file_names in os.walk(src):
        for file in file_names:
            
            file_path = os.path.join(dir_path, file)
            file_folder = Path(file_path).parents[0]
            file_folder = list(file_folder.parts)
            file_folder.pop(0)
            file_folder = os.path.join('', *file_folder)
            split_path = os.path.join(dest, f'{DREHMAL_VERSION_NAME}-{folder_size//SPLIT_FOLDER_LIMIT}', file_folder)
            if not os.path.exists(split_path): os.makedirs(split_path)
            copy2(file_path, split_path)
            folder_size += os.path.getsize(file_path)
    return dest, folder_size          
            
def compress_split(output_dir, source_dir):
    if not os.path.exists(output_dir): os.makedirs(output_dir)
    with os.scandir(path=source_dir) as dir:
        for entry in dir:
            tar_file = os.path.join(output_dir, entry.name) + '.tar.gz'
            print(f'Compressing {entry.name}, {entry.path} to {tar_file}')
            with tarfile.open(tar_file, "w:gz") as tar:
                tar.add(entry.path, arcname='')
    print('Compression complete') 

def extract_split(source_dir, output_file):
    with os.scandir(path=source_dir) as dir:
        for entry in dir:
            print(f'Extracting {entry.name}')
            with tarfile.open(entry.path, 'r:gz') as tar:
                tar.extractall(output_file)

SRC_DIR = 'map'
DEST_DIR = 'split'
ARCHIVE_FILE = 'archived.tar.gz'
ARCHIVE_DIR = 'archive'

def main():
    split_folder(src=SRC_DIR, dest=DEST_DIR)

    compress_split(ARCHIVE_DIR, 'split')
    
    extract_split(ARCHIVE_DIR, 'extracted_map')
    
if __name__ == "__main__":
    main()