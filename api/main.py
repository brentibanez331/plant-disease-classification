from fastapi import FastAPI, UploadFile, File
import uvicorn
import numpy as np
from io import BytesIO
from PIL import Image
import tensorflow as tf
import requests
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI()

origins = [
    "http://localhost",
    "http://localhost:3000"
]

app.add_middleware(
    CORSMiddleware,
    allow_credentials=True,
    allow_origins=origins,
    allow_methods=["*"],
    allow_headers=["*"],
)

# MODEL = tf.keras.models.load_model("../models/2")
CLASS_NAMES = ["Early Blight", "Late Blight", "Healthy"]

endpoint = "http://localhost:8501/v1/models/potatoes_model:predict"


@app.get("/ping")
async def ping():
    return "Hello, I am alive!"


def read_file_as_image(data) -> np.ndarray:
    image = np.array(Image.open(BytesIO(data)))
    return image


@app.post("/predict-potato")
async def predict_potato(
        file: UploadFile = File(...)
):
    image = read_file_as_image(await file.read())
    img_batch = np.expand_dims(image, 0)
    # predictions = MODEL.predict(img_batch)

    json_data = {
        "instances": img_batch.tolist()
    }

    response = requests.post(endpoint, json=json_data)
    prediction = np.array(response.json()["predictions"][0])

    predicted_class = CLASS_NAMES[np.argmax(prediction)]
    confidence = np.max(prediction)
    pass
    return {
        'class': predicted_class,
        'confidence': float(confidence)
    }

    # predicted_class = CLASS_NAMES[np.argmax(predictions[0])]
    # confidence = np.max(predictions[0])
    # return{
    #     'class': predicted_class,
    #     'confidence': float(confidence)
    # }


if __name__ == "__main__":
    uvicorn.run(app, host='localhost', port=8000)
