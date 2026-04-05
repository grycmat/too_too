class Status {
  final String id;
  final String uri;
  final String? url;
  final DateTime createdAt;
  final String content;
  final String visibility;
  final bool sensitive;
  final String spoilerText;
  final String? inReplyToId;
  final Account account;
  final List<MediaAttachment> mediaAttachments;
  final int repliesCount;
  final int reblogsCount;
  final int favouritesCount;
  final bool? favourited;
  final bool? reblogged;
  final bool? bookmarked;
  final Status? reblog;

  const Status({
    required this.id,
    required this.uri,
    required this.url,
    required this.createdAt,
    required this.content,
    required this.visibility,
    required this.sensitive,
    required this.spoilerText,
    required this.inReplyToId,
    required this.account,
    required this.mediaAttachments,
    required this.repliesCount,
    required this.reblogsCount,
    required this.favouritesCount,
    required this.favourited,
    required this.reblogged,
    required this.bookmarked,
    required this.reblog,
  });

  factory Status.fromJson(Map<String, dynamic> json) {
    return Status(
      id: json['id'] as String,
      uri: json['uri'] as String,
      url: json['url'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      content: json['content'] as String? ?? '',
      visibility: json['visibility'] as String? ?? 'public',
      sensitive: json['sensitive'] as bool? ?? false,
      spoilerText: json['spoiler_text'] as String? ?? '',
      inReplyToId: json['in_reply_to_id'] as String?,
      account: Account.fromJson(json['account'] as Map<String, dynamic>),
      mediaAttachments:
          ((json['media_attachments'] as List<dynamic>?) ?? const [])
              .map((m) => MediaAttachment.fromJson(m as Map<String, dynamic>))
              .toList(),
      repliesCount: json['replies_count'] as int? ?? 0,
      reblogsCount: json['reblogs_count'] as int? ?? 0,
      favouritesCount: json['favourites_count'] as int? ?? 0,
      favourited: json['favourited'] as bool?,
      reblogged: json['reblogged'] as bool?,
      bookmarked: json['bookmarked'] as bool?,
      reblog: json['reblog'] == null
          ? null
          : Status.fromJson(json['reblog'] as Map<String, dynamic>),
    );
  }
}

class Account {
  final String id;
  final String username;
  final String acct;
  final String displayName;
  final String avatar;
  final String avatarStatic;
  final String url;

  const Account({
    required this.id,
    required this.username,
    required this.acct,
    required this.displayName,
    required this.avatar,
    required this.avatarStatic,
    required this.url,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['id'] as String,
      username: json['username'] as String? ?? '',
      acct: json['acct'] as String? ?? '',
      displayName: json['display_name'] as String? ?? '',
      avatar: json['avatar'] as String? ?? '',
      avatarStatic: json['avatar_static'] as String? ?? '',
      url: json['url'] as String? ?? '',
    );
  }
}

class MediaAttachment {
  final String id;
  final String type;
  final String url;
  final String previewUrl;
  final String? description;

  const MediaAttachment({
    required this.id,
    required this.type,
    required this.url,
    required this.previewUrl,
    required this.description,
  });

  factory MediaAttachment.fromJson(Map<String, dynamic> json) {
    return MediaAttachment(
      id: json['id'] as String,
      type: json['type'] as String? ?? 'unknown',
      url: json['url'] as String? ?? '',
      previewUrl: json['preview_url'] as String? ?? '',
      description: json['description'] as String?,
    );
  }
}
