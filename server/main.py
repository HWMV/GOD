# 서버 애플리케이션 파일
# FastAPI 설정, 엔드 포인트 생성 => Flask로 변경
# Upload Endpoint(/upload) Evaluate EndPoint(/evaluate)
# FastAPI APP isntance 생성
# 원본의 npy은 사전 처리, 사용자의 영상만 업로드 후 평가
# local IP : 192.168.219.100
from ft_dance_angle import process_user_video
from ft_evaluator import evaluate_angles
from real_evaluate_init import *

from fastapi import FastAPI, File, UploadFile
from fastapi.middleware.cors import CORSMiddleware
import uvicorn
import shutil
from typing import List
import numpy as np
from fastapi import HTTPException

# 비디오 처리 부분 추가 임포트
import os
import errno
from pydantic import BaseModel

app = FastAPI()

# CORS 설정 (다른 도메인/포트에서 실행되는 앱이 서버에 자원 요청 허용)
# 현재 모든 출처 요청 허용 (origins=["*"])
origins = ["*"]
app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
# 루트 경로의 구현
@app.get("/")
def read_root():
    return {"Dance 평가기 입니다"}

# # 평가 결과를 저장할 임시 구조체 (실제 구현에서는 데이터베이스 사용 : 파이어베이스)
# evaluation_results = {}

# 생각해보니 엔드포인트 따로 분리할 필요가 없을 것 같아 병합함(추후 실시간 평가 예정)
@app.post("/upload_and_evaluate")
async def upload_and_evaluate(file: UploadFile = File(...)):
    try:
        uploads_dir = os.path.join(os.getcwd(), "uploads")
        os.makedirs(uploads_dir, exist_ok=True)

        save_path = os.path.join(uploads_dir, file.filename)

        with open(save_path, "wb") as buffer:
            shutil.copyfileobj(file.file, buffer)
        
        # 사용자 영상의 각도 데이터 처리
        user_angles = process_user_video(save_path)
        print(f'user_angles : {user_angles}')

        # 원곡의 각도 데이터 로드
        original_angles = np.load('/Users/hyunwoo/Desktop/god/server/data/origin/angles/3d_angles_data02.npy')

        # 사용자 영상과 원곡의 각도 데이터 비교 및 평가
        result = evaluate_angles(original_angles, user_angles)
        print(f'result : {result}')

        return result
    except Exception as e:
        print(f"Error processing file: {e}")
        raise HTTPException(status_code=500, detail="Internal Server Error")

# # 평가 시작 전 조건 : 첫 프레임에서 사용자 자세와 원곡 자세 매칭 (양쪽 어깨 랜드마크의 기울기 사용)
# class ShoulderSlope(BaseModel):
#     user_slope: float

# 생각해보니 엔드포인트 따로 분리할 필요가 없을 것 같아 병합함(추후 실시간 평가 예정)
@app.post("/stream_and_evaluate")
async def stream_and_evaluate(file: UploadFile = File(...)):
    try:
        uploads_dir = os.path.join(os.getcwd(), "uploads")
        os.makedirs(uploads_dir, exist_ok=True)

        save_path = os.path.join(uploads_dir, file.filename)

        with open(save_path, "wb") as buffer:
            shutil.copyfileobj(file.file, buffer)
    
        # 사용자 영상의 각도 데이터 처리
        user_angles = process_user_video(save_path)
        print(f"user_angles: {user_angles}")

        # 원곡의 각도 데이터 로드
        original_angles = np.load('/Users/hyunwoo/Desktop/god/server/data/origin/angles/3d_angles_data02.npy')
        print(f'original_angles: {original_angles}')

        # 사용자 영상과 원곡의 각도 데이터 비교 및 평가
        result = evaluate_angles(original_angles, user_angles)
        print(f"result: {result}")

        return result
    except Exception as e:
        print(f"Error processing file: {e}")
        return e

# 서버 통신, 업로드 처리 과정 테스트하기 위한 간소화 엔드포인트
@app.post("/test_upload")
async def test_upload(file: UploadFile = File(...)):
    uploads_dir = os.path.join(os.getcwd(), "uploads")
    os.makedirs(uploads_dir, exist_ok=True)
    save_path = os.path.join(uploads_dir, file.filename)
    with open(save_path, "wb") as buffer:
        shutil.copyfileobj(file.file, buffer)
    return {"message": "File uploaded successfully", "path": save_path}

# 서버 실행
# 직접 앱을 실행할 수 있음
if __name__ == "__main__":
    uvicorn.run("main:app", host="192.168.219.100", port=8024, reload=True, log_level="info")
