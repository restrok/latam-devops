import requests

DOMAIN = "https://my-gateway-5mjnasuv.uc.gateway.dev"

# Función para hacer el POST request
def post_data(file_path):
    url = f"{DOMAIN}/upload"
    headers = {"Content-Type": "text/plain"}
    with open(file_path, 'rb') as file:
        response = requests.post(url, headers=headers, data=file, timeout=70)
    return response

# Función para hacer el GET request
def get_data():
    url = f"{DOMAIN}/getdata"
    response = requests.get(url, timeout=70)
    return response

# Función principal que ejecuta los tests
def main():
    # Ruta al archivo que se va a enviar
    file_path = 'src/int-test/test.csv'
    
    # Realizar POST request
    post_response = post_data(file_path)
    print(f"POST Response Status Code: {post_response.status_code}")
    assert post_response.status_code == 200, "POST request failed!"
    
    # Realizar GET request
    get_response = get_data()
    print(f"GET Response Status Code: {get_response.status_code}")
    assert get_response.status_code == 200, "GET request failed!"

# Ejecutar el script
if __name__ == "__main__":
    main()