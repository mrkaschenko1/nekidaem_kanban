enum Endpoint { login, cards, refresh_token }

class API {
  API();

  factory API.getInstance() => API();

  static final String host = 'trello.backend.tests.nekidaem.ru';

  Uri getEndpoint(Endpoint endpoint) => Uri(
        scheme: 'https',
        host: host,
        path: _paths[endpoint],
      );

  static Map<Endpoint, String> _paths = {
    Endpoint.login: '/api/v1/users/login/',
    Endpoint.cards: '/api/v1/cards/',
    Endpoint.refresh_token: '/api/v1/users/refresh_token/'
  };
}
