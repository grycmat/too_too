import 'status.dart';

class Notification {
  final String id;
  final String type;
  final DateTime createdAt;
  final Account account;
  final Status? status;
  final String? groupKey;

  const Notification({
    required this.id,
    required this.type,
    required this.createdAt,
    required this.account,
    this.status,
    this.groupKey,
  });

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      id: json['id'] as String,
      type: json['type'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      account: Account.fromJson(json['account'] as Map<String, dynamic>),
      status: json['status'] == null
          ? null
          : Status.fromJson(json['status'] as Map<String, dynamic>),
      groupKey: json['group_key'] as String?,
    );
  }
}
