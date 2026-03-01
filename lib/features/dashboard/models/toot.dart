class Toot {
  final String id;
  final String authorName;
  final String authorHandle;
  final String? authorAvatarUrl;
  final String content;
  final String? imageUrl;
  final String timestamp;
  final int replies;
  final int retoots;
  final int stars;

  const Toot({
    required this.id,
    required this.authorName,
    required this.authorHandle,
    this.authorAvatarUrl,
    required this.content,
    this.imageUrl,
    required this.timestamp,
    this.replies = 0,
    this.retoots = 0,
    this.stars = 0,
  });

  static List<Toot> mockToots() => const [
    Toot(
      id: '1',
      authorName: 'Alex',
      authorHandle: '@alex_tech',
      content: 'Just synced my home devices. The future is now! #HomeSync #IoT',
      timestamp: '2m',
      replies: 3,
      retoots: 5,
      stars: 12,
    ),
    Toot(
      id: '2',
      authorName: 'Sarah Designs',
      authorHandle: '@sarah_designs',
      content: 'Working on the new dashboard UI. Love this #neon vibe.',
      imageUrl: 'https://picsum.photos/seed/neon/600/300',
      timestamp: '15m',
      replies: 7,
      retoots: 14,
      stars: 42,
    ),
    Toot(
      id: '3',
      authorName: 'Dev Dude',
      authorHandle: '@dev_dude',
      content: 'Server update complete. Everything running smoothly. #SysAdmin',
      timestamp: '1h',
      replies: 1,
      retoots: 2,
      stars: 8,
    ),
    Toot(
      id: '4',
      authorName: 'Pixel Queen',
      authorHandle: '@pixel_queen',
      content:
          'New icon pack dropping tomorrow! Stay tuned 🎨 #Design #IconPack',
      timestamp: '2h',
      replies: 22,
      retoots: 48,
      stars: 130,
    ),
    Toot(
      id: '5',
      authorName: 'NetRunner',
      authorHandle: '@net_runner',
      content:
          'Exploring the decentralized web. Mastodon is the future! #Fediverse #OpenSource',
      timestamp: '3h',
      replies: 15,
      retoots: 33,
      stars: 97,
    ),
  ];
}
