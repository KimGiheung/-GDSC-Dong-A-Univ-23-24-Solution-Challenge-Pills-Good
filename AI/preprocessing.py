import os
import cv2
import json
import numpy as np
from sklearn.model_selection import train_test_split
import cv2
import numpy as np
from matplotlib import pyplot as plt
from tensorflow.keras.utils import to_categorical

# 이미지와 라벨링 데이터의 경로를 지정합니다.
image_data_folder = 'image directory path'
label_data_folder = 'Label directory path'

# 학습 및 테스트 데이터를 저장할 리스트를 생성합니다.
X = []  # 이미지 데이터
y = []  # 라벨 데이터
def detection(pill_cropped):
    #===================Data preprocessing===================#

    # 잘라낸 이미지의 크기를 확인하고, 필요한 경우 크기를 조정합니다.
    pill_resized = cv2.resize(pill_cropped, (227, 227))

    # 이미지를 그레이스케일로 변환
    gray = cv2.cvtColor(pill_resized, cv2.COLOR_BGR2GRAY)

    # 가우시안 필터를 적용하여 블러 처리
    blurred = cv2.GaussianBlur(gray, (5, 5), 0)
    # 평균 필터 적용
    mean_filtered = cv2.blur(blurred, (5, 5))

    # 히스토그램 평활화
    equalized = cv2.equalizeHist(mean_filtered)

    # Sobel 필터를 사용한 형태 감지
    sobelx = cv2.Sobel(mean_filtered, cv2.CV_64F, 1, 0, ksize=5)
    sobely = cv2.Sobel(mean_filtered, cv2.CV_64F, 0, 1, ksize=5)
    sobel = cv2.magnitude(sobelx, sobely)
    # 임계값 적용하여 이진 이미지 생성
    _, thresholded = cv2.threshold(sobel, 50, 255, cv2.THRESH_BINARY)

    # Canny 에지 검출기 사용
    canny_edges = cv2.Canny(np.uint8(thresholded), 100, 200)
    # Dilution 작업
    dilated = cv2.dilate(canny_edges, np.ones((5,5), np.uint8), iterations=1)

    # SIFT 및 MLBP (예시로 SIFT만 구현, MLBP는 OpenCV에서 직접적으로 지원하지 않음)
    sift = cv2.SIFT_create()
    keypoints, descriptors = sift.detectAndCompute(dilated, None)
    # 결과 이미지 반환 (SIFT 키포인트로 표시된 이미지를 반환합니다)
    result_image = cv2.drawKeypoints(dilated, keypoints, None)

    # OpenCV로 이미지를 BGR에서 RGB로 변환
    processed_image_rgb = cv2.cvtColor(result_image, cv2.COLOR_BGR2RGB)
    return processed_image_rgb

def data_load():
    # 이미지 폴더에서 파일 이름을 반복하여 데이터를 로드합니다.
    count = 0
    for image_code_name in os.listdir(image_data_folder):
        count += (1/8)*100
        # 이미지 파일의 전체 경로
        image_file_path = os.path.join(image_data_folder, image_code_name)
        label_file_path= os.path.join(label_data_folder, image_code_name)

        print("===================", 'data preprocessing', str(count) + "% 완료 ===================")
        for image in os.listdir(image_file_path):
            # 라벨 파일의 전체 image_label_path
            image_path = os.path.join(image_file_path,image)
            label_path = os.path.join(label_file_path, image[:-4]+'.json')
            
            # 이미지를 로드합니다. 
            image = cv2.imread(image_path)
            # 라벨 데이터를 로드합니다.
            with open(label_path, 'r', encoding='utf-8') as label_file:
                label_data = json.load(label_file)
            
            # 라벨 데이터에서 분류 라벨을 추출합니다. (예: 'Normal' 또는 'Abnormal')
            label = label_data['images'][0]['drug_N']

            #===================경게 상자 좌표 추출 작업===================#
            # 라벨링 데이터에서 경계 상자 좌표 추출
            bbox = label_data['annotations'][0]['bbox']
            width, length, w, h = bbox

            # 이미지에서 알약 부분 잘라내기
            pill_cropped = image[length:length+h, width:width+w]
            #============================================================#
            processed_image_rgb = detection(pill_cropped)
            # 이미지와 라벨을 리스트에 추가합니다.
            X.append(processed_image_rgb)  #RGB 차원의 data
            y.append(label)
    return X, y

