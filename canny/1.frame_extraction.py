import cv2
import mediapipe as mp
import numpy as np
# Graffiti -> constour1 -> 사용자 영상에 오버레이 
# MediaPipe 포즈 솔루션 초기화
mp_pose = mp.solutions.pose
pose = mp_pose.Pose(static_image_mode=False, model_complexity=2, enable_segmentation=True)

# 비디오 파일 로드
video_path = '/Users/hyunwoo/Desktop/god/server/video/origin_sample.mp4'
cap = cv2.VideoCapture(video_path)

# 비디오가 제대로 열렸는지 확인
if not cap.isOpened():
    print("비디오 파일을 열 수 없습니다.")
    exit()

# Canny 에지 검출을 수행하는 함수
def canny_edge_detector(image):
    gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
    edges = cv2.Canny(gray, threshold1=140, threshold2=500)
    return edges

# 처리된 프레임 수를 추적하기 위한 카운터
frame_count = 0

while cap.isOpened() :
    ret, frame = cap.read()
    if not ret:
        break

    # 프레임을 RGB로 변환
    frame_rgb = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)

    # MediaPipe 포즈로 프레임 처리
    results = pose.process(frame_rgb)

    if results.pose_landmarks and results.segmentation_mask is not None:
        # 세그멘테이션 마스크에서 마스크 생성
        mask = results.segmentation_mask > 0.5
        mask = mask.astype(np.uint8) * 255

        # 마스크를 프레임에 적용
        masked_frame = cv2.bitwise_and(frame, frame, mask=mask)

        # 마스크된 프레임에 Canny 에지 검출 적용
        edges = canny_edge_detector(masked_frame)
    
        # 이미지 저장
        cv2.imwrite(f'/Users/hyunwoo/Desktop/god/canny/images/frame_{frame_count}.png', edges)

    # 프레임 카운터 증가
    frame_count += 1


# 리소스 해제
cap.release()
cv2.destroyAllWindows()