import 'package:too_too/features/dashboard/models/status.dart';
import 'package:too_too/features/dashboard/models/notification.dart';
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
        if (maxId != null) 'max_id': maxId,
        if (sinceId != null) 'since_id': sinceId,
        if (minId != null) 'min_id': minId,
        'limit': limit,
      },
    );

    return (response.data ?? const [])
        .map((j) => Status.fromJson(j as Map<String, dynamic>))
        .toList();
  }

  Future<List<Status>> getPublicTimeline({
    String? maxId,
    String? sinceId,
    String? minId,
    int limit = 20,
    bool local = false,
  }) async {
    final response = await _http.get<List<dynamic>>(
      '/api/v1/timelines/public',
      queryParameters: {
        if (maxId != null) 'max_id': maxId,
        if (sinceId != null) 'since_id': sinceId,
        if (minId != null) 'min_id': minId,
        'limit': limit,
        'local': local,
      },
    );

    return (response.data ?? const [])
        .map((j) => Status.fromJson(j as Map<String, dynamic>))
        .toList();
  }

  Future<List<Notification>> getAllNotifications({
    String? maxId,
    String? sinceId,
    String? minId,
    int limit = 20,
  }) async {
    final response = await _http.get<List<dynamic>>(
      '/api/v1/notifications',
      queryParameters: {
        if (maxId != null) 'max_id': maxId,
        if (sinceId != null) 'since_id': sinceId,
        if (minId != null) 'min_id': minId,
        'limit': limit,
      },
    );

    return (response.data ?? const [])
        .map((j) => Notification.fromJson(j as Map<String, dynamic>))
        .toList();
  }

  Future<List<Status>> getAccountStatuses(
    String accountId, {
    String? maxId,
    String? sinceId,
    String? minId,
    int limit = 20,
  }) async {
    final response = await _http.get<List<dynamic>>(
      '/api/v1/accounts/$accountId/statuses',
      queryParameters: {
        if (maxId != null) 'max_id': maxId,
        if (sinceId != null) 'since_id': sinceId,
        if (minId != null) 'min_id': minId,
        'limit': limit,
      },
    );

    return (response.data ?? const [])
        .map((j) => Status.fromJson(j as Map<String, dynamic>))
        .toList();
  }
}
