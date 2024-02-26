from sklearn.neighbors import KNeighborsClassifier
from sklearn.model_selection import train_test_split
from sklearn.metrics import accuracy_score
from sklearn.preprocessing import StandardScaler
from tensorflow.keras.applications.resnet50 import ResNet50, preprocess_input

def resnet_knn_train(X, y):
    # 데이터를 훈련과 테스트 세트로 분리    
    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)
        
    # 데이터 전처리: 스케일링
    scaler = StandardScaler()
    X_train_scaled = scaler.fit_transform(X_train.reshape(-1, X_train.shape[1]*X_train.shape[2]*X_train.shape[3]))
    X_test_scaled = scaler.transform(X_test.reshape(-1, X_test.shape[1]*X_test.shape[2]*X_test.shape[3]))
    X_train_scaled = X_train_scaled.reshape(X_train.shape)
    X_test_scaled = X_test_scaled.reshape(X_test.shape)

    # ResNet-50 모델 로드 (사전 훈련된 가중치 포함)
    resnet50_model = ResNet50(weights='imagenet', include_top=False, input_shape=(227, 227, 3))

    # 데이터 전처리: ResNet-50에 맞게 입력 데이터 전처리
    X_train_resnet = preprocess_input(X_train_scaled)
    X_test_resnet = preprocess_input(X_test_scaled)

    # ResNet-50을 통한 특징 추출
    X_train_resnet_features = resnet50_model.predict(X_train_resnet)
    X_test_resnet_features = resnet50_model.predict(X_test_resnet)

    # 특징 벡터 평탄화 (훈련을 위해)
    X_train_resnet_features_flat = X_train_resnet_features.reshape(X_train_resnet_features.shape[0], -1)
    X_test_resnet_features_flat = X_test_resnet_features.reshape(X_test_resnet_features.shape[0], -1)

    # k-NN 분류기 (ResNet-50 특징을 사용) 생성 및 훈련
    k = 15  # k-NN에서 사용할 이웃의 수
    knn_classifier_resnet = KNeighborsClassifier(n_neighbors=k)
    knn_classifier_resnet.fit(X_train_resnet_features_flat, y_train)

    # k-NN을 사용한 분류 (ResNet-50 특징을 사용)
    y_pred_resnet_test = knn_classifier_resnet.predict(X_test_resnet_features_flat)
    y_pred_resnet_train = knn_classifier_resnet.predict(X_train_resnet_features_flat)

    # 분류 결과의 정확도 평가
    accuracy_resnet_train = accuracy_score(y_train, y_pred_resnet_train)
    print(f'ResNet-50 + k-NN classifier train set accuracy: {accuracy_resnet_train * 100:.2f}%')
    accuracy_resnet_test = accuracy_score(y_test, y_pred_resnet_test)
    print(f'ResNet-50 + k-NN classifier test set accuracy: {accuracy_resnet_test * 100:.2f}%')

    return scaler, resnet50_model, knn_classifier_resnet
