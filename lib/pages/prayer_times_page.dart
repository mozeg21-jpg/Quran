import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:adhan_dart/adhan_dart.dart';
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
  String _nextPrayerName = 'الفجر';
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
      _useFallbackLocation();
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
      final params = CalculationMethod.egyptian();
      params.madhab = Madhab.shafi;

      final pTimes = PrayerTimes(
        coordinates: coordinates,
        date: DateTime.now(),
        calculationParameters: params,
        precision: true,
      );

      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
        if (placemarks.isNotEmpty) {
          _cityName = placemarks.first.locality ?? placemarks.first.administrativeArea ?? 'موقعي الحالي';
        }
      } catch (_) {
        _cityName = 'موقعي الحالي';
      }

      setState(() {
        _prayerTimes = pTimes;
        _isLoading = false;
      });
      _updateRemainingTime();
    } catch (e) {
      _useFallbackLocation();
    }
  }

  void _useFallbackLocation() {
    final coordinates = Coordinates(30.0444, 31.2357);
    final params = CalculationMethod.egyptian();
    params.madhab = Madhab.shafi;

    final pTimes = PrayerTimes(
      coordinates: coordinates,
      date: DateTime.now(),
      calculationParameters: params,
      precision: true,
    );

    setState(() {
      _cityName = 'القاهرة (افتراضي)';
      _prayerTimes = pTimes;
      _isLoading = false;
    });
    _updateRemainingTime();
  }

  void _updateRemainingTime() {
    if (_prayerTimes == null) return;

    final nextPrayerKey = _prayerTimes!.nextPrayer();
    DateTime? nextTime;

    switch (nextPrayerKey) {
      case 'fajr':
        _nextPrayerName = 'الفجر';
        nextTime = _prayerTimes!.fajr;
        break;
      case 'sunrise':
        _nextPrayerName = 'الشروق';
        nextTime = _prayerTimes!.sunrise;
        break;
      case 'dhuhr':
        _nextPrayerName = 'الظهر';
        nextTime = _prayerTimes!.dhuhr;
        break;
      case 'asr':
        _nextPrayerName = 'العصر';
        nextTime = _prayerTimes!.asr;
        break;
      case 'maghrib':
        _nextPrayerName = 'المغرب';
        nextTime = _prayerTimes!.maghrib;
        break;
      case 'isha':
        _nextPrayerName = 'العشاء';
        nextTime = _prayerTimes!.isha;
        break;
      default:
        _nextPrayerName = 'الفجر';
        nextTime = _prayerTimes!.fajr?.add(const Duration(days: 1));
        break;
    }

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

  Widget _buildSeparator() {
    return Container(
      height: 0.5,
      margin: const EdgeInsets.only(left: 16),
      color: CupertinoColors.separator,
    );
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
                            'الصلاة القادمة: $_nextPrayerName',
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
                    Container(
                      decoration: BoxDecoration(
                        color: CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          _buildPrayerRow(context, 'الفجر', _prayerTimes!.fajr, _nextPrayerName == 'الفجر'),
                          _buildSeparator(),
                          _buildPrayerRow(context, 'الشروق', _prayerTimes!.sunrise, _nextPrayerName == 'الشروق'),
                          _buildSeparator(),
                          _buildPrayerRow(context, 'الظهر', _prayerTimes!.dhuhr, _nextPrayerName == 'الظهر'),
                          _buildSeparator(),
                          _buildPrayerRow(context, 'العصر', _prayerTimes!.asr, _nextPrayerName == 'العصر'),
                          _buildSeparator(),
                          _buildPrayerRow(context, 'المغرب', _prayerTimes!.maghrib, _nextPrayerName == 'المغرب'),
                          _buildSeparator(),
                          _buildPrayerRow(context, 'العشاء', _prayerTimes!.isha, _nextPrayerName == 'العشاء'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildPrayerRow(BuildContext context, String name, DateTime? time, bool isNext) {
    final formattedTime = time != null ? DateFormat.jm('ar_SA').format(time.toLocal()) : '--:--';
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
