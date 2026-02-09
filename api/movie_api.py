import requests

def get_popular_movie():
    url = "https://api.tvmaze.com/shows"
    response = requests.get(url)
    data = response.json()

    # Tomamos la primera serie como ejemplo
    movie = data[0]["name"]
    return movie