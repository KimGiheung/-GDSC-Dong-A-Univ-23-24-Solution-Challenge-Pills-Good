import os

output_image = "C:\\Users\\ewqds\\Documents\\Pill_Data\\1.Training\\image\\K-001027"
output_json = "C:\\Users\\ewqds\\Documents\\Pill_Data\\1.Training\\Label\\K-001027" 
files_and_folders = os.listdir(output_image)
full_path = os.path.join(output_image, files_and_folders[0])
# 파일 이름에서 확장자를 제거하고, ".json" 확장자를 추가
base_name = os.path.splitext(full_path)[0]
print(base_name)
output_json_file = os.path.join(output_json, base_name.replace("image", "Label") + ".json")

print(full_path)
print(output_json_file)