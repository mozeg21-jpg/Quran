import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import '../theme.dart';

class AdhkarPage extends StatefulWidget {
  const AdhkarPage({super.key});

  @override
  State<AdhkarPage> createState() => _AdhkarPageState();
}

class _AdhkarPageState extends State<AdhkarPage> {
  int _selectedCategoryIndex = 0;

  final Map<String, List<Map<String, dynamic>>> _adhkarData = {
    'الصباح': [
      {'text': 'أَصْبَحْنَا وَأَصْبَحَ الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ لاَ إِلَهَ إِلاَّ اللَّهُ وَحْدَهُ لاَ شَرِيكَ لَهُ.', 'count': 1, 'current': 0},
      {'text': 'اللَّهُمَّ بِكَ أَصْبَحْنَا، وَبِكَ أَمْسَيْنَا، وَبِكَ نَحْيَا، وَبِكَ نَمُوتُ وَإِلَيْكَ النُّشُورُ.', 'count': 1, 'current': 0},
      {'text': 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ: عَدَدَ خَلْقِهِ، وَرِضَا نَفْسِهِ، وَزِنَةَ عَرْشِهِ، وَمِدَادَ كَلِمَاتِهِ.', 'count': 3, 'current': 0},
    ],
    'المساء': [
      {'text': 'أَمْسَيْنَا وَأَمْسَى الْمُلْكُ لِلَّهِ وَالْحَمْدُ لِلَّهِ، لاَ إِلَهَ إِلاَّ اللَّهُ وَحْدَهُ لاَ شَرِيكَ لَهُ.', 'count': 1, 'current': 0},
      {'text': 'اللَّهُمَّ بِكَ أَمْسَيْنَا، وَبِكَ أَصْبَحْنَا، وَبِكَ نَحْيَا، وَبِكَ نَمُوتُ وَإِلَيْكَ الْمَصِيرُ.', 'count': 1, 'current': 0},
      {'text': 'أَعُوذُ بِكَلِمَاتِ اللَّهِ التَّامَّاتِ مِنْ شَرِّ مَا خَلَقَ.', 'count': 3, 'current': 0},
    ],
    'قبل النوم': [
      {'text': 'بِاسْمِكَ رَبِّي وَضَعْتُ جَنْبِي، وَبِكَ أَرْفَعُهُ.', 'count': 1, 'current': 0},
      {'text': 'اللَّهُمَّ قِنِي عَذَابَكَ يَوْمَ تَبْعَثُ عِبَادَكَ.', 'count': 3, 'current': 0},
    ],
  };

  @override
  Widget build(BuildContext context) {
    final categories = _adhkarData.keys.toList();
    final activeKey = categories[_selectedCategoryIndex];
    final currentList = _adhkarData[activeKey]!;

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('حصن المسلم والأذكار'),
      ),
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),
            // التحكم المبوب iOS Segmented Control
            CupertinoSlidingSegmentedControl<int>(
              groupValue: _selectedCategoryIndex,
              children: {
                for (int i = 0; i < categories.length; i++)
                  i: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    child: Text(categories[i]),
                  ),
              },
              onValueChanged: (val) {
                if (val != null) setState(() => _selectedCategoryIndex = val);
              },
            ),
            const SizedBox(height: 12),

            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: currentList.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final item = currentList[index];
                  final isDone = item['current'] >= item['count'];

                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context),
                      borderRadius: BorderRadius.circular(14),
                      border: isDone ? Border.all(color: CupertinoColors.activeGreen, width: 1.5) : null,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          item['text'],
                          style: const TextStyle(fontSize: 16, height: 1.8, fontFamily: 'Amiri'),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'التكرار: ${item['current']} / ${item['count']}',
                              style: const TextStyle(fontSize: 13, color: CupertinoColors.secondaryLabel),
                            ),
                            CupertinoButton.filled(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                              borderRadius: BorderRadius.circular(16),
                              onPressed: isDone
                                  ? null
                                  : () {
                                      HapticFeedback.lightImpact();
                                      setState(() {
                                        item['current']++;
                                      });
                                    },
                              child: Text(isDone ? 'تم' : 'تسبيح', style: const TextStyle(fontSize: 13)),
                            ),
                          ],
                        ),
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
