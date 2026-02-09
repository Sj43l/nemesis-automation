from api.movie_api import get_popular_movie

def test_movie_name_not_empty():
    movie = get_popular_movie()
    assert movie is not None
    assert len(movie) > 0