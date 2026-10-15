import 'package:flutter/cupertino.dart';
import '../theme.dart';

class ReaderPage extends StatefulWidget {
  final int surahId;
  final int initialAyah;

  const ReaderPage({
    super.key,
    required this.surahId,
    this.initialAyah = 1,
  });

  @override
  State<ReaderPage> createState() => _ReaderPageState();
}

class _ReaderPageState extends State<ReaderPage> {
  int _segmentedControlGroupValue = 0; // 0 = وضع المصحف، 1 = وضع النص
  double _fontSize = 24.0;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: CupertinoSlidingSegmentedControl<int>(
          groupValue: _segmentedControlGroupValue,
          children: const {
            0: Text('المصحف', style: TextStyle(fontSize: 13)),
            1: Text('النص', style: TextStyle(fontSize: 13)),
          },
          onValueChanged: (value) {
            setState(() {
              _segmentedControlGroupValue = value ?? 0;
            });
          },
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.textformat_size),
          onPressed: () => _showFontSizeSheet(context),
        ),
      ),
      child: SafeArea(
        child: _segmentedControlGroupValue == 0
            ? _buildMushafPageView()
            : _buildTextModeView(),
      ),
    );
  }

  // وضع المصحف: إطار صفحة المصحف المتناسق مع فواصل مخصصة
  Widget _buildMushafPageView() {
    return Container(
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFBF8E9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.accentGold, width: 3),
        boxShadow: const [
          BoxShadow(
            color: Color(0x15000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'سورة الفاتحة — الجزء الأول',
                style: TextStyle(color: CupertinoColors.black, fontSize: 13, fontWeight: FontWeight.bold),
              ),
            ),
            Container(height: 1, color: AppTheme.accentGold),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ ﴿١﴾ الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ ﴿٢﴾ الرَّحْمَٰنِ الرَّحِيمِ ﴿٣﴾ مَالِكِ يَوْمِ الدِّينِ ﴿٤﴾ إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ ﴿٥﴾ اهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ ﴿٦﴾ صِرَاطَ الَّذِينَ أَنْعَمْتَ عَلَيْهِمْ غَيْرِ الْمَغْضُوبِ عَلَيْهِمْ وَلَا الضَّالِّينَ ﴿٧﴾',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Amiri',
                      fontSize: _fontSize,
                      height: 2.2,
                      color: CupertinoColors.black,
                    ),
                  ),
                ),
              ),
            ),
            Container(height: 1, color: AppTheme.accentGold),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('1', style: TextStyle(color: CupertinoColors.black, fontSize: 12)),
            ),
          ],
        ),
      ),
    );
  }

  // وضع النص المرن: عرض الآيات مع تفاعل التفسير والحفظ والمشاركة
  Widget _buildTextModeView() {
    final List<String> ayahs = [
      'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
      'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ',
      'الرَّحْمَٰنِ الرَّحِيمِ',
      'مَالِكِ يَوْمِ الدِّينِ',
      'إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ',
      'اهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ',
      'صِرَاطَ الَّذِينَ أَنْعَمْتَ عَلَيْهِمْ غَيْرِ الْمَغْضُوبِ عَلَيْهِمْ وَلَا الضَّالِّينَ',
    ];

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: ayahs.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '${ayahs[index]} ﴿${index + 1}﴾',
                style: TextStyle(fontFamily: 'Amiri', fontSize: _fontSize, height: 2.0),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CupertinoButton(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: const Icon(CupertinoIcons.text_quote, size: 20),
                    onPressed: () => _showTafsirModal(context, index + 1),
                  ),
                  CupertinoButton(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: const Icon(CupertinoIcons.bookmark, size: 20),
                    onPressed: () {},
                  ),
                  CupertinoButton(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: const Icon(CupertinoIcons.share, size: 20),
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _showFontSizeSheet(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 180,
        color: CupertinoColors.systemBackground.resolveFrom(context),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text('حجم الخط', style: TextStyle(fontWeight: FontWeight.bold)),
            const Spacer(),
            CupertinoSlider(
              value: _fontSize,
              min: 18.0,
              max: 42.0,
              onChanged: (val) {
                setState(() => _fontSize = val);
              },
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  void _showTafsirModal(BuildContext context, int ayahNum) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => CupertinoActionSheet(
        title: Text('تفسير الميسر — الآية $ayahNum'),
        message: const Text(
          'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ: الثناء على الله بصفاته التي كلّها أوصاف كمال، وبنعمه الظاهرة والباطنة، الدينية والدنيوية.',
          textAlign: TextAlign.right,
          style: TextStyle(fontSize: 15, height: 1.5),
        ),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق'),
          )
        ],
      ),
    );
  }
}
