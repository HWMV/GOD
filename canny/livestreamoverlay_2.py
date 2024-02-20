import cv2
import time
# 3초 카운트 있는 버전 
def run_webcam():
    # 웹캠에서 비디오 캡처 (0은 기본 카메라)
    cap = cv2.VideoCapture(0)

    # canny_sample.mp4 비디오 로드
    canny_video = cv2.VideoCapture('/Users/hyunwoo/Desktop/App/server/canny/Canny_test.mp4')

    # 웹캠과 canny_sample.mp4가 제대로 열렸는지 확인
    if not cap.isOpened():
        raise IOError("웹캠을 열 수 없습니다.")
    if not canny_video.isOpened():
        raise IOError("canny_sample.mp4 비디오를 열 수 없습니다.")

    # 3초 카운트를 위한 시작 시간
    start_time = time.time()

    countdown_started = False
    countdown_duration = 3  # 카운트다운 지속 시간(초)

    while True:
        # 웹캠에서 프레임별로 캡처
        ret, frame = cap.read()

        # 프레임이 제대로 읽혔는지 확인
        if not ret:
            print("웹캠에서 프레임을 받을 수 없습니다.")
            break

        current_time = time.time()
        elapsed_time = current_time - start_time

        if elapsed_time <= countdown_duration:
            countdown_started = True
            # 카운트다운에 남은 초 계산
            remaining_seconds = countdown_duration - int(elapsed_time)
            # 프레임에 카운트다운 텍스트 넣기
            font = cv2.FONT_HERSHEY_SIMPLEX
            cv2.putText(frame, str(remaining_seconds), (frame.shape[1]//2 - 10, frame.shape[0]//2 + 10), font, 1, (0, 255, 255), 2, cv2.LINE_AA)
        elif countdown_started:
            # canny_sample.mp4에서 프레임 읽기
            ret_canny, frame_canny = canny_video.read()

            # 프레임이 제대로 읽혔는지 확인
            if not ret_canny:
                print("canny_sample.mp4 비디오의 끝이거나 프레임을 받을 수 없습니다.")
                break

            # canny_sample.mp4 프레임을 웹캠 프레임 위에 오버레이
            frame_canny_resized = cv2.resize(frame_canny, (frame.shape[1], frame.shape[0]))
            overlay_frame = cv2.addWeighted(frame, 0.5, frame_canny_resized, 0.5, 0)

            # 오버레이 프레임 표시
            frame = overlay_frame

        # 웹캠에서 결과 프레임 또는 오버레이 표시
        cv2.imshow('Webcam Live', frame)

        # 'q'가 눌리거나 ESC 키가 눌렸을 때 루프 종료
        if cv2.waitKey(1) & 0xFF == ord('q') or cv2.waitKey(1) == 27:
            break

    # 모든 작업이 완료되면 캡처 해제
    cap.release()
    canny_video.release()
    cv2.destroyAllWindows()

if __name__ == '__main__':
    run_webcam()
