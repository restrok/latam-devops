import os
from google.cloud import bigquery
from google.cloud.functions.context import Context

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

        return (jsonify(rows), 200)

    except Exception as e:
        return (jsonify({"error": str(e)}), 500)