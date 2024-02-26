import schedule
import shutil
import time
import os
import json
import pandas as pd
from datetime import datetime, timedelta
import firebase_admin
from firebase_admin import credentials, initialize_app, storage
import requests
import cv2
import preprocessing, train
import numpy as np
from sklearn.preprocessing import StandardScaler
from tensorflow.keras.applications.resnet50 import ResNet50, preprocess_input
from sklearn.neighbors import KNeighborsClassifier

# Path to your firebase service account key (JSON file)
cred = credentials.Certificate("your json key path")
# Specify the path where you will receive data from firebase (e.g. '/your/local/directory/')
path = 'your/local/directory'
# Global variable that records the last time it was checked
last_checked_time = time.time()

# Firebase Admin SDK 초기화
bucket_name = 'your bucket'
firebase_admin.initialize_app(cred, {
    'storageBucket': 'your bucket'
})

#========================data preprocessing========================
X = []
y = []

X, y = preprocessing.data_load()
X = np.array(X)
y = np.array(y)
print(X.shape, y.shape)
scaler, resnet50_model, knn_classifier_resnet = train.resnet_knn_train(X, y)
#========================data preprocessing========================

def job():  
    global last_checked_time
    global path

    start = time.time()
    # Storage 버킷 접근
    bucket = storage.bucket()
    
    #========================firebase data load========================
    # Get list of latest png files in storage    
    blobs = bucket.list_blobs(prefix="your_bucket_name/")
    # Filter only files created since the last time you checked.
    # file_path = os.path.join(path, file_name)
    # file_creation_time = os.path.getctime(file_path)
    print(blob.time_created)
    new_blobs = [blob for blob in blobs if blob.name.endswith('.png')]
    # (blob.time_created > last_checked_time)

    if len(new_blobs) == 0:
        return
        # Save filtered files locally.
    for blob in new_blobs:
        # Set the file name to the creation time.
        # Example: 2023-01-01-00-00-00.png
        filename = blob.name
        file_extension = os.path.splitext(filename)[1]
        new_filename = blob.time_created.strftime("%Y-%m-%d-%H-%M-%S") + file_extension
        local_file_path = os.path.join(path, new_filename)
 
        download_url = blob.generate_signed_url(timedelta(seconds=300), method='GET')
        # Save the file to a local directory, keeping its original names
        local_file_path = os.path.join(path, local_file_path)
        response = requests.get(download_url)
        with open(local_file_path, 'wb') as file:
            file.write(response.content)
            time.sleep(0.5)
    end = time.time()
    print(f"Storage Time: {end-start:.5f}sec")

    # Save the filtered files locally.
    for blob in new_blobs:
        # Set the file name to the creation time.
        # Example: 2023-01-01-00-00-00.png
        filename = blob.name
        file_extension = os.path.splitext(filename)[1]
        new_filename = blob.time_created.strftime("%Y-%m-%d-%H-%M-%S") + file_extension
        local_file_path = os.path.join(path, new_filename)

        # Download the blob to your local file system.
        blob.download_to_filename(local_file_path)
    #========================firebase data load========================
    for file_name in os.listdir(path):
        file_path = os.path.join(path, file_name)
        file_creation_time = os.path.getctime(file_path)
        # We are looking for all files created-
        # between the current time and the last time.
        if file_creation_time > last_checked_time:
    #========================data preprocessing========================
            # Load your image.
            image               = cv2.imread(local_file_path)
            processed_image_rgb = preprocessing.detection(image)
            scaled_image        = scaler.transform(processed_image_rgb.reshape(-1, processed_image_rgb.shape[0]*processed_image_rgb.shape[1]*processed_image_rgb.shape[2]))
            scaled_image        = scaler.reshape(processed_image_rgb.shape)
    #========================data prediction========================
            resnet_features     = resnet50_model.predict(scaled_image)
            prediction          = knn_classifier_resnet.predict(resnet_features)
            print(prediction)
    #========================data upload========================
            # Used example: current_time.strftime("%Y-%m-%d-%H-%M-%S")
            start = time.time()
            current_time = datetime.now()
            formatted_time = current_time.strftime("%Y-%m-%d-%H-%M-%S")

            destination_blob_name = 'Ai_input_img/' + formatted_time + ".json"

            output_image_folder = "your image dataset path" + prediction[0]
            output_json_folder = "your Label dataset path" + prediction[0]
            files_and_folders = os.listdir(output_image_folder)
            output_image_file = os.path.join(output_image_folder, files_and_folders[0])
            # Remove the extension from the file name and add the ".json" extension
            base_name = os.path.splitex(output_image_file)[0] + ".json"
            print(base_name)
            output_json_file = os.path.join(output_json_folder, base_name.replace("image", "Label"))

            upload_blob = bucket.blob(destination_blob_name)
            with open(output_image_file, 'rb') as file:
                upload_blob.upload_from_file(file)
            with open(output_json_file, 'rb') as file:
                upload_blob.upload_from_file(file)

            end = time.time()
            print(f"data send Time: {end-start:.5f}sec")

            # Updates the last time you checked.
            # print("Time :", last_checked_time)
            last_checked_time = time.time()

            # Display new file information
            print(f'File {filename} has been downloaded as {new_filename}')
    print("=============================end=============================")


# Run the job function every minute.
global_start = time.time()
schedule.every(5).seconds.do(job)
global_end   = time.time()
print(f"All Time: {global_end-global_start:.5f}sec")

count = 1
if __name__ == "__main__":
    while True:
        schedule.run_pending()
        # print(time.time())
        time.sleep(1)
