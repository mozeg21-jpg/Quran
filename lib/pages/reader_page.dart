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

  // وضع المصحف: محاكاة إطار صفحة المصحف الشريف الكلاسيكية
  Widget _buildMushafPageView() {
    return Container(
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFBF8E9), // لون الورق المصحفي
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
                'سورة البقرة — الجزء الأول',
                style: TextStyle(color: CupertinoColors.black, fontSize: 13, fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(color: AppTheme.accentGold, height: 1),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ ﴿١﴾ الرَّحْمَٰنِ الرَّحِيمِ ﴿٢﴾ مَالِكِ يَوْمِ الدِّينِ ﴿٣﴾ إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ ﴿٤﴾ اهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ ﴿٥﴾ صِرَاطَ الَّذِينَ أَنْعَمْتَ عَلَيْهِمْ غَيْرِ الْمَغْضُوبِ عَلَيْهِمْ وَلَا الضَّالِّينَ ﴿٦﴾',
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
            const Divider(color: AppTheme.accentGold, height: 1),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('1', style: TextStyle(color: CupertinoColors.black, fontSize: 12)),
            ),
          ],
        ),
      ),
    );
  }

  // وضع النص المرن: يتيح التفاعل مع كل آية (تفسير، نسخ، مشاركة، مفضلة)
  Widget _buildTextModeView() {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: 7,
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
                'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ ﴿${index + 1}﴾',
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
        title: Text('تفسير ابن كثير — الآية $ayahNum'),
        message: const Text(
          'الْحَمْدُ لِلَّهِ: الشكر لله خالصاً دون سائر ما يُعبد من دونه، بما أنعم على عباده من النعم التي لا يحصيها عدد.',
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
