import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:adhan/adhan.dart';
import 'package:intl/intl.dart';
import '../theme.dart';

class PrayerTimesPage extends StatefulWidget {
  const PrayerTimesPage({super.key});

  @override
  State<PrayerTimesPage> createState() => _PrayerTimesPageState();
}

class _PrayerTimesPageState extends State<PrayerTimesPage> {
  bool _isLoading = true;
  String _cityName = 'جارٍ التحديد...';
  PrayerTimes? _prayerTimes;
  Prayer? _nextPrayer;
  Timer? _timer;
  String _timeRemaining = '';

  @override
  void initState() {
    super.initState();
    _determinePositionAndCalculate();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _updateRemainingTime());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _determinePositionAndCalculate() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showErrorDialog('خدمات الموقع معطلة', 'يرجى تفعيل الـ GPS من إعدادات الجهاز للحصول على المواقيت بدقة.');
      setState(() => _isLoading = false);
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _useFallbackLocation();
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _useFallbackLocation();
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
      );

      final coordinates = Coordinates(position.latitude, position.longitude);
      final params = CalculationMethod.egyptian.getParameters();
      params.madhab = Madhab.shafi;

      final pTimes = PrayerTimes.today(coordinates, params);

      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
        if (placemarks.isNotEmpty) {
          _cityName = placemarks.first.locality ?? placemarks.first.country ?? 'موقعي الحالي';
        }
      } catch (_) {
        _cityName = 'موقعي الحالي';
      }

      setState(() {
        _prayerTimes = pTimes;
        _nextPrayer = pTimes.nextPrayer();
        _isLoading = false;
      });
      _updateRemainingTime();
    } catch (e) {
      _useFallbackLocation();
    }
  }

  void _useFallbackLocation() {
    // إحداثيات افتراضية (القاهرة كمثال افتراضي عند رفض الإذن)
    final coordinates = Coordinates(30.0444, 31.2357);
    final params = CalculationMethod.egyptian.getParameters();
    final pTimes = PrayerTimes.today(coordinates, params);

    setState(() {
      _cityName = 'القاهرة (افتراضي)';
      _prayerTimes = pTimes;
      _nextPrayer = pTimes.nextPrayer();
      _isLoading = false;
    });
    _updateRemainingTime();
  }

  void _updateRemainingTime() {
    if (_prayerTimes == null) return;
    final next = _prayerTimes!.nextPrayer();
    final nextTime = _prayerTimes!.timeForPrayer(next);
    if (nextTime != null) {
      final diff = nextTime.difference(DateTime.now());
      if (diff.isNegative) {
        setState(() => _timeRemaining = 'حان وقت الصلاة');
      } else {
        final hours = diff.inHours.toString().padLeft(2, '0');
        final minutes = (diff.inMinutes % 60).toString().padLeft(2, '0');
        final seconds = (diff.inSeconds % 60).toString().padLeft(2, '0');
        setState(() => _timeRemaining = '$hours:$minutes:$seconds');
      }
    }
  }

  void _showErrorDialog(String title, String message) {
    showCupertinoDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            child: const Text('حسناً'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  String _getPrayerArabicName(Prayer prayer) {
    switch (prayer) {
      case Prayer.fajr:
        return 'الفجر';
      case Prayer.sunrise:
        return 'الشروق';
      case Prayer.dhuhr:
        return 'الظهر';
      case Prayer.asr:
        return 'العصر';
      case Prayer.maghrib:
        return 'المغرب';
      case Prayer.isha:
        return 'العشاء';
      default:
        return 'الفجر';
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('مواقيت الصلاة'),
      ),
      child: SafeArea(
        child: _isLoading
            ? const Center(child: CupertinoActivityIndicator(radius: 14))
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // بطاقة الصلاة القادمة والموقع
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryGreen,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: const [
                          BoxShadow(color: Color(0x1F000000), blurRadius: 10, offset: Offset(0, 4))
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(CupertinoIcons.location_solid, color: AppTheme.accentGold, size: 18),
                                  const SizedBox(width: 6),
                                  Text(_cityName, style: const TextStyle(color: CupertinoColors.white, fontSize: 15)),
                                ],
                              ),
                              const Icon(CupertinoIcons.check_mark_circled_solid, color: CupertinoColors.activeGreen, size: 20),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'الصلاة القادمة: ${_getPrayerArabicName(_nextPrayer ?? Prayer.fajr)}',
                            style: const TextStyle(color: CupertinoColors.systemGrey4, fontSize: 14),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _timeRemaining,
                            style: const TextStyle(
                              color: CupertinoColors.white,
                              fontSize: 34,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // جدول مواقيت الصلوات اليومية بتنسيق iOS Inset Grouped List
                    Container(
                      decoration: BoxDecoration(
                        color: CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          _buildPrayerRow(context, 'الفجر', _prayerTimes!.fajr, _nextPrayer == Prayer.fajr),
                          const Divider(height: 1, indent: 16),
                          _buildPrayerRow(context, 'الشروق', _prayerTimes!.sunrise, _nextPrayer == Prayer.sunrise),
                          const Divider(height: 1, indent: 16),
                          _buildPrayerRow(context, 'الظهر', _prayerTimes!.dhuhr, _nextPrayer == Prayer.dhuhr),
                          const Divider(height: 1, indent: 16),
                          _buildPrayerRow(context, 'العصر', _prayerTimes!.asr, _nextPrayer == Prayer.asr),
                          const Divider(height: 1, indent: 16),
                          _buildPrayerRow(context, 'المغرب', _prayerTimes!.maghrib, _nextPrayer == Prayer.maghrib),
                          const Divider(height: 1, indent: 16),
                          _buildPrayerRow(context, 'العشاء', _prayerTimes!.isha, _nextPrayer == Prayer.isha),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildPrayerRow(BuildContext context, String name, DateTime time, bool isNext) {
    final formattedTime = DateFormat.jm('ar_SA').format(time);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                isNext ? CupertinoIcons.bell_fill : CupertinoIcons.bell,
                color: isNext ? AppTheme.accentGold : CupertinoColors.systemGrey,
                size: 20,
              ),
              const SizedBox(width: 12),
              Text(
                name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isNext ? FontWeight.bold : FontWeight.w500,
                  color: isNext ? AppTheme.activeGreen : CupertinoColors.label.resolveFrom(context),
                ),
              ),
            ],
          ),
          Text(
            formattedTime,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isNext ? FontWeight.bold : FontWeight.normal,
              color: isNext ? AppTheme.activeGreen : CupertinoColors.secondaryLabel.resolveFrom(context),
            ),
          ),
        ],
      ),
    );
  }
}
