import os
import json
import csv
from google.cloud import storage, bigquery
from google.cloud import pubsub_v1

# Configuración de clientes de Google Cloud
storage_client = storage.Client()
bigquery_client = bigquery.Client()

# Variables de entorno
bucket_name = os.environ.get('BUCKET_NAME')
dataset_id = os.environ.get('DATASET_ID')
table_id = os.environ.get('TABLE_ID')

def process_pubsub_event(event, context):
    """Triggered from a message on a Cloud Pub/Sub topic."""
    try:
        # Decodificar el mensaje de Pub/Sub
        pubsub_message = event['data']
        message = json.loads(pubsub_message)

        # Obtener el nombre del archivo del mensaje 
        filename = message['name']
        
        # Descargar el archivo del bucket
        bucket = storage_client.bucket(bucket_name)
        blob = bucket.blob(filename)
        data = blob.download_as_string().decode('utf-8')

        # Parsear el CSV
        rows = list(csv.DictReader(data.splitlines()))

        # Preparar los datos para BigQuery
        table_ref = bigquery_client.dataset(dataset_id).table(table_id)
        errors = bigquery_client.insert_rows_json(table_ref, rows)

        if errors:
            raise RuntimeError(f"BigQuery insert errors: {errors}")

        print(f"File {filename} processed and data inserted into BigQuery successfully.")

    except Exception as e:
        print(f"Error processing file {filename}: {e}")
