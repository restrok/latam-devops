swagger: '2.0'
info:
  title: my-api
  description: API Gateway with Google Cloud Function backends
  version: 1.0.0
schemes:
  - https
produces:
  - application/json
securityDefinitions: # Aquí añades tus definiciones de seguridad
  google_id_token:
    authorizationUrl: ""
    flow: "implicit"
    type: "oauth2"
    x-google-issuer: "https://accounts.google.com"
    x-google-jwks_uri: "https://www.googleapis.com/oauth2/v3/certs"
security: # Aquí aplicas los requisitos de seguridad a toda la API
  - google_id_token: []
paths:
  /upload:
    post:
      summary: Upload data to Cloud Storage
      operationId: uploadData
      x-google-backend:
        address: ${upload_data_url}
      responses:
        '200':
          description: A successful response
          schema:
            type: object
            properties:
              message:
                type: string
        '400':
          description: No data provided
          schema:
            type: object
            properties:
              error:
                type: string
        '500':
          description: An error occurred
          schema:
            type: object
            properties:
              error:
                type: string
  /getdata:
    get:
      summary: Get data from BigQuery
      operationId: getData
      x-google-backend:
        address: ${get_data_url}
      responses:
        '200':
          description: A successful response
          schema:
            type: array
            items:
              type: object
        '500':
          description: An error occurred
          schema:
            type: object
            properties:
              error:
                type: string