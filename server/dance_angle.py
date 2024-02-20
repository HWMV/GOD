import cv2
import mediapipe as mp
import numpy as np

# 각도 계산 함수
# 2D 좌표 각도 계산
# def calculate_angle(a, b, c):
#     a = np.array(a)  
#     b = np.array(b)  
#     c = np.array(c)  

#     radians = np.arctan2(c[1]-b[1], c[0]-b[0]) - np.arctan2(a[1]-b[1], a[0]-b[0])
#     angle = np.abs(radians*180.0/np.pi)
    
#     if angle > 180.0:
#         angle = 360-angle
    
#     return angle

# 3D 각도 계산
def calculate_angle_3d(a, b, c):
    a = np.array(a)  # 첫 번째 점의 좌표
    b = np.array(b)  # 두 번째 점 (꼭짓점)의 좌표
    c = np.array(c)  # 세 번째 점의 좌표

    # 벡터 ba와 bc를 계산
    ba = a - b
    bc = c - b

    # 코사인 각도 공식을 사용하여 각도 계산
    cosine_angle = np.dot(ba, bc) / (np.linalg.norm(ba) * np.linalg.norm(bc))
    angle = np.arccos(cosine_angle)

    # 각도를 도(degree) 단위로 변환
    return np.degrees(angle)

# MediaPipe 포즈 모델 초기화
mp_pose = mp.solutions.pose
pose = mp_pose.Pose(static_image_mode=False, model_complexity=1, smooth_landmarks=True)

# 비디오 파일 로드
video_path = '/Users/hyunwoo/Desktop/god/server/video/origin_sample.mp4'
cap = cv2.VideoCapture(video_path)
# 1. 실시간 녹화 파일 flutter > 과정을 구현 > DB , Local (save path)
# 2. flutter 전부 구현 : 실시간 녹화 save > 추출 엔드포인트 호출 > 평가 엔드포인트 호출 > avr_score 호출 및 시각화(위젯)
# 현재 엔드포인트 : 업로드 & 평가 , 새로 엔드포인트 정의해야 함
user_video_path = '/Users/hyunwoo/Desktop/god/server/video/recording_inference.mp4'
user_cap = cv2.VideoCapture(user_video_path)

# 각도 데이터 저장을 위한 리스트 초기화
angles_data = []
user_angles_data = []

