import numpy as np
import cv2
import mediapipe as mp

mp_pose = mp.solutions.pose
pose = mp_pose.Pose(static_image_mode=True, model_complexity=1, smooth_landmarks=True)

def calculate_slope(shoulder_left, shoulder_right):
    try:
        slope = (shoulder_right[1] - shoulder_left[1]) / (shoulder_right[0] - shoulder_left[0])
        return round(slope, 2)
    except ZeroDivisionError:
        return float('inf')

def get_first_frame_shoulder_slope(video_path):
    cap = cv2.VideoCapture(video_path)
    success, frame = cap.read()
    if not success:
        print("비디오를 읽을 수 없습니다.")
        return None

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

origin_slope = get_first_frame_shoulder_slope('/Users/hyunwoo/Desktop/god/server/video/origin_sample.mp4')
if origin_slope is not None:
    np.save('/Users/hyunwoo/Desktop/god/server/data/origin/shoulder/origin_shoulder_slope01.npy', np.array([origin_slope]))
