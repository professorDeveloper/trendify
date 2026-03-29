import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../data/notificaiton_model.dart';
import '../data/notification_data.dart';
import '../widgets/notification_group_header.dart';
import '../widgets/notification_item.dart';
import '../widgets/notification_tab_bar.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  int _selectedTab = 0;

  List<NotificationModel> get _currentList =>
      _selectedTab == 0 ? generalNotifications : promotionNotifications;

  Map<String, List<NotificationModel>> get _grouped {
    final map = <String, List<NotificationModel>>{};
    for (final n in _currentList) {
      map.putIfAbsent(n.group, () => []).add(n);
    }
    return map;
  }

  int _countItems(
    List<String> groups,
    Map<String, List<NotificationModel>> grouped,
  ) {
    int count = 0;
    for (final g in groups) {
      count += 1 + (grouped[g]?.length ?? 0);
    }
    return count;
  }

  Widget _buildListItem(
    int index,
    List<String> groups,
    Map<String, List<NotificationModel>> grouped,
    bool isDark,
  ) {
    int cursor = 0;
    for (final group in groups) {
      if (index == cursor) {
        return NotificationGroupHeader(title: group);
      }
      cursor++;
      final items = grouped[group]!;
      if (index < cursor + items.length) {
        final item = items[index - cursor];
        final isLast = (index - cursor) == items.length - 1;
        return Column(
          children: [
            NotificationItem(
              notification: item,
              onTap: () {
                // navigate to detail
              },
            ),
            if (!isLast)
              Divider(
                height: 1,
                thickness: 1,
                indent: 74,
                endIndent: 16,
                color: isDark ? AppColors.dark4 : AppColors.grey200,
              ),
          ],
        );
      }
      cursor += items.length;
    }
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final grouped = _grouped;
    final groups = grouped.keys.toList();

    return Scaffold(
      backgroundColor: isDark ? AppColors.dark1 : AppColors.white,
      appBar: _buildAppBar(isDark),
      body: Column(
        children: [
          NotificationTabBar(
            selectedIndex: _selectedTab,
            onTabChanged: (i) => setState(() => _selectedTab = i),
          ),
          Expanded(
            child: _currentList.isEmpty
                ? _buildEmpty(isDark)
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: _countItems(groups, grouped),
                    itemBuilder: (context, index) =>
                        _buildListItem(index, groups, grouped, isDark),
                  ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(bool isDark) {
    return AppBar(
      backgroundColor: isDark ? AppColors.dark2 : AppColors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: GestureDetector(
        onTap: () => Navigator.maybePop(context),
        child: Icon(
          Icons.arrow_back_rounded,
          color: isDark ? AppColors.white : AppColors.grey900,
        ),
      ),
      title: Text(
        'Notification',
        style: GoogleFonts.urbanist(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: isDark ? AppColors.white : AppColors.grey900,
        ),
      ),
      centerTitle: true,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: GestureDetector(
            onTap: () {
              // Settings
            },
            child: Icon(
              Icons.settings_outlined,
              color: isDark ? AppColors.white : AppColors.grey900,
            ),
          ),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Divider(
          height: 1,
          thickness: 1,
          color: isDark ? AppColors.dark4 : AppColors.grey200,
        ),
      ),
    );
  }

  Widget _buildEmpty(bool isDark) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: isDark ? AppColors.dark3 : AppColors.bgPrimary,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text('🔔', style: TextStyle(fontSize: 36)),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No Notifications',
            style: GoogleFonts.urbanist(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.white : AppColors.grey900,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "You're all caught up!",
            style: GoogleFonts.urbanist(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.grey500,
            ),
          ),
        ],
      ),
    );
  }
}
