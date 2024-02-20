import cv2
import numpy as np

def canny_edge_detector(image):
    gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
    edges = cv2.Canny(gray, threshold1=100, threshold2=200)
    return edges

def find_contours(edges):
    contours, _ = cv2.findContours(edges, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
    return contours

# 이미지 로드
image = cv2.imread('path/to/image.jpg')

# Canny 에지 검출
edges = canny_edge_detector(image)

# 윤곽선 찾기
contours = find_contours(edges)

# 윤곽선 좌표 출력 또는 저장
for contour in contours:
    print(contour)  # 좌표 출력
    # 좌표를 파일로 저장하는 코드 추가 가능

# 이미지 로드
image = cv2.imread('frame.jpg 경로')

# 윤곽선 그리기
for i in range(len(contours) - 1):
    cv2.line(image, contours[i], contours[i+1], (0, 255, 0), 2)  # 녹색 선으로 연결

# 이미지 표시
cv2.imshow('Image with Contours', image)
cv2.waitKey(0)
cv2.destroyAllWindows()