class ProfileField {
  final String name;
  final String value;
  final DateTime? verifiedAt;

  const ProfileField({
    required this.name,
    required this.value,
    this.verifiedAt,
  });

  factory ProfileField.fromJson(Map<String, dynamic> json) {
    return ProfileField(
      name: json['name'] as String? ?? '',
      value: json['value'] as String? ?? '',
      verifiedAt: json['verified_at'] == null
          ? null
          : DateTime.parse(json['verified_at'] as String),
    );
  }
}

class Profile {
  final String id;
  final String displayName;
  final String note;
  final List<ProfileField> fields;
  final String? avatar;
  final String? avatarStatic;
  final String? avatarDescription;
  final String? header;
  final String? headerStatic;
  final String? headerDescription;
  final bool locked;
  final bool bot;
  final bool? hideCollections;
  final bool discoverable;
  final bool indexable;
  final bool showMedia;
  final bool showMediaReplies;
  final bool showFeatured;
  final List<String> attributionDomains;

  const Profile({
    required this.id,
    required this.displayName,
    required this.note,
    required this.fields,
    this.avatar,
    this.avatarStatic,
    this.avatarDescription,
    this.header,
    this.headerStatic,
    this.headerDescription,
    required this.locked,
    required this.bot,
    this.hideCollections,
    required this.discoverable,
    required this.indexable,
    required this.showMedia,
    required this.showMediaReplies,
    required this.showFeatured,
    required this.attributionDomains,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'] as String,
      displayName: json['display_name'] as String? ?? '',
      note: json['note'] as String? ?? '',
      fields: ((json['fields'] as List<dynamic>?) ?? const [])
          .map((f) => ProfileField.fromJson(f as Map<String, dynamic>))
          .toList(),
      avatar: json['avatar'] as String?,
      avatarStatic: json['avatar_static'] as String?,
      avatarDescription: json['avatar_description'] as String?,
      header: json['header'] as String?,
      headerStatic: json['header_static'] as String?,
      headerDescription: json['header_description'] as String?,
      locked: json['locked'] as bool? ?? false,
      bot: json['bot'] as bool? ?? false,
      hideCollections: json['hide_collections'] as bool?,
      discoverable: json['discoverable'] as bool? ?? false,
      indexable: json['indexable'] as bool? ?? false,
      showMedia: json['show_media'] as bool? ?? false,
      showMediaReplies: json['show_media_replies'] as bool? ?? false,
      showFeatured: json['show_featured'] as bool? ?? false,
      attributionDomains:
          ((json['attribution_domains'] as List<dynamic>?) ?? const [])
              .map((d) => d as String)
              .toList(),
    );
  }
}
