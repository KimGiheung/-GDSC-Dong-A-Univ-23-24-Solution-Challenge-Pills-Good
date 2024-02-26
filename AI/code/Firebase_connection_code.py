from google.cloud import storage

# Google Cloud Storage 클라이언트 초기화
client = storage.Client()

# 버킷 이름을 설정합니다. 예: 'your-bucket-name'
bucket_name = '/Ai_input_img'

# 버킷 객체 가져오기
bucket = client.get_bucket(bucket_name)

# 버킷에서 파일 이름 설정. 예: 'photo.jpg'
blob_name = 'photo.jpg'

# Blob 객체 가져오기
blob = bucket.blob(blob_name)

# 파일을 로컬 시스템으로 다운로드
blob.download_to_filename('local_photo.jpg')

print('Downloaded storage object {} from bucket {} to local file {}.'.format(
    blob_name, bucket_name, 'local_photo.jpg'))
