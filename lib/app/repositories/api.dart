enum Endpoint { login, cards, refresh_token }

class API {
  API();

  factory API.getInstance() => API();

  static final String host = 'trello.backend.tests.nekidaem.ru/api/v1';

  Uri getEndpoint(Endpoint endpoint) => Uri(
        scheme: 'https',
        host: host,
        path: _paths[endpoint],
      );

  static Map<Endpoint, String> _paths = {
    Endpoint.login: 'users/login/',
    Endpoint.cards: 'cards/',
    Endpoint.refresh_token: 'users/refresh_token/'
  };
}
