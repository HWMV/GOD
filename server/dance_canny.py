import cv2
import mediapipe as mp
import numpy as np

# 비디오 파일 로드
video_path = 'App/video/origin_sample.mp4'
cap = cv2.VideoCapture(video_path)

# 비디오가 제대로 열렸는지 확인
if not cap.isOpened():
    print("비디오 파일을 열 수 없습니다.")
    exit()

# 비디오 속성 가져오기
width = int(cap.get(cv2.CAP_PROP_FRAME_WIDTH))
height = int(cap.get(cv2.CAP_PROP_FRAME_HEIGHT))
fps = cap.get(cv2.CAP_PROP_FPS)

# 코덱 정의 및 VideoWriter 객체 생성
output_video = cv2.VideoWriter('App/video/feedback/fb05.mp4', cv2.VideoWriter_fourcc(*'mp4v'), fps, (width, height))

while cap.isOpened():
    ret, frame = cap.read()
    if not ret:
        break

    # 그레이스케일로 변환
    gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)

    # 가우시안 블러 적용
    blurred = cv2.GaussianBlur(gray, (13, 13), 0)

    # Canny 에지 검출 적용
    edges = cv2.Canny(blurred, 50, 150)
    
    # 에지를 BGR로 변환 (비디오 호환성을 위해)
    edges_bgr = cv2.cvtColor(edges, cv2.COLOR_GRAY2BGR)

    # 처리된 프레임을 출력 비디오에 쓰기
    output_video.write(edges_bgr)

# 작업이 끝나면 모든 것을 해제
cap.release()
output_video.release()
cv2.destroyAllWindows()