# 프레임 처리
# 원본 영상 처리
while cap.isOpened():
    success, frame = cap.read()
    if not success:
        break
    
    results = pose.process(frame)
    # 각도 계산 로직
    if results.pose_landmarks:
            landmarks = results.pose_landmarks.landmark

            # 왼쪽 어깨, 팔꿈치, 손목의 각도 계산
            # calculate_angle_3d 함수 사용(2D에서 전환)
            left_shoulder = [landmarks[mp_pose.PoseLandmark.LEFT_SHOULDER.value].x, landmarks[mp_pose.PoseLandmark.LEFT_SHOULDER.value].y, landmarks[mp_pose.PoseLandmark.LEFT_SHOULDER.value].z]
            left_elbow = [landmarks[mp_pose.PoseLandmark.LEFT_ELBOW.value].x, landmarks[mp_pose.PoseLandmark.LEFT_ELBOW.value].y, landmarks[mp_pose.PoseLandmark.LEFT_ELBOW.value].z]
            left_wrist = [landmarks[mp_pose.PoseLandmark.LEFT_WRIST.value].x, landmarks[mp_pose.PoseLandmark.LEFT_WRIST.value].y, landmarks[mp_pose.PoseLandmark.LEFT_WRIST.value].z]
            left_arm_angle = calculate_angle_3d(left_shoulder, left_elbow, left_wrist)

            # 오른쪽 어깨, 팔꿈치, 손목의 각도 계산
            right_shoulder = [landmarks[mp_pose.PoseLandmark.RIGHT_SHOULDER.value].x, landmarks[mp_pose.PoseLandmark.RIGHT_SHOULDER.value].y, landmarks[mp_pose.PoseLandmark.RIGHT_SHOULDER.value].z]
            right_elbow = [landmarks[mp_pose.PoseLandmark.RIGHT_ELBOW.value].x, landmarks[mp_pose.PoseLandmark.RIGHT_ELBOW.value].y, landmarks[mp_pose.PoseLandmark.RIGHT_ELBOW.value].z]
            right_wrist = [landmarks[mp_pose.PoseLandmark.RIGHT_WRIST.value].x, landmarks[mp_pose.PoseLandmark.RIGHT_WRIST.value].y, landmarks[mp_pose.PoseLandmark.RIGHT_WRIST.value].z]
            right_arm_angle = calculate_angle_3d(right_shoulder, right_elbow, right_wrist)

            # 왼쪽 어깨, 엉덩이, 무릎 각도 계산
            left_shoulder = [landmarks[mp_pose.PoseLandmark.LEFT_SHOULDER.value].x, landmarks[mp_pose.PoseLandmark.LEFT_SHOULDER.value].y, landmarks[mp_pose.PoseLandmark.LEFT_SHOULDER.value].z]
            left_hip = [landmarks[mp_pose.PoseLandmark.LEFT_HIP.value].x, landmarks[mp_pose.PoseLandmark.LEFT_HIP.value].y, landmarks[mp_pose.PoseLandmark.LEFT_HIP.value].z]
            left_knee = [landmarks[mp_pose.PoseLandmark.LEFT_KNEE.value].x, landmarks[mp_pose.PoseLandmark.LEFT_KNEE.value].y, landmarks[mp_pose.PoseLandmark.LEFT_KNEE.value].z]
            left_hip_angle = calculate_angle_3d(left_shoulder, left_hip, left_knee)

            # 오른쪽 어깨, 엉덩이, 무릎 각도 계산
            right_shoulder = [landmarks[mp_pose.PoseLandmark.RIGHT_SHOULDER.value].x, landmarks[mp_pose.PoseLandmark.RIGHT_SHOULDER.value].y, landmarks[mp_pose.PoseLandmark.RIGHT_SHOULDER.value].z]
            right_hip = [landmarks[mp_pose.PoseLandmark.RIGHT_HIP.value].x, landmarks[mp_pose.PoseLandmark.RIGHT_HIP.value].y, landmarks[mp_pose.PoseLandmark.RIGHT_HIP.value].z]
            right_knee = [landmarks[mp_pose.PoseLandmark.RIGHT_KNEE.value].x, landmarks[mp_pose.PoseLandmark.RIGHT_KNEE.value].y, landmarks[mp_pose.PoseLandmark.RIGHT_KNEE.value].z]
            right_hip_angle = calculate_angle_3d(right_shoulder, right_hip, right_knee)

            # 왼쪽 엉덩이, 무릎, 발목 각도 계산
            left_hip = [landmarks[mp_pose.PoseLandmark.LEFT_HIP.value].x, landmarks[mp_pose.PoseLandmark.LEFT_HIP.value].y, landmarks[mp_pose.PoseLandmark.LEFT_HIP.value].z]
            left_knee = [landmarks[mp_pose.PoseLandmark.LEFT_KNEE.value].x, landmarks[mp_pose.PoseLandmark.LEFT_KNEE.value].y, landmarks[mp_pose.PoseLandmark.LEFT_KNEE.value].z]
            left_ankle = [landmarks[mp_pose.PoseLandmark.LEFT_ANKLE.value].x, landmarks[mp_pose.PoseLandmark.LEFT_ANKLE.value].y, landmarks[mp_pose.PoseLandmark.LEFT_ANKLE.value].z]
            left_knee_angle = calculate_angle_3d(left_hip, left_knee, left_ankle)

            # 오른쪽 엉덩이, 무릎, 발목 각도 계산
            right_hip = [landmarks[mp_pose.PoseLandmark.RIGHT_HIP.value].x, landmarks[mp_pose.PoseLandmark.RIGHT_HIP.value].y, landmarks[mp_pose.PoseLandmark.RIGHT_HIP.value].z]
            right_knee = [landmarks[mp_pose.PoseLandmark.RIGHT_KNEE.value].x, landmarks[mp_pose.PoseLandmark.RIGHT_KNEE.value].y, landmarks[mp_pose.PoseLandmark.RIGHT_KNEE.value].z]
            right_ankle = [landmarks[mp_pose.PoseLandmark.RIGHT_ANKLE.value].x, landmarks[mp_pose.PoseLandmark.RIGHT_ANKLE.value].y, landmarks[mp_pose.PoseLandmark.RIGHT_ANKLE.value].z]
            right_knee_angle = calculate_angle_3d(right_hip, right_knee, right_ankle)

            # 왼쪽 팔꿈치, 어깨, 오른쪽 어깨 각도 계산
            left_elbow = [landmarks[mp_pose.PoseLandmark.LEFT_ELBOW.value].x, landmarks[mp_pose.PoseLandmark.LEFT_ELBOW.value].y, landmarks[mp_pose.PoseLandmark.LEFT_ELBOW.value].z]
            left_shoulder = [landmarks[mp_pose.PoseLandmark.LEFT_SHOULDER.value].x, landmarks[mp_pose.PoseLandmark.LEFT_SHOULDER.value].y, landmarks[mp_pose.PoseLandmark.LEFT_SHOULDER.value].z]
            right_shoulder = [landmarks[mp_pose.PoseLandmark.RIGHT_SHOULDER.value].x, landmarks[mp_pose.PoseLandmark.RIGHT_SHOULDER.value].y, landmarks[mp_pose.PoseLandmark.RIGHT_SHOULDER.value].z]
            left_shoulder_angle = calculate_angle_3d(left_elbow, left_shoulder, right_shoulder)

            # 오른쪽 팔꿈치, 어깨, 왼쪽 어깨 각도 계산
            right_elbow = [landmarks[mp_pose.PoseLandmark.RIGHT_ELBOW.value].x, landmarks[mp_pose.PoseLandmark.RIGHT_ELBOW.value].y, landmarks[mp_pose.PoseLandmark.RIGHT_ELBOW.value].z]
            right_shoulder = [landmarks[mp_pose.PoseLandmark.RIGHT_SHOULDER.value].x, landmarks[mp_pose.PoseLandmark.RIGHT_SHOULDER.value].y, landmarks[mp_pose.PoseLandmark.RIGHT_SHOULDER.value].z]
            left_shoulder = [landmarks[mp_pose.PoseLandmark.LEFT_SHOULDER.value].x, landmarks[mp_pose.PoseLandmark.LEFT_SHOULDER.value].y, landmarks[mp_pose.PoseLandmark.LEFT_SHOULDER.value].z]
            right_shoulder_angle = calculate_angle_3d(right_hip, right_knee, right_ankle)

    angles_data.append([left_arm_angle, right_arm_angle, left_hip_angle, right_hip_angle, left_knee_angle, right_knee_angle, left_shoulder_angle, right_shoulder_angle])

