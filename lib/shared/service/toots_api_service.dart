import 'dart:io';

import 'package:dio/dio.dart';
import 'package:neon/features/dashboard/models/status.dart';
import 'package:neon/features/dashboard/models/status_context.dart';
import 'package:neon/features/dashboard/models/notification.dart';
import 'app_http_service.dart';

const DEFAULT_LIMIT = 50;

class TootsApiService {
  final AppHttpService _http;

  TootsApiService({required AppHttpService httpService}) : _http = httpService;

  Future<List<Status>> getUserTimeline({
    String? maxId,
    String? sinceId,
    String? minId,
    int limit = DEFAULT_LIMIT,
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
    int limit = DEFAULT_LIMIT,
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
    int limit = DEFAULT_LIMIT,
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
    int limit = DEFAULT_LIMIT,
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

  Future<Status> getStatusDetails(String id) async {
    final response = await _http.get<Map<String, dynamic>>(
      '/api/v1/statuses/$id',
    );

    if (response.data == null) {
      throw Exception('Failed to load status details: response data is null');
    }

    return Status.fromJson(response.data!);
  }

  Future<StatusContext> getStatusContext(String id) async {
    final response = await _http.get<Map<String, dynamic>>(
      '/api/v1/statuses/$id/context',
    );

    if (response.data == null) {
      throw Exception('Failed to load status context: response data is null');
    }

    return StatusContext.fromJson(response.data!);
  }

  Future<String> uploadMedia(File file) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        file.path,
        filename: file.path.split(Platform.pathSeparator).last,
      ),
    });

    final response = await _http.postMultipart<Map<String, dynamic>>(
      '/api/v2/media',
      data: formData,
    );

    if (response.data == null || response.data!['id'] == null) {
      throw Exception('Failed to upload media: response data is null');
    }

    return response.data!['id'] as String;
  }

  Future<Status> postStatus({
    required String status,
    List<String>? mediaIds,
    String visibility = 'public',
    String? spoilerText,
    String? inReplyToId,
    String? quoteId,
    bool sensitive = false,
  }) async {
    final body = <String, dynamic>{
      'status': status,
      'visibility': visibility,
      if (mediaIds != null && mediaIds.isNotEmpty) 'media_ids': mediaIds,
      if (spoilerText != null && spoilerText.isNotEmpty)
        'spoiler_text': spoilerText,
      if (inReplyToId != null) 'in_reply_to_id': inReplyToId,
      if (quoteId != null) 'quoted_status_id': quoteId,
      if (sensitive) 'sensitive': true,
    };

    final response = await _http.post<Map<String, dynamic>>(
      '/api/v1/statuses',
      data: body,
    );

    if (response.data == null) {
      throw Exception('Failed to post status: response data is null');
    }

    return Status.fromJson(response.data!);
  }

  Future<Status> favouriteStatus(String id) async {
    final response = await _http.post<Map<String, dynamic>>(
      '/api/v1/statuses/$id/favourite',
    );

    if (response.data == null) {
      throw Exception('Failed to favourite status: response data is null');
    }

    return Status.fromJson(response.data!);
  }

  Future<Status> unfavouriteStatus(String id) async {
    final response = await _http.post<Map<String, dynamic>>(
      '/api/v1/statuses/$id/unfavourite',
    );

    if (response.data == null) {
      throw Exception('Failed to unfavourite status: response data is null');
    }

    return Status.fromJson(response.data!);
  }

  Future<Status> reblogStatus(String id) async {
    final response = await _http.post<Map<String, dynamic>>(
      '/api/v1/statuses/$id/reblog',
    );

    if (response.data == null) {
      throw Exception('Failed to boost status: response data is null');
    }

    return Status.fromJson(response.data!);
  }

  Future<Status> unreblogStatus(String id) async {
    final response = await _http.post<Map<String, dynamic>>(
      '/api/v1/statuses/$id/unreblog',
    );

    if (response.data == null) {
      throw Exception('Failed to unboost status: response data is null');
    }

    return Status.fromJson(response.data!);
  }
}
