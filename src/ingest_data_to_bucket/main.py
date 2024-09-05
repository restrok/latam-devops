import os
import time
from google.cloud import storage
import json

# Configuración del cliente de Google Cloud Storage
storage_client = storage.Client()
bucket_name = os.environ.get('BUCKET_NAME')
bucket = storage_client.bucket(bucket_name)

def upload_data(request):
    try:
        # Obtener los datos del request
        data = request.get_data(as_text=True)
        if not data:
            return (json.dumps({"error": "No data provided"}), 400, {'Content-Type': 'application/json'})

        # Generar un nombre de archivo único
        filename = f"data_{int(time.time())}.csv"
        blob = bucket.blob(filename)

        # Subir el archivo al bucket
        blob.upload_from_string(data, content_type='text/csv')

        return (json.dumps({"message": f"File {filename} uploaded successfully"}), 200, {'Content-Type': 'application/json'})

    except Exception as e:
        return (json.dumps({"error": str(e)}), 500, {'Content-Type': 'application/json'})