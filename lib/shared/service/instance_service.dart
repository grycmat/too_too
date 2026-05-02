import 'package:neon/shared/service/app_http_service.dart';
import 'package:neon/shared/model/instance.dart';

class InstanceService {
  final AppHttpService _httpService;
  Instance? _currentInstance;

  InstanceService({required AppHttpService httpService}) : _httpService = httpService;

  Instance? get currentInstance => _currentInstance;

  Future<void> fetchInstanceData() async {
    try {
      final response = await _httpService.get('/api/v2/instance');
      _currentInstance = Instance.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      // Handle error gracefully
      print('Error fetching instance data: $e');
    }
  }
}
