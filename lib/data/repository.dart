import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'models.dart';

const arabicMonths = [
  'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
  'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر',
];

class Repo {
  static List<MeetingPage>? _meetings;
  static Map<String, DailyReading>? _daily;

  /// صفحات 1 إلى 11 (خانة الاجتماع)
  static Future<List<MeetingPage>> meetings() async {
    if (_meetings != null) return _meetings!;
    final raw = await rootBundle.loadString('assets/data/meetings.json');
    final list = jsonDecode(raw) as List;
    _meetings = list
        .map((e) => MeetingPage.fromJson(e as Map<String, dynamic>))
        .toList();
    return _meetings!;
  }

  static Future<Map<String, DailyReading>> _loadDaily() async {
    if (_daily != null) return _daily!;
    final raw = await rootBundle.loadString('assets/data/daily.json');
    final map = jsonDecode(raw) as Map<String, dynamic>;
    _daily = map.map((k, v) =>
        MapEntry(k, DailyReading.fromJson(v as Map<String, dynamic>)));
    return _daily!;
  }

  static String keyFor(DateTime d) =>
      '${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  /// قراءة اليوم حسب التاريخ (شهر-يوم)
  static Future<DailyReading?> dailyFor(DateTime d) async {
    final all = await _loadDaily();
    return all[keyFor(d)];
  }
}
