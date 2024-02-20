import cv2
import os

def overlay_and_convert_canny_images_to_video(user_video_path, saved_images_dir, output_video_path, canny_video_path):
    cap = cv2.VideoCapture(user_video_path)
    
    # 비디오가 성공적으로 열렸는지 확인
    if not cap.isOpened():
        print("비디오 파일을 열 수 없습니다.")
        return
    
    # 비디오 속성 가져오기
    frame_width = int(cap.get(3))
    frame_height = int(cap.get(4))
    fps = cap.get(cv2.CAP_PROP_FPS)
    
    fourcc = cv2.VideoWriter_fourcc(*'mp4v') # webm 코덱을 사용 > avi
    out_overlay = cv2.VideoWriter('output_video.mp4', fourcc, fps, (frame_width, frame_height))

    # Canny edge 비디오용 VideoWriter 객체 생성
    out_canny = cv2.VideoWriter(canny_video_path, fourcc, fps, (frame_width, frame_height))
    
    frame_count = 0
    while cap.isOpened():
        ret, frame = cap.read()
        if not ret:
            break
        
        # 저장된 Canny edge 이미지의 경로 구성
        canny_image_path = os.path.join(saved_images_dir, f'frame_{frame_count}.png')
        
        # Canny edge 이미지가 존재하는지 확인
        if os.path.exists(canny_image_path):
            # Canny edge 이미지 읽기
            canny_image = cv2.imread(canny_image_path)
            # 비디오 프레임 크기에 맞게 Canny 이미지 크기 조정
            canny_image_resized = cv2.resize(canny_image, (frame_width, frame_height))
            # 원본 프레임 위에 Canny edge 이미지 오버레이
            overlay_frame = cv2.addWeighted(frame, 0.7, canny_image_resized, 0.5, 0)
            # 'output_video_path' 파일에 오버레이 프레임 쓰기
            out_overlay.write(overlay_frame)
            # 'canny_video_path' 파일에 Canny edge 프레임 쓰기
            out_canny.write(canny_image_resized)
        else:
            # 해당하는 Canny edge 이미지가 없으면 원본 프레임을 그대로 사용
            out_overlay.write(frame)
        
        frame_count += 1
    
    # 작업 완료 시 모든 것을 해제
    cap.release()
    out_overlay.release()
    out_canny.release()
    cv2.destroyAllWindows()
    print("비디오 처리 완료.")

# 경로 정의
user_video_path = '/Users/hyunwoo/Desktop/god/server/video/user_sample.mp4'
saved_images_dir = '/Users/hyunwoo/Desktop/god/canny/images'
output_video_path = '/Users/hyunwoo/Desktop/god/canny/video/canny_sample2.mp4'
canny_video_path = '/Users/hyunwoo/Desktop/god/canny/video/canny_test.mp4'  

# 함수 호출
overlay_and_convert_canny_images_to_video(user_video_path, saved_images_dir, output_video_path, canny_video_path)