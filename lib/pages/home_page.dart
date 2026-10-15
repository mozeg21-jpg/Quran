import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show LinearProgressIndicator;
import 'package:provider/provider.dart';
import '../theme.dart';
import '../services/storage_service.dart';
import 'reader_page.dart';
import 'prayer_times_page.dart';
import 'compass_page.dart';
import 'tasbih_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final storage = Provider.of<StorageService>(context);

    return CupertinoPageScaffold(
      child: CustomScrollView(
        slivers: [
          const CupertinoSliverNavigationBar(
            largeTitle: Text('الرئيسية'),
            border: null,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  // بطاقة الترحيب والتاريخ
                  _buildHeaderCard(),
                  const SizedBox(height: 16),
                  
                  // بطاقة متابعة القراءة السريعة
                  _buildResumeReadingCard(context, storage),
                  const SizedBox(height: 16),
                  
                  // شبكة الوصول السريع (مواقيت، قبلة، تسبيح، أذكار)
                  _buildQuickAccessGrid(context),
                  const SizedBox(height: 16),

                  // بطاقة الورد اليومي والإنجاز
                  _buildDailyTargetCard(storage),
                  const SizedBox(height: 16),

                  // آية اليوم
                  _buildDailyAyahCard(context),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.primaryGreen,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'السلام عليكم ورحمة الله',
                style: TextStyle(color: CupertinoColors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text(
                'الخميس، 15 ربيع الآخر 1448 هـ',
                style: TextStyle(color: CupertinoColors.systemGrey4, fontSize: 13),
              ),
            ],
          ),
          Icon(CupertinoIcons.moon_stars_fill, color: AppTheme.accentGold, size: 28),
        ],
      ),
    );
  }

  Widget _buildResumeReadingCard(BuildContext context, StorageService storage) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 75,
            decoration: BoxDecoration(
              color: AppTheme.activeGreen,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(CupertinoIcons.book_fill, color: AppTheme.accentGold, size: 32),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('تابع قراءتك', style: TextStyle(fontSize: 13, color: CupertinoColors.secondaryLabel)),
                const SizedBox(height: 4),
                Text(
                  storage.lastSurahName.isNotEmpty ? storage.lastSurahName : 'سورة البقرة',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  'الآية ${storage.lastAyahNumber} • صفحة ${storage.lastPageNumber}',
                  style: const TextStyle(fontSize: 13, color: CupertinoColors.secondaryLabel),
                ),
              ],
            ),
          ),
          CupertinoButton.filled(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            borderRadius: BorderRadius.circular(20),
            onPressed: () {
              Navigator.of(context, rootNavigator: true).push(
                CupertinoPageRoute(
                  builder: (_) => ReaderPage(
                    surahId: storage.lastSurahId,
                    initialAyah: storage.lastAyahNumber,
                  ),
                ),
              );
            },
            child: const Text('متابعة', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAccessGrid(BuildContext context) {
    final actions = [
      {'title': 'مواقيت الصلاة', 'icon': CupertinoIcons.time, 'page': const PrayerTimesPage()},
      {'title': 'اتجاه القبلة', 'icon': CupertinoIcons.compass, 'page': const CompassPage()},
      {'title': 'السبحة', 'icon': CupertinoIcons.circle_grid_hex, 'page': const TasbihPage()},
      {'title': 'المحفوظات', 'icon': CupertinoIcons.bookmark, 'page': null},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: actions.map((item) {
        return CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            if (item['page'] != null) {
              Navigator.of(context, rootNavigator: true).push(
                CupertinoPageRoute(builder: (_) => item['page'] as Widget),
              );
            }
          },
          child: Column(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: AppTheme.activeGreen.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(item['icon'] as IconData, color: AppTheme.activeGreen, size: 26),
              ),
              const SizedBox(height: 6),
              Text(
                item['title'] as String,
                style: const TextStyle(fontSize: 12, color: CupertinoColors.label),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDailyTargetCard(StorageService storage) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CupertinoColors.secondarySystemGroupedBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('الورد اليومي', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text('5 / 10 صفحات', style: TextStyle(color: AppTheme.activeGreen, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: const LinearProgressIndicator(
              value: 0.5,
              backgroundColor: CupertinoColors.systemGrey5,
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.activeGreen),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyAyahCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.accentGold.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          const Text('آية اليوم', style: TextStyle(color: AppTheme.accentGold, fontSize: 13, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          const Text(
            '﴿ رَبِّ زِدْنِي عِلْمًا ﴾',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, fontFamily: 'Amiri'),
          ),
          const SizedBox(height: 8),
          const Text('سورة طه • الآية 114', style: TextStyle(fontSize: 12, color: CupertinoColors.secondaryLabel)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CupertinoButton(
                padding: const EdgeInsets.all(8),
                onPressed: () {},
                child: const Icon(CupertinoIcons.play_circle, color: AppTheme.activeGreen, size: 26),
              ),
              CupertinoButton(
                padding: const EdgeInsets.all(8),
                onPressed: () {},
                child: const Icon(CupertinoIcons.share, color: CupertinoColors.secondaryLabel, size: 24),
              ),
            ],
          )
        ],
      ),
    );
  }
}
