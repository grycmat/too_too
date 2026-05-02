class Instance {
  final String domain;
  final String title;
  final String version;
  final String? sourceUrl;
  final String description;
  final List<String> languages;
  final InstanceConfiguration? configuration;
  final InstanceRegistrations? registrations;
  final InstanceContact? contact;

  const Instance({
    required this.domain,
    required this.title,
    required this.version,
    this.sourceUrl,
    required this.description,
    required this.languages,
    this.configuration,
    this.registrations,
    this.contact,
  });

  factory Instance.fromJson(Map<String, dynamic> json) {
    return Instance(
      domain: json['domain'] as String? ?? '',
      title: json['title'] as String? ?? '',
      version: json['version'] as String? ?? '',
      sourceUrl: json['source_url'] as String?,
      description: json['description'] as String? ?? '',
      languages: (json['languages'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      configuration: json['configuration'] != null ? InstanceConfiguration.fromJson(json['configuration'] as Map<String, dynamic>) : null,
      registrations: json['registrations'] != null ? InstanceRegistrations.fromJson(json['registrations'] as Map<String, dynamic>) : null,
      contact: json['contact'] != null ? InstanceContact.fromJson(json['contact'] as Map<String, dynamic>) : null,
    );
  }
}

class InstanceConfiguration {
  final InstanceStatusesConfiguration? statuses;

  const InstanceConfiguration({this.statuses});

  factory InstanceConfiguration.fromJson(Map<String, dynamic> json) {
    return InstanceConfiguration(
      statuses: json['statuses'] != null ? InstanceStatusesConfiguration.fromJson(json['statuses'] as Map<String, dynamic>) : null,
    );
  }
}

class InstanceStatusesConfiguration {
  final int maxCharacters;
  final int maxMediaAttachments;
  final int charactersReservedPerUrl;

  const InstanceStatusesConfiguration({
    required this.maxCharacters,
    required this.maxMediaAttachments,
    required this.charactersReservedPerUrl,
  });

  factory InstanceStatusesConfiguration.fromJson(Map<String, dynamic> json) {
    return InstanceStatusesConfiguration(
      maxCharacters: json['max_characters'] as int? ?? 500,
      maxMediaAttachments: json['max_media_attachments'] as int? ?? 4,
      charactersReservedPerUrl: json['characters_reserved_per_url'] as int? ?? 23,
    );
  }
}

class InstanceRegistrations {
  final bool enabled;
  final bool approvalRequired;
  final String? message;

  const InstanceRegistrations({
    required this.enabled,
    required this.approvalRequired,
    this.message,
  });

  factory InstanceRegistrations.fromJson(Map<String, dynamic> json) {
    return InstanceRegistrations(
      enabled: json['enabled'] as bool? ?? false,
      approvalRequired: json['approval_required'] as bool? ?? false,
      message: json['message'] as String?,
    );
  }
}

class InstanceContact {
  final String email;

  const InstanceContact({required this.email});

  factory InstanceContact.fromJson(Map<String, dynamic> json) {
    return InstanceContact(
      email: json['email'] as String? ?? '',
    );
  }
}
