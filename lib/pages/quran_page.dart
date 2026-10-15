import 'package:flutter/cupertino.dart';
import '../theme.dart';
import 'reader_page.dart';

class QuranPage extends StatefulWidget {
  const QuranPage({super.key});

  @override
  State<QuranPage> createState() => _QuranPageState();
}

class _QuranPageState extends State<QuranPage> {
  int _selectedSegment = 0; // 0: السور، 1: الأجزاء، 2: الأحزاب
  String _searchQuery = '';

  final List<Map<String, dynamic>> _surahs = const [
    {'id': 1, 'name': 'الفاتحة', 'english': 'Al-Fatihah', 'ayahs': 7, 'type': 'مكية', 'page': 1},
    {'id': 2, 'name': 'البقرة', 'english': 'Al-Baqarah', 'ayahs': 286, 'type': 'مدنية', 'page': 2},
    {'id': 3, 'name': 'آل عمران', 'english': 'Ali \'Imran', 'ayahs': 200, 'type': 'مدنية', 'page': 50},
    {'id': 4, 'name': 'النساء', 'english': 'An-Nisa', 'ayahs': 176, 'type': 'مدنية', 'page': 77},
    {'id': 5, 'name': 'المائدة', 'english': 'Al-Ma\'idah', 'ayahs': 120, 'type': 'مدنية', 'page': 106},
  ];

  @override
  Widget build(BuildContext context) {
    final filteredSurahs = _surahs.where((s) {
      return s['name'].toString().contains(_searchQuery) ||
             s['id'].toString() == _searchQuery;
    }).toList();

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('المصحف الشريف'),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: CupertinoSearchTextField(
                placeholder: 'ابحث عن سورة أو رقم...',
                onChanged: (val) => setState(() => _searchQuery = val),
              ),
            ),
            CupertinoSlidingSegmentedControl<int>(
              groupValue: _selectedSegment,
              children: const {
                0: Padding(padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6), child: Text('السور')),
                1: Padding(padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6), child: Text('الأجزاء')),
                2: Padding(padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6), child: Text('الأحزاب')),
              },
              onValueChanged: (val) {
                if (val != null) setState(() => _selectedSegment = val);
              },
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.separated(
                itemCount: filteredSurahs.length,
                separatorBuilder: (_, __) => const Divider(height: 1, indent: 64),
                itemBuilder: (context, index) {
                  final surah = filteredSurahs[index];
                  return CupertinoListTile(
                    leading: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: AppTheme.activeGreen.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${surah['id']}',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.activeGreen),
                      ),
                    ),
                    title: Text(
                      'سورة ${surah['name']}',
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                    ),
                    subtitle: Text(
                      '${surah['type']} • ${surah['ayahs']} آية • صفحة ${surah['page']}',
                      style: const TextStyle(fontSize: 12, color: CupertinoColors.secondaryLabel),
                    ),
                    trailing: const CupertinoListTileChevron(),
                    onTap: () {
                      Navigator.of(context, rootNavigator: true).push(
                        CupertinoPageRoute(
                          builder: (_) => ReaderPage(
                            surahId: surah['id'],
                            initialAyah: 1,
                          ),
                        ),
                      );
                    },
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
