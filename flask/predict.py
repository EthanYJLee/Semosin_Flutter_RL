from flask import Flask, jsonify, render_template, request
from sklearn.preprocessing import PolynomialFeatures
from PIL import Image
import numpy as np
import pandas as pd
import joblib
from io import BytesIO
import keras

app = Flask(__name__)
app.config['MAX_CONTENT_LENGTH'] = 16 * 1024 * 1024 # 용량 제한 16MB

# multipart file을 이미지로 만들어서 이를 통해서 딥러닝 모델 만들기
@app.route("/predict", methods = ['POST']) # 라우팅 설정
def predict():
    
    # image 가져오기
    f = request.files['image']

    # 이미지 처리
    imageArr = imageProcess(f)

    # 반전 시킨 이미지로 모델에서 예측하기
    answer , array = deepLearningModel(imageArr)

    # 오차 범위 안에 있는지 없는지 판단하기
    errorState = isError(array)

    return jsonify({"result": answer,"error":errorState})

# 이미지 처리
def imageProcess(f):
    image_bytes = f.read()
    image = Image.open(BytesIO(image_bytes))
    
    # 이미지 사이즈 조절 하기
    imageResize = image.resize((128,128))

    # numpy array 만들기
    imageArr = np.array(imageResize)

    # 색상 반전 시키기
    imageArr = 255 - imageArr

    return imageArr

# model 불러와서 예측하는 것
def deepLearningModel(imageArr):
    model = keras.models.load_model('./model/six-shoes-model.h5')
    imgScaled = imageArr.reshape(-1,128,128,3) / 255.0

    ans = {
        0 : 'adidas1',
        1 : 'adidas2',
        2 : 'converse1',
        3 : 'converse2',
        4 : 'nike1',
        5 : 'nike2',
    }

    temp = model.predict(imgScaled)
    array = temp.tolist()
    answer = ans[np.argmax(temp)]

    return answer ,array

# 오차 범위 안에 드는지 안드는지 확인 : 이미지가 쌩뚱맞은 이미지인지 판별하기 위해서
def isError(array):
    errorState = False
    error = pd.read_csv('./model/error.csv')

    if(array[0][0] == np.max(array)):
           if(((array[0][1] < error.iloc[0,0]) | (array[0][1] > error.iloc[0,1])) |
            ((array[0][2] < error.iloc[1,0]) | (array[0][2] > error.iloc[1,1])) |
            ((array[0][3] < error.iloc[2,0]) | (array[0][3] > error.iloc[2,1])) |
            ((array[0][4] < error.iloc[3,0]) | (array[0][4] > error.iloc[3,1])) |
            ((array[0][5] < error.iloc[4,0]) | (array[0][5] > error.iloc[4,1])) ):
            errorState = True 

    return errorState

if __name__ == "__main__":
    app.run(host='127.0.0.1',port=5000,debug=True)