import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import '../theme.dart';

class TasbihPage extends StatefulWidget {
  const TasbihPage({super.key});

  @override
  State<TasbihPage> createState() => _TasbihPageState();
}

class _TasbihPageState extends State<TasbihPage> {
  int _counter = 0;
  int _target = 33;
  String _selectedDhikr = 'سبحان الله';

  final List<String> _adhkar = [
    'سبحان الله',
    'الحمد لله',
    'لا إله إلا الله',
    'الله أكبر',
    'أستغفر الله وأتوب إليه',
    'اللهم صلِّ على محمد',
  ];

  void _increment() {
    HapticFeedback.lightImpact(); // اهتزاز مطابق للـ Taptic Engine الخاص بـ iOS
    setState(() {
      _counter++;
    });
  }

  void _reset() {
    HapticFeedback.mediumImpact();
    setState(() {
      _counter = 0;
    });
  }

  void _showDhikrPicker() {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 240,
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: Column(
          children: [
            SizedBox(
              height: 180,
              child: CupertinoPicker(
                itemExtent: 36,
                scrollController: FixedExtentScrollController(
                  initialItem: _adhkar.indexOf(_selectedDhikr),
                ),
                onSelectedItemChanged: (index) {
                  setState(() {
                    _selectedDhikr = _adhkar[index];
                    _counter = 0;
                  });
                },
                children: _adhkar.map((d) => Center(child: Text(d))).toList(),
              ),
            ),
            CupertinoButton(
              child: const Text('تم'),
              onPressed: () => Navigator.pop(context),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('السبحة الإلكترونية'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.arrow_counterclockwise),
          onPressed: _reset,
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // زر اختيار الذكر
            CupertinoButton(
              onPressed: _showDhikrPicker,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: AppTheme.activeGreen.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _selectedDhikr,
                      style: const TextStyle(fontSize: 18, color: AppTheme.activeGreen, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 8),
                    const Icon(CupertinoIcons.chevron_down, size: 16, color: AppTheme.activeGreen),
                  ],
                ),
              ),
            ),

            // دائرة العداد التفاعلية الضخمة (الضغط داخلها يعدّ)
            GestureDetector(
              onTap: _increment,
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context),
                  border: Border.all(color: AppTheme.activeGreen, width: 4),
                  boxShadow: const [
                    BoxShadow(color: Color(0x14000000), blurRadius: 20, offset: Offset(0, 10))
                  ],
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$_counter',
                        style: const TextStyle(fontSize: 64, fontWeight: FontWeight.bold, color: AppTheme.activeGreen),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'من هدف $_target',
                        style: const TextStyle(fontSize: 14, color: CupertinoColors.secondaryLabel),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // أزرار التحكم وإعادة الضبط
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CupertinoButton.filled(
                  borderRadius: BorderRadius.circular(14),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  onPressed: _reset,
                  child: const Text('إعادة الضبط'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