cap.release()

# 사용자 영상 처리
frame_idx = 0
while frame_idx < len(angles_data):
    success, frame = user_cap.read()
    if not success:
        # 마지막 유효한 각도 데이터 사용
        last_angles = user_angles_data[-1] if user_angles_data else [0, 0, 0, 0, 0, 0, 0, 0]
        user_angles_data.append(last_angles)
        print(f"Frame {frame_idx}: Processing") 
    else:
        # MediaPipe 포즈 처리
        results = pose.process(frame)
        # 각도 계산 로직
        if results.pose_landmarks:
                landmarks = results.pose_landmarks.landmark

                # 왼쪽 어깨, 팔꿈치, 손목의 각도 계산
                left_shoulder = [landmarks[mp_pose.PoseLandmark.LEFT_SHOULDER.value].x, landmarks[mp_pose.PoseLandmark.LEFT_SHOULDER.value].y, landmarks[mp_pose.PoseLandmark.LEFT_SHOULDER.value].z]
                left_elbow = [landmarks[mp_pose.PoseLandmark.LEFT_ELBOW.value].x, landmarks[mp_pose.PoseLandmark.LEFT_ELBOW.value].y, landmarks[mp_pose.PoseLandmark.LEFT_ELBOW.value].z]
                left_wrist = [landmarks[mp_pose.PoseLandmark.LEFT_WRIST.value].x, landmarks[mp_pose.PoseLandmark.LEFT_WRIST.value].y, landmarks[mp_pose.PoseLandmark.LEFT_WRIST.value].z]
                left_arm_angle = calculate_angle_3d(left_shoulder, left_elbow, left_wrist)

                # 오른쪽 어깨, 팔꿈치, 손목의 각도 계산
                right_shoulder = [landmarks[mp_pose.PoseLandmark.RIGHT_SHOULDER.value].x, landmarks[mp_pose.PoseLandmark.RIGHT_SHOULDER.value].y, landmarks[mp_pose.PoseLandmark.RIGHT_SHOULDER.value].z]
                right_elbow = [landmarks[mp_pose.PoseLandmark.RIGHT_ELBOW.value].x, landmarks[mp_pose.PoseLandmark.RIGHT_ELBOW.value].y, landmarks[mp_pose.PoseLandmark.RIGHT_ELBOW.value].z]
                right_wrist = [landmarks[mp_pose.PoseLandmark.RIGHT_WRIST.value].x, landmarks[mp_pose.PoseLandmark.RIGHT_WRIST.value].y, landmarks[mp_pose.PoseLandmark.RIGHT_WRIST.value].z]
                right_arm_angle = calculate_angle_3d(right_shoulder, right_elbow, right_wrist)

                # 왼쪽 어깨, 엉덩이, 무릎 각도 계산
                left_shoulder = [landmarks[mp_pose.PoseLandmark.LEFT_SHOULDER.value].x, landmarks[mp_pose.PoseLandmark.LEFT_SHOULDER.value].y, landmarks[mp_pose.PoseLandmark.LEFT_SHOULDER.value].z]
                left_hip = [landmarks[mp_pose.PoseLandmark.LEFT_HIP.value].x, landmarks[mp_pose.PoseLandmark.LEFT_HIP.value].y, landmarks[mp_pose.PoseLandmark.LEFT_HIP.value].z]
                left_knee = [landmarks[mp_pose.PoseLandmark.LEFT_KNEE.value].x, landmarks[mp_pose.PoseLandmark.LEFT_KNEE.value].y, landmarks[mp_pose.PoseLandmark.LEFT_KNEE.value].z]
                left_hip_angle = calculate_angle_3d(left_shoulder, left_hip, left_knee)

                # 오른쪽 어깨, 엉덩이, 무릎 각도 계산
                right_shoulder = [landmarks[mp_pose.PoseLandmark.RIGHT_SHOULDER.value].x, landmarks[mp_pose.PoseLandmark.RIGHT_SHOULDER.value].y, landmarks[mp_pose.PoseLandmark.RIGHT_SHOULDER.value].z]
                right_hip = [landmarks[mp_pose.PoseLandmark.RIGHT_HIP.value].x, landmarks[mp_pose.PoseLandmark.RIGHT_HIP.value].y, landmarks[mp_pose.PoseLandmark.RIGHT_HIP.value].z]
                right_knee = [landmarks[mp_pose.PoseLandmark.RIGHT_KNEE.value].x, landmarks[mp_pose.PoseLandmark.RIGHT_KNEE.value].y, landmarks[mp_pose.PoseLandmark.RIGHT_KNEE.value].z]
                right_hip_angle = calculate_angle_3d(right_shoulder, right_hip, right_knee)

                # 왼쪽 엉덩이, 무릎, 발목 각도 계산
                left_hip = [landmarks[mp_pose.PoseLandmark.LEFT_HIP.value].x, landmarks[mp_pose.PoseLandmark.LEFT_HIP.value].y, landmarks[mp_pose.PoseLandmark.LEFT_HIP.value].z]
                left_knee = [landmarks[mp_pose.PoseLandmark.LEFT_KNEE.value].x, landmarks[mp_pose.PoseLandmark.LEFT_KNEE.value].y, landmarks[mp_pose.PoseLandmark.LEFT_KNEE.value].z]
                left_ankle = [landmarks[mp_pose.PoseLandmark.LEFT_ANKLE.value].x, landmarks[mp_pose.PoseLandmark.LEFT_ANKLE.value].y, landmarks[mp_pose.PoseLandmark.LEFT_ANKLE.value].z]
                left_knee_angle = calculate_angle_3d(left_hip, left_knee, left_ankle)

                # 오른쪽 엉덩이, 무릎, 발목 각도 계산
                right_hip = [landmarks[mp_pose.PoseLandmark.RIGHT_HIP.value].x, landmarks[mp_pose.PoseLandmark.RIGHT_HIP.value].y, landmarks[mp_pose.PoseLandmark.RIGHT_HIP.value].z]
                right_knee = [landmarks[mp_pose.PoseLandmark.RIGHT_KNEE.value].x, landmarks[mp_pose.PoseLandmark.RIGHT_KNEE.value].y, landmarks[mp_pose.PoseLandmark.RIGHT_KNEE.value].z]
                right_ankle = [landmarks[mp_pose.PoseLandmark.RIGHT_ANKLE.value].x, landmarks[mp_pose.PoseLandmark.RIGHT_ANKLE.value].y, landmarks[mp_pose.PoseLandmark.RIGHT_ANKLE.value].z]
                right_knee_angle = calculate_angle_3d(right_hip, right_knee, right_ankle)

                # 왼쪽 팔꿈치, 어깨, 오른쪽 어깨 각도 계산
                left_elbow = [landmarks[mp_pose.PoseLandmark.LEFT_ELBOW.value].x, landmarks[mp_pose.PoseLandmark.LEFT_ELBOW.value].y, landmarks[mp_pose.PoseLandmark.LEFT_ELBOW.value].z]
                left_shoulder = [landmarks[mp_pose.PoseLandmark.LEFT_SHOULDER.value].x, landmarks[mp_pose.PoseLandmark.LEFT_SHOULDER.value].y, landmarks[mp_pose.PoseLandmark.LEFT_SHOULDER.value].z]
                right_shoulder = [landmarks[mp_pose.PoseLandmark.RIGHT_SHOULDER.value].x, landmarks[mp_pose.PoseLandmark.RIGHT_SHOULDER.value].y, landmarks[mp_pose.PoseLandmark.RIGHT_SHOULDER.value].z]
                left_shoulder_angle = calculate_angle_3d(left_elbow, left_shoulder, right_shoulder)

                # 오른쪽 팔꿈치, 어깨, 왼쪽 어깨 각도 계산
                right_elbow = [landmarks[mp_pose.PoseLandmark.RIGHT_ELBOW.value].x, landmarks[mp_pose.PoseLandmark.RIGHT_ELBOW.value].y, landmarks[mp_pose.PoseLandmark.RIGHT_ELBOW.value].z]
                right_shoulder = [landmarks[mp_pose.PoseLandmark.RIGHT_SHOULDER.value].x, landmarks[mp_pose.PoseLandmark.RIGHT_SHOULDER.value].y, landmarks[mp_pose.PoseLandmark.RIGHT_SHOULDER.value].z]
                left_shoulder = [landmarks[mp_pose.PoseLandmark.LEFT_SHOULDER.value].x, landmarks[mp_pose.PoseLandmark.LEFT_SHOULDER.value].y, landmarks[mp_pose.PoseLandmark.LEFT_SHOULDER.value].z]
                right_shoulder_angle = calculate_angle_3d(right_hip, right_knee, right_ankle)

                user_angles_data.append([left_arm_angle, right_arm_angle, left_hip_angle, right_hip_angle, left_knee_angle, right_knee_angle, left_shoulder_angle, right_shoulder_angle])

    frame_idx += 1

user_cap.release()

# 각도 데이터를 numpy 배열로 변환 및 저장
angles_array = np.array(angles_data)
np.save('/Users/hyunwoo/Desktop/god/server/data/origin/angles/3d_angles_data02.npy', angles_array)
user_angles_array = np.array(user_angles_data)
np.save('/Users/hyunwoo/Desktop/god/server/data/users/angles/recording_3d_angles_data02.npy', user_angles_array)
