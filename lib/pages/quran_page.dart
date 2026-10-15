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
    {'id': 6, 'name': 'الأنعام', 'english': 'Al-An\'am', 'ayahs': 165, 'type': 'مكية', 'page': 128},
    {'id': 7, 'name': 'الأعراف', 'english': 'Al-A\'raf', 'ayahs': 206, 'type': 'مكية', 'page': 151},
    {'id': 8, 'name': 'الأنفال', 'english': 'Al-Anfal', 'ayahs': 75, 'type': 'مدنية', 'page': 177},
    {'id': 9, 'name': 'التوبة', 'english': 'At-Tawbah', 'ayahs': 129, 'type': 'مدنية', 'page': 187},
    {'id': 10, 'name': 'يونس', 'english': 'Yunus', 'ayahs': 109, 'type': 'مكية', 'page': 208},
    {'id': 11, 'name': 'هود', 'english': 'Hud', 'ayahs': 123, 'type': 'مكية', 'page': 221},
    {'id': 12, 'name': 'يوسف', 'english': 'Yusuf', 'ayahs': 111, 'type': 'مكية', 'page': 235},
    {'id': 13, 'name': 'الرعد', 'english': 'Ar-Ra\'d', 'ayahs': 43, 'type': 'مدنية', 'page': 249},
    {'id': 14, 'name': 'إبراهيم', 'english': 'Ibrahim', 'ayahs': 52, 'type': 'مكية', 'page': 255},
    {'id': 15, 'name': 'الحجر', 'english': 'Al-Hijr', 'ayahs': 99, 'type': 'مكية', 'page': 262},
    {'id': 16, 'name': 'النحل', 'english': 'An-Nahl', 'ayahs': 128, 'type': 'مكية', 'page': 267},
    {'id': 17, 'name': 'الإسراء', 'english': 'Al-Isra', 'ayahs': 111, 'type': 'مكية', 'page': 282},
    {'id': 18, 'name': 'الكهف', 'english': 'Al-Kahf', 'ayahs': 110, 'type': 'مكية', 'page': 293},
    {'id': 19, 'name': 'مريم', 'english': 'Maryam', 'ayahs': 98, 'type': 'مكية', 'page': 305},
    {'id': 20, 'name': 'طه', 'english': 'Taha', 'ayahs': 135, 'type': 'مكية', 'page': 312},
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
                separatorBuilder: (_, __) => Container(
                  height: 0.5,
                  margin: const EdgeInsets.only(right: 64),
                  color: CupertinoColors.separator,
                ),
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
