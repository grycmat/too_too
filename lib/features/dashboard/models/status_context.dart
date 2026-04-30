import 'status.dart';

class StatusContext {
  final List<Status> ancestors;
  final List<Status> descendants;

  const StatusContext({required this.ancestors, required this.descendants});

  factory StatusContext.fromJson(Map<String, dynamic> json) {
    return StatusContext(
      ancestors: ((json['ancestors'] as List<dynamic>?) ?? const [])
          .map((s) => Status.fromJson(s as Map<String, dynamic>))
          .toList(),
      descendants: ((json['descendants'] as List<dynamic>?) ?? const [])
          .map((s) => Status.fromJson(s as Map<String, dynamic>))
          .toList(),
    );
  }
}
