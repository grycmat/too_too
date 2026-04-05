import 'package:too_too/features/dashboard/models/status.dart';
import 'app_http_service.dart';

class TootsApiService {
  final AppHttpService _http;

  TootsApiService({required AppHttpService httpService}) : _http = httpService;

  Future<List<Status>> getUserTimeline({
    String? maxId,
    String? sinceId,
    String? minId,
    int limit = 20,
  }) async {
    final response = await _http.get<List<dynamic>>(
      '/api/v1/timelines/home',
      queryParameters: {
        'max_id': ?maxId,
        'since_id': ?sinceId,
        'min_id': ?minId,
        'limit': limit,
      },
    );

    return (response.data ?? const [])
        .map((j) => Status.fromJson(j as Map<String, dynamic>))
        .toList();
  }
}
