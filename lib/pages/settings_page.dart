import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../services/storage_service.dart';
import '../theme.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final storage = Provider.of<StorageService>(context);

    return CupertinoPageScaffold(
      child: CustomScrollView(
        slivers: [
          const CupertinoSliverNavigationBar(
            largeTitle: Text('الإعدادات'),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                CupertinoListSection.insetGrouped(
                  header: const Text('المظهر والخط'),
                  children: [
                    CupertinoListTile(
                      leading: const Icon(CupertinoIcons.moon_fill, color: AppTheme.activeGreen),
                      title: const Text('الوضع الداكن'),
                      trailing: CupertinoSwitch(
                        value: storage.isDarkMode,
                        onChanged: (val) => storage.toggleDarkMode(val),
                      ),
                    ),
                    CupertinoListTile(
                      leading: const Icon(CupertinoIcons.textformat_size, color: AppTheme.activeGreen),
                      title: const Text('حجم الخط الافتراضي'),
                      trailing: const CupertinoListTileChevron(),
                      onTap: () {},
                    ),
                  ],
                ),
                CupertinoListSection.insetGrouped(
                  header: const Text('مواقيت الصلاة والتنبيهات'),
                  children: [
                    CupertinoListTile(
                      leading: const Icon(CupertinoIcons.bell_fill, color: AppTheme.accentGold),
                      title: const Text('تنبيهات الأذان'),
                      trailing: CupertinoSwitch(
                        value: true,
                        onChanged: (val) {},
                      ),
                    ),
                    CupertinoListTile(
                      leading: const Icon(CupertinoIcons.compass, color: AppTheme.activeGreen),
                      title: const Text('طريقة الحساب الفلكي'),
                      additionalInfo: const Text('الهيئة المصرية العامة'),
                      trailing: const CupertinoListTileChevron(),
                      onTap: () {},
                    ),
                  ],
                ),
                CupertinoListSection.insetGrouped(
                  header: const Text('عن التطبيق'),
                  children: const [
                    CupertinoListTile(
                      leading: Icon(CupertinoIcons.info_circle_fill, color: CupertinoColors.systemGrey),
                      title: Text('إصدار التطبيق'),
                      additionalInfo: Text('2.0.0 (iOS Edition)'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
