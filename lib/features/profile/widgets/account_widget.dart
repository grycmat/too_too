import 'package:flutter/material.dart';
import 'package:neon/core/theme/colors.dart';
import 'package:neon/features/dashboard/models/status.dart';
import 'package:neon/features/dashboard/widgets/toots_list_widget.dart';
import 'profile_header_widget.dart';

class AccountWidget extends StatelessWidget {
  final Account account;

  const AccountWidget({
    super.key,
    required this.account,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverToBoxAdapter(
              child: ProfileHeaderWidget(account: account),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverAppBarDelegate(
                const TabBar(
                  indicatorColor: AppColors.primary,
                  labelColor: AppColors.primary,
                  unselectedLabelColor: AppColors.textHint,
                  tabs: [
                    Tab(text: 'TOOTS'),
                    Tab(text: 'MEDIA'),
                    Tab(text: 'LIKES'),
                  ],
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          children: [
            TootsListWidget(timelineType: TimelineType.account, accountId: account.id), // Pass user ID to fetch just their toots
            const Center(child: Text('MEDIA - Coming Soon', style: TextStyle(color: AppColors.textHint))),
            const Center(child: Text('LIKES - Coming Soon', style: TextStyle(color: AppColors.textHint))),
          ],
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: AppColors.background,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
