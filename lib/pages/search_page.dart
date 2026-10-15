import 'package:flutter/cupertino.dart';
import '../theme.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String _filter = 'الكل';
  final TextEditingController _controller = TextEditingController();

  final List<Map<String, String>> _results = [
    {
      'surah': 'البقرة',
      'ayah': '255',
      'text': 'اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ ۚ لَا تَأْخُذُهُ سِنَةٌ وَلَا نَوْمٌ'
    },
    {
      'surah': 'طه',
      'ayah': '114',
      'text': 'فَتَعَالَى اللَّهُ الْمَلِكُ الْحَقُّ ۗ وَلَا تَعْجَلْ بِالْقُرْآنِ مِن قَبْلِ أَن يُقْضَىٰ إِلَيْكَ وَحْيُهُ ۖ وَقُل رَّبِّ زِدْنِي عِلْمًا'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('البحث المتقدم'),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CupertinoSearchTextField(
                controller: _controller,
                placeholder: 'ابحث عن آية، كلمة، أو مفردة قرآنية...',
              ),
            ),
            // كبسولات فلترة نتائج البحث
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: ['الكل', 'آيات', 'سور', 'أجزاء'].map((cat) {
                  final isSelected = _filter == cat;
                  return Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: CupertinoButton(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      color: isSelected ? AppTheme.activeGreen : CupertinoColors.systemGrey5,
                      borderRadius: BorderRadius.circular(20),
                      onPressed: () => setState(() => _filter = cat),
                      child: Text(
                        cat,
                        style: TextStyle(
                          color: isSelected ? CupertinoColors.white : CupertinoColors.label,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: _results.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final item = _results[index];
                  return Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'سورة ${item['surah']} • آية ${item['ayah']}',
                              style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.activeGreen, fontSize: 13),
                            ),
                            const Icon(CupertinoIcons.bookmark, size: 18, color: CupertinoColors.secondaryLabel),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '﴿ ${item['text']} ﴾',
                          style: const TextStyle(fontSize: 15, height: 1.6, fontFamily: 'Amiri'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
