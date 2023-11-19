import 'dart:async';
import 'dart:convert';
import 'dart:io';

Future<T> request<T>(String method, Uri url,
    [FutureOr<void Function(HttpClientRequest)?> handleRequest]) async {
  final HttpClient client = HttpClient();
  final HttpClientRequest request = await client.openUrl(method, url);

  await handleRequest!!(request);

  final HttpClientResponse response = await request.close();

  final Stream<Object?> stream =
      await response.transform(utf8.decoder).transform(json.decoder);
  client.close();

  final Object? data = await stream.first;

  return data as T;
}

class Discord {
  final String _token;

  const Discord(this._token);

  Uri _getEndpoint(String endpoint) =>
      Uri.parse('https://discord.com/api$endpoint');

  HttpClientRequest _addHeaders(HttpClientRequest request) {
    request.headers.add('Authorization', 'Bot $_token');
    return request;
  }

  HttpClientRequest Function(HttpClientRequest request) _addHeadersPost(
          Map<String, dynamic> data) =>
      (HttpClientRequest request) {
        _addHeaders(request);
        request.headers.add('Content-Type', 'application/json');
        request.add(utf8.encode(json.encode(data)));

        return request;
      };

  Future<Map<String, dynamic>> _get(String endpoint) =>
      request<Map<String, dynamic>>('get', _getEndpoint(endpoint), _addHeaders);

  Future<Map<String, dynamic>> _post(
          String endpoint, Map<String, dynamic> data) =>
      request<Map<String, dynamic>>(
          'post', _getEndpoint(endpoint), _addHeadersPost(data));

  Future<Map<String, dynamic>> fetchUser(int id) => _get('/users/$id');
  Future<Map<String, dynamic>> fetchMessage(int channelId, int messageId) =>
      _get('/channels/$channelId/messages/$messageId');
  Future<Map<String, dynamic>> postMessage(int channelId, String content) =>
      _post('/channels/$channelId/messages', {'content': content});
}
