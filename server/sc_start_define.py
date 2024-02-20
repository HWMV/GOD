import cv2
import mediapipe as mp
import numpy as np

# MediaPipe 포즈 모델 초기화
mp_pose = mp.solutions.pose
pose = mp_pose.Pose(static_image_mode=True, model_complexity=1, smooth_landmarks=True)

# 양쪽 어깨 랜드마크 간 기울기 계산 함수
def calculate_slope(shoulder_left, shoulder_right):
    # y2 - y1 / x2 - x1 방법을 사용하여 기울기 계산, 분모가 0인 경우 예외 처리를 통해 처리
    try:
        slope = (shoulder_right[1] - shoulder_left[1]) / (shoulder_right[0] - shoulder_left[0])
        return round(slope, 2)
    except ZeroDivisionError:
        return float('inf')  
    

# 원곡 영상과 사용자 영상에서 첫번째 프레임 양쪽 어깨 랜드마크 추출
def get_first_frame_shoulder_slope(video_path):
    cap = cv2.VideoCapture(video_path)
    success, frame = cap.read()
    if not success:
        print("비디오를 읽을 수 없습니다.")
        return None

    # 첫 프레임에서 포즈 검출
    results = pose.process(cv2.cvtColor(frame, cv2.COLOR_BGR2RGB))

    if results.pose_landmarks:
        landmarks = results.pose_landmarks.landmark
        left_shoulder = [landmarks[mp_pose.PoseLandmark.LEFT_SHOULDER.value].x, landmarks[mp_pose.PoseLandmark.LEFT_SHOULDER.value].y]
        right_shoulder = [landmarks[mp_pose.PoseLandmark.RIGHT_SHOULDER.value].x, landmarks[mp_pose.PoseLandmark.RIGHT_SHOULDER.value].y]

        slope = calculate_slope(left_shoulder, right_shoulder)
        return slope
    else:
        print("첫 프레임에서 포즈를 검출할 수 없습니다.")
        return None

# 웹캠에서 첫 프레임을 캡처하고 어깨 기울기를 얻는 함수
def get_shoulder_slope_from_webcam(origin_slope=None):
    cap = cv2.VideoCapture(0)  # 웹캠 초기화
    user_slope = None  # user_slope 초기화
    with mp_pose.Pose(static_image_mode=False, model_complexity=1, smooth_landmarks=True) as pose:
        while True:
            success, frame = cap.read()
            if not success:
                print("웹캠에서 읽을 수 없습니다.")
                break

            # 캡처된 프레임에서 포즈 감지
            results = pose.process(cv2.cvtColor(frame, cv2.COLOR_BGR2RGB))

            if results.pose_landmarks:
                landmarks = results.pose_landmarks.landmark
                left_shoulder = [landmarks[mp_pose.PoseLandmark.LEFT_SHOULDER.value].x, landmarks[mp_pose.PoseLandmark.LEFT_SHOULDER.value].y]
                right_shoulder = [landmarks[mp_pose.PoseLandmark.RIGHT_SHOULDER.value].x, landmarks[mp_pose.PoseLandmark.RIGHT_SHOULDER.value].y]

                user_slope = calculate_slope(left_shoulder, right_shoulder)
                print(f"현재 어깨 기울기: {user_slope}")  # 기울기 출력

                # origin_slope이 제공되면 기울기를 비교하고 일치하면 조기 종료
                if origin_slope is not None and user_slope is not None:
                    if abs(origin_slope - user_slope) < 0.001:
                        print("매칭 완료")
                        break  # 매칭이 완료되면 루프를 종료
                    else:
                        print("매칭 실패")

                # 프레임 표시
                cv2.imshow('웹캠 피드', frame)
                if cv2.waitKey(1) & 0xFF == ord('q'):  # 'q'를 누르면 종료
                    break

            else:
                print("포즈를 감지할 수 없습니다.")

    cap.release()
    cv2.destroyAllWindows()
    return user_slope  # 계산된 기울기 반환

# 기울기 비교 메인 로직
def compare_slopes():
    # 원본 노래와 사용자 비디오의 경로
    origin_video_path = '/Users/hyunwoo/Desktop/god/server/video/origin_sample.mp4'
    # 각 비디오의 첫 프레임에서 어깨 기울기 계산
    origin_slope = get_first_frame_shoulder_slope(origin_video_path)
    # 웹캠에서 캡처된 첫 프레임에서 어깨 기울기 계산, origin_slope을 비교를 위해 전달
    user_slope = get_shoulder_slope_from_webcam(origin_slope)

compare_slopes()

# flutter에서 웹캠이 켜진상태에서 이 파일을 실행시켜서 매칭이 완료되었다는 문구를 서버로 보낸다



