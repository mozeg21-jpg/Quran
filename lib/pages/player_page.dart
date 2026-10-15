import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../theme.dart';
import '../services/audio_service.dart';

class PlayerPage extends StatelessWidget {
  const PlayerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final audio = Provider.of<AudioService>(context);

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('مشغل التلاوات'),
        border: null,
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // الزخرفة الدائرية الكبيرة المستوحاة من شاشة المشغل بالصورة
              Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.primaryGreen,
                  border: Border.all(color: AppTheme.accentGold, width: 4),
                  boxShadow: const [
                    BoxShadow(color: Color(0x33000000), blurRadius: 20, offset: Offset(0, 8)),
                  ],
                ),
                child: const Center(
                  child: Icon(CupertinoIcons.circle_grid_hex_fill, size: 100, color: AppTheme.accentGold),
                ),
              ),
              
              // بيانات السورة والقارئ
              Column(
                children: [
                  const Text('سورة البقرة', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Text(
                    audio.currentReciterName.isNotEmpty ? audio.currentReciterName : 'عبد الباسط عبد الصمد',
                    style: const TextStyle(fontSize: 16, color: CupertinoColors.secondaryLabel),
                  ),
                ],
              ),

              // شريط تقدم الصوت
              Column(
                children: [
                  CupertinoSlider(
                    value: audio.progress,
                    onChanged: (val) => audio.seek(val),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('02:15', style: TextStyle(fontSize: 12, color: CupertinoColors.secondaryLabel)),
                        Text('-03:42', style: TextStyle(fontSize: 12, color: CupertinoColors.secondaryLabel)),
                      ],
                    ),
                  ),
                ],
              ),

              // أزرار التحكم
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CupertinoButton(
                    child: const Icon(CupertinoIcons.backward_fill, size: 30),
                    onPressed: () => audio.previous(),
                  ),
                  const SizedBox(width: 20),
                  CupertinoButton.filled(
                    borderRadius: BorderRadius.circular(40),
                    padding: const EdgeInsets.all(18),
                    child: Icon(audio.isPlaying ? CupertinoIcons.pause_fill : CupertinoIcons.play_fill, size: 36),
                    onPressed: () => audio.togglePlay(),
                  ),
                  const SizedBox(width: 20),
                  CupertinoButton(
                    child: const Icon(CupertinoIcons.forward_fill, size: 30),
                    onPressed: () => audio.next(),
                  ),
                ],
              ),

              // خيارات السرعة ومؤقت النوم
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildOptionButton(context, 'السرعة: 1x', CupertinoIcons.speedometer),
                  _buildOptionButton(context, 'مؤقت النوم', CupertinoIcons.timer),
                  _buildOptionButton(context, 'تكرار', CupertinoIcons.repeat),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionButton(BuildContext context, String title, IconData icon) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () {},
      child: Row(
        children: [
          Icon(icon, size: 18, color: CupertinoColors.secondaryLabel),
          const SizedBox(width: 4),
          Text(title, style: const TextStyle(fontSize: 13, color: CupertinoColors.secondaryLabel)),
        ],
      ),
    );
  }
}