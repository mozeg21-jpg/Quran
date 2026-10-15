import 'package:flutter/cupertino.dart';
import '../theme.dart';

class SavedPage extends StatefulWidget {
  const SavedPage({super.key});

  @override
  State<SavedPage> createState() => _SavedPageState();
}

class _SavedPageState extends State<SavedPage> {
  int _selectedTab = 0; // 0: المحفوظات، 1: المجموعات

  final List<Map<String, dynamic>> _savedBookmarks = [
    {'surah': 'البقرة', 'ayah': 255, 'note': 'آية الكرسي - ورد الصباح'},
    {'surah': 'آل عمران', 'ayah': 102, 'note': 'موضع الحفظ والمراجعة'},
    {'surah': 'الكهف', 'ayah': 1, 'note': 'قراءة يوم الجمعة'},
  ];

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('المحفوظات والعلامات'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.add),
          onPressed: () {},
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),
            CupertinoSlidingSegmentedControl<int>(
              groupValue: _selectedTab,
              children: const {
                0: Padding(padding: EdgeInsets.symmetric(horizontal: 24, vertical: 6), child: Text('المحفوظات')),
                1: Padding(padding: EdgeInsets.symmetric(horizontal: 24, vertical: 6), child: Text('المجموعات')),
              },
              onValueChanged: (val) {
                if (val != null) setState(() => _selectedTab = val);
              },
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: _savedBookmarks.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final bm = _savedBookmarks[index];
                  return Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(CupertinoIcons.bookmark_fill, color: AppTheme.accentGold, size: 24),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'سورة ${bm['surah']} — الآية ${bm['ayah']}',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                bm['note'],
                                style: const TextStyle(fontSize: 12, color: CupertinoColors.secondaryLabel),
                              ),
                            ],
                          ),
                        ),
                        const Icon(CupertinoIcons.chevron_back, size: 16, color: CupertinoColors.systemGrey),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
