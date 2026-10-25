import 'package:shared_preferences/shared_preferences.dart';

class RecoveryStore {
  static const _key = 'recovery_start_ms';

  static Future<DateTime?> load() async {
    final p = await SharedPreferences.getInstance();
    final ms = p.getInt(_key);
    return ms == null ? null : DateTime.fromMillisecondsSinceEpoch(ms);
  }

  static Future<void> save(DateTime d) async {
    final p = await SharedPreferences.getInstance();
    await p.setInt(_key, d.millisecondsSinceEpoch);
  }
}

class Elapsed {
  final int years, months, days, hours, minutes;
  const Elapsed(this.years, this.months, this.days, this.hours, this.minutes);
}

Elapsed elapsedSince(DateTime start, DateTime now) {
  if (now.isBefore(start)) now = start;
  var y = now.year - start.year;
  var m = now.month - start.month;
  var d = now.day - start.day;
  var h = now.hour - start.hour;
  var mi = now.minute - start.minute;
  if (mi < 0) { mi += 60; h--; }
  if (h < 0) { h += 24; d--; }
  if (d < 0) { d += DateTime(now.year, now.month, 0).day; m--; }
  if (m < 0) { m += 12; y--; }
  return Elapsed(y, m, d, h, mi);
}
