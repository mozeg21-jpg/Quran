import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/surah.dart';
import '../models/ayah.dart';
import '../models/reciter.dart';

class QuranApi {
  static const String _baseUrl = 'https://api.alquran.cloud/v1';
  static const String _mp3QuranUrl = 'https://mp3quran.net/api/v3';

  // جلب قائمة السور كاملة
  Future<List<Surah>> getAllSurahs() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/surah'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> surahsJson = data['data'];
        return surahsJson.map((json) => Surah.fromJson(json)).toList();
      } else {
        throw Exception('فشل في تحميل قائمة السور');
      }
    } catch (e) {
      throw Exception('خطأ في الاتصال بالشبكة: $e');
    }
  }

  // جلب آيات سورة محددة بالرسم العثماني
  Future<List<Ayah>> getSurahAyahs(int surahNumber) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/surah/$surahNumber/quran-uthmani'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> ayahsJson = data['data']['ayahs'];
        return ayahsJson.map((json) => Ayah.fromJson(json)).toList();
      } else {
        throw Exception('فشل في تحميل آيات السورة');
      }
    } catch (e) {
      throw Exception('خطأ في الاتصال بالشبكة: $e');
    }
  }

  // جلب تفسير آية معينة (تفسير الميسر)
  Future<String> getAyahTafsir(int surahNumber, int ayahNumber) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/ayah/$surahNumber:$ayahNumber/ar.muyassar'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return data['data']['text'] as String;
      } else {
        return 'تعذر تحميل التفسير في الوقت الحالي.';
      }
    } catch (e) {
      return 'تعذر جلب التفسير، يرجى التحقق من اتصالك بالإنترنت.';
    }
  }

  // جلب قائمة كبار القراء
  Future<List<Reciter>> getReciters() async {
    try {
      final response = await http.get(Uri.parse('$_mp3QuranUrl/reciters?language=ar'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> list = data['reciters'];
        return list.map((json) => Reciter.fromJson(json)).toList();
      } else {
        // قائمة احتياطية لكبار القراء في حال انقطاع الخادم
        return _getFallbackReciters();
      }
    } catch (e) {
      return _getFallbackReciters();
    }
  }

  List<Reciter> _getFallbackReciters() {
    return [
      Reciter(
        id: '1',
        name: 'عبد الباسط عبد الصمد',
        server: 'https://server7.mp3quran.net/basit/',
        rewaya: 'مرتل',
        count: 114,
      ),
      Reciter(
        id: '2',
        name: 'مشاري بن راشد العفاسي',
        server: 'https://server8.mp3quran.net/afs/',
        rewaya: 'حفص عن عاصم',
        count: 114,
      ),
      Reciter(
        id: '3',
        name: 'محمود خليل الحصري',
        server: 'https://server13.mp3quran.net/husr/',
        rewaya: 'مرتل',
        count: 114,
      ),
      Reciter(
        id: '4',
        name: 'محمد صديق المنشاوي',
        server: 'https://server10.mp3quran.net/minsh/',
        rewaya: 'مرتل',
        count: 114,
      ),
      Reciter(
        id: '5',
        name: 'سعد الغامدي',
        server: 'https://server7.mp3quran.net/s_gmd/',
        rewaya: 'حفص عن عاصم',
        count: 114,
      ),
    ];
  }
}
