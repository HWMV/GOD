# 각 조합의 점수 계산: 원본 영상과 사용자 영상의 각도 차이 데이터를 사용하여 각 조합마다 점수를 계산합니다.
# 시간 간격 설정: 1초 간격으로 각 조합의 점수를 계산합니다.
# 평균 점수 계산: 각 조합의 평균 점수를 계산합니다.
# 예시 : 조합 5개면 각 조합마다 최고 점수 20점으로 합니다.
# 최종 점수 합산: 모든 조합에 대한 평균 점수를 합산하여 최종 점수를 도출합니다.
# For Combination extension : 배열, 리스트로 관리
# 5단계 점수 각 36도 기준으로 설정

import cv2
import numpy as np
import mediapipe as mp

# 데이터 로드 (npy 파일)
original_angles = np.load('/Users/hyunwoo/Desktop/god/server/data/origin/angles/3d_angles_data02.npy')
user_angles = np.load('/Users/hyunwoo/Desktop/god/server/data/users/angles/recording_3d_angles_data02.npy')

# original_angles와 user_angles의 길이를 같게 조정
min_length = min(len(original_angles), len(user_angles))
original_angles = original_angles[:min_length]
user_angles = user_angles[:min_length]

# 각 조합의 최대 점수 설정 (why? 현재 조합 수 2개, 100/조합수)
max_score_per_combination = 12.5 # 25 comb4 ea , comb6 16.66666..., comb8 12.5

# 각도 차이에 따른 점수 계산 함수
# 신뢰성을 위해 평가 임계 각도 작게 설정
def calculate_score(angle_difference):
    if angle_difference <= 5:  # 15 # 10
        return 'Perfect', max_score_per_combination
    elif angle_difference <= 15:    # 30 # 20
        return 'Excellent', max_score_per_combination * 0.7 # 0.8
    elif angle_difference <= 30:    # 60 # 40
        return 'Good', max_score_per_combination * 0.5 # 0.6
    elif angle_difference <= 45:    # 80 # 50
        return 'Bad', max_score_per_combination * 0.4 
    else:
        return 'Miss', 0

# 각도 차이 계산
angle_diff = np.abs(original_angles - user_angles)
# Bug = 예외 | 4 - 0 | = 4 > Perfect try if user_angles = 0 print("포즈 추정에 실패 했습니다"), reture angle_diff = 50 이상의 차이
# 각 조합별 점수 계산
total_scores = 0
frame_scores_list = []  # 프레임별 점수를 저장할 리스트
for idx, frame_scores in enumerate(angle_diff):
    frame_scores_labels = [calculate_score(diff) for diff in frame_scores]
    frame_score = sum([score for _, score in frame_scores_labels])
    total_scores += frame_score
    frame_scores_list.append(frame_score)  # 프레임 점수 추가
    # 평균으로 최종 스코어
    average_score = total_scores / len(frame_scores_list)

    # 프레임 인덱스 조합 별 점수
    print(f"Frame {idx}: Scores - {frame_scores_labels}")

# 결과 출력
print(f"Total Score: {total_scores}")
print(f"Average Score: {average_score}")
