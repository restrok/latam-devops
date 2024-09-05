import os
import json
from google.cloud import bigquery

# Configuración del cliente de BigQuery
bigquery_client = bigquery.Client()

# Variables de entorno
dataset_id = os.environ.get('DATASET_ID')
table_id = os.environ.get('TABLE_ID')

def get_data(request):
    try:
        # Construir la consulta SQL
        query = f"""
        SELECT * FROM `{dataset_id}.{table_id}`
        LIMIT 10
        """
        
        # Ejecutar la consulta
        query_job = bigquery_client.query(query)
        results = query_job.result()

        # Convertir los resultados a una lista de diccionarios
        rows = [dict(row) for row in results]

        # Devolver los resultados como una respuesta JSON
        return (json.dumps(rows), 200, {'Content-Type': 'application/json'})

    except Exception as e:
        # Devolver el error como una respuesta JSON
        return (json.dumps({"error": str(e)}), 500, {'Content-Type': 'application/json'})