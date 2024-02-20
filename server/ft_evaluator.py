# evaluator.py 의 엔드포인트 생성
# 처리 된 데이터를 평가해서 FastAPI에서 사용하도록 리팩토링 & 호출

import cv2
import numpy as np
import mediapipe as mp

# 각 조합의 최대 점수 설정 (why? 현재 조합 수 2개, 100/조합수)
max_score_per_combination = 12.5 # 25 comb4 ea , comb6 16.66666.., comb8 12.5

# 각도 차이에 따른 점수 계산 함수
# 신뢰성을 위해 평가 임계 각도 작게 설정
def calculate_score(angle_difference):
    if angle_difference <= 10:  # 15 # 5 # 10
        return 'Perfect', max_score_per_combination
    elif angle_difference <= 20:    # 30 # 20
        return 'Excellent', max_score_per_combination * 0.8
    elif angle_difference <= 40:    # 60 # 40
        return 'Good', max_score_per_combination * 0.5 # 0.6
    elif angle_difference <= 55:    # 80 # 50 # 55
        return 'Bad', max_score_per_combination * 0.3 
    else:
        return 'Miss', 0

# 각도 차이 계산
# 평가 로직들 리팩토링
def evaluate_angles(original_angles, user_angles):
    # original_angles와 user_angles의 길이를 같게 조정
    min_length = min(len(original_angles), len(user_angles))
    original_angles = original_angles[:min_length]
    user_angles = user_angles[:min_length]

    # 각도 차이 계산
    angle_diff = np.abs(original_angles - user_angles)

    # 각 조합별 점수 계산
    total_scores = 0
    frame_scores_list = []

    for frame_scores in angle_diff:
        frame_scores_labels = [calculate_score(diff) for diff in frame_scores]
        frame_score = sum([score for _, score in frame_scores_labels])
        total_scores += frame_score
        frame_scores_list.append(frame_score)

    # 평균으로 최종 스코어 계산
    average_score = total_scores / len(frame_scores_list) if frame_scores_list else 0

    return {
        "total_score": total_scores,
        "average_score": average_score,
        # "frame_scores": frame_scores_list
    }
