import cv2
import os

def canny_edge_detector(image):
    gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
    edges = cv2.Canny(gray, threshold1=130, threshold2=500)
    return edges

def find_contours(edges):
    contours, _ = cv2.findContours(edges, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
    return contours

def save_canny_image(image,frame_count):
    # edge): argument 생략
    # 이미지를 저장할 디렉토리 정의
    save_directory = '/Users/hyunwoo/Desktop/god/canny/images'
    # 디렉토리가 존재하는지 확인, 없으면 생성
    if not os.path.exists(save_directory):
        os.makedirs(save_directory)
    # 새 이미지의 경로 정의
    save_path = os.path.join(save_directory, f'frame_{frame_count}.png')
    # 원본 이미지에 윤곽선 그리기
    cv2.drawContours(image, contours, -1, (255, 0, 234), 2)  # 녹색 선으로 모든 윤곽선 그리기
    # 윤곽선이 그려진 이미지 저장
    cv2.imwrite(save_path, image)
    print(f"저장됨: {save_path}")

frame_count = 0
while True:
    frame_path = f'/Users/hyunwoo/Desktop/god/canny/images/frame_{frame_count}.png'
    if not os.path.exists(frame_path):
        print("더 이상 처리할 이미지가 없거나 파일을 찾을 수 없습니다.")
        break

    image = cv2.imread(frame_path)
    if image is None:
        print(f"이미지 로드 실패: {frame_path}")
        break

    edges = canny_edge_detector(image)
    contours = find_contours(edges)
    # edge argument 생략
    save_canny_image(image, frame_count)

    frame_count += 1