from google.cloud import storage
import tensorflow as tf
from PIL import Image
import numpy as np
from flask import Flask, request, jsonify

app = Flask(__name__)

BUCKET_NAME = "znb-tf-model"
class_names = ["Early Blight", "Late Blight", "Healthy"]

model = None


def download_blob(bucket_name, source_blob_name, destination_file_name):
    storage_client = storage.Client()
    bucket = storage_client.get_bucket(bucket_name)
    blob = bucket.blob(source_blob_name)
    blob.download_to_filename(destination_file_name)


@app.route('/predict', methods=['POST'])
def predict(request):
    global model
    if model is None:
        download_blob(
            BUCKET_NAME,
            "models/potatoes.h5",
            "/tmp/potatoes.h5"
        )
        model = tf.keras.models.load_model("/tmp/potatoes.h5")

    image = request.files["file"]
    image = np.array(Image.open(image).convert("RGB").resize((256, 256)))
    image = image / 255
    img_array = tf.expand_dims(image, 0)

    predictions = model.predict(img_array)
    print(predictions)

    predicted_class = class_names[np.argmax(predictions[0])]
    confidence = round(100 * (np.max(predictions[0])), 2)

    return {"class": predicted_class, "confidence": confidence}


if __name__ == '__main__':
    app.run(debug=True)
