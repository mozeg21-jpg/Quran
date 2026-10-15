import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';
import '../theme.dart';

class CompassPage extends StatefulWidget {
  const CompassPage({super.key});

  @override
  State<CompassPage> createState() => _CompassPageState();
}

class _CompassPageState extends State<CompassPage> {
  double? _heading = 0;
  double _qiblaBearing = 0;
  bool _hasLocation = false;
  String _statusText = 'جارٍ تحديد اتجاه القبلة...';

  @override
  void initState() {
    super.initState();
    _initQibla();
    FlutterCompass.events?.listen((event) {
      if (mounted) {
        setState(() {
          _heading = event.heading;
        });
      }
    });
  }

  Future<void> _initQibla() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
      );
      _qiblaBearing = _calculateQibla(position.latitude, position.longitude);
      setState(() {
        _hasLocation = true;
        _statusText = 'تم تحديد اتجاه القبلة بنجاح';
      });
    } catch (e) {
      // إحداثيات بديلة إذا تعذر التحديد
      _qiblaBearing = _calculateQibla(30.0444, 31.2357);
      setState(() {
        _hasLocation = true;
        _statusText = 'الموقع الافتراضي: القاهرة';
      });
    }
  }

  // الحساب الفلكي الرياضي لزاوية القبلة الكروية
  double _calculateQibla(double lat, double lon) {
    const meccaLat = 21.4225;
    const meccaLon = 39.8262;

    final phi1 = lat * (math.pi / 180.0);
    final phi2 = meccaLat * (math.pi / 180.0);
    final deltaLam = (meccaLon - lon) * (math.pi / 180.0);

    final y = math.sin(deltaLam);
    final x = math.cos(phi1) * math.tan(phi2) - math.sin(phi1) * math.cos(deltaLam);
    final bearing = math.atan2(y, x) * (180.0 / math.pi);

    return (bearing + 360.0) % 360.0;
  }

  @override
  Widget build(BuildContext context) {
    final currentHeading = _heading ?? 0;
    final diff = ((currentHeading - _qiblaBearing).abs()) % 360;
    final isFacingQibla = diff < 3 || diff > 357;

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('اتجاه القبلة'),
      ),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Text(
                  '${_qiblaBearing.toStringAsFixed(0)}°',
                  style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: AppTheme.activeGreen),
                ),
                const SizedBox(height: 4),
                Text(
                  _statusText,
                  style: const TextStyle(fontSize: 14, color: CupertinoColors.secondaryLabel),
                ),
              ],
            ),

            // واجهة البوصلة المطابقة لشاشة الآيفون
            Center(
              child: SizedBox(
                width: 280,
                height: 280,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // إطار البوصلة الدائري الخارجي
                    Transform.rotate(
                      angle: -((currentHeading) * (math.pi / 180.0)),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isFacingQibla ? CupertinoColors.activeGreen : CupertinoColors.systemGrey4,
                            width: 3,
                          ),
                        ),
                        child: CustomPaint(
                          size: const Size(280, 280),
                          painter: CompassTicksPainter(),
                        ),
                      ),
                    ),

                    // مؤشر اتجاه الكعبة المشرفة
                    Transform.rotate(
                      angle: ((_qiblaBearing - currentHeading) * (math.pi / 180.0)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: AppTheme.primaryGreen,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(CupertinoIcons.cube_box_fill, color: AppTheme.accentGold, size: 24),
                          ),
                          const SizedBox(height: 190),
                        ],
                      ),
                    ),

                    // المنتصف
                    Container(
                      width: 14,
                      height: 14,
                      decoration: const BoxDecoration(
                        color: AppTheme.accentGold,
                        shape: BoxShape.circle,
                      ),
                    )
                  ],
                ),
              ),
            ),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isFacingQibla ? CupertinoIcons.check_mark_circled_solid : CupertinoIcons.compass,
                    color: isFacingQibla ? CupertinoColors.activeGreen : CupertinoColors.systemGrey,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    isFacingQibla ? 'أنت تواجه القبلة الآن بدقة' : 'قم بتدوير الهاتف حتى يتطابق المؤشر',
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CompassTicksPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = CupertinoColors.systemGrey3
      ..strokeWidth = 1.5;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    for (int i = 0; i < 360; i += 30) {
      final angle = i * (math.pi / 180);
      final p1 = Offset(center.dx + (radius - 12) * math.cos(angle), center.dy + (radius - 12) * math.sin(angle));
      final p2 = Offset(center.dx + radius * math.cos(angle), center.dy + radius * math.sin(angle));
      canvas.drawLine(p1, p2, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
