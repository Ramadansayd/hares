import 'package:flutter/material.dart';

import '../data/recovery_store.dart';
import '../theme.dart';
import '../widgets/gold_card.dart';
import 'home_screen.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  DateTime _date = DateTime.now();
  TimeOfDay _time = TimeOfDay.now();

  String get _dateText =>
      '${_date.day.toString().padLeft(2, '0')} / ${_date.month.toString().padLeft(2, '0')} / ${_date.year}';

  String get _timeText {
    final h12 = _time.hourOfPeriod == 0 ? 12 : _time.hourOfPeriod;
    final ampm = _time.period == DayPeriod.am ? 'ص' : 'م';
    return '${h12.toString().padLeft(2, '0')}:${_time.minute.toString().padLeft(2, '0')} $ampm';
  }

  Future<void> _pickDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
    );
    if (d != null) setState(() => _date = d);
  }

  Future<void> _pickTime() async {
    final t = await showTimePicker(context: context, initialTime: _time);
    if (t != null) setState(() => _time = t);
  }

  Future<void> _begin() async {
    final start = DateTime(_date.year, _date.month, _date.day, _time.hour, _time.minute);
    await RecoveryStore.save(start);
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => HomeScreen(start: start)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: appBackground,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
            child: Column(
              children: [
                // الشعار: حط صورتك في assets/images/logo.png
                SizedBox(
                  height: 150,
                  child: Image.asset(
                    'assets/images/logo.png',
                    errorBuilder: (_, __, ___) => const Text(
                      'حارس',
                      style: TextStyle(fontSize: 64, color: AppColors.gold, fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
                const Text('HARES', style: TextStyle(color: AppColors.gold, letterSpacing: 6, fontSize: 18)),
                const SizedBox(height: 4),
                const Text('رحلة تعافي ودعم', style: TextStyle(color: Colors.white, fontSize: 15)),
                const SizedBox(height: 20),
                // الإهداء: عدّل الأسماء زي ما تحب
                const GoldCard(
                  child: Column(
                    children: [
                      Text('إهداء وتقدير خاص:', style: TextStyle(color: AppColors.gold, fontSize: 16, fontWeight: FontWeight.w700)),
                      SizedBox(height: 8),
                      Text('إلى من ساندوني في رحلة تعافيي:', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 15)),
                      SizedBox(height: 6),
                      Text('المدير العلاجي / إيهاب الهواري\nالأستاذ / وليد دسوقي\nالأستاذ / عزت',
                          textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 15, height: 1.6)),
                      Divider(color: Colors.white24, height: 24),
                      Text.rich(
                        TextSpan(children: [
                          TextSpan(text: 'إهداء من المبرمج: ', style: TextStyle(color: Colors.white)),
                          TextSpan(text: 'رمضان سيد', style: TextStyle(color: AppColors.gold, fontWeight: FontWeight.w700)),
                        ]),
                        style: TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                const Align(
                  alignment: Alignment.centerRight,
                  child: Text('أدخل تاريخ وساعة بداية التعافي:', style: TextStyle(color: Colors.white, fontSize: 15)),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(child: _PickerBox(text: _dateText, icon: Icons.calendar_month, onTap: _pickDate)),
                    const SizedBox(width: 12),
                    Expanded(child: _PickerBox(text: _timeText, icon: Icons.access_time, onTap: _pickTime)),
                  ],
                ),
                const SizedBox(height: 22),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.cream,
                      foregroundColor: AppColors.ink,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: _begin,
                    child: const Text('بدء رحلة التعافي 🚀', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                  ),
                ),
                const SizedBox(height: 14),
                const Text('تطبيق حارس - الإصدار 1.0', style: TextStyle(color: Colors.white54, fontSize: 12)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PickerBox extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onTap;
  const _PickerBox({required this.text, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.gold.withOpacity(0.7)),
          color: Colors.black.withOpacity(0.2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(text, style: const TextStyle(color: Colors.white, fontSize: 14)),
            Icon(icon, color: Colors.white70, size: 20),
          ],
        ),
      ),
    );
  }
}
