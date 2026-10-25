import 'dart:async';
import 'package:flutter/material.dart';

import '../data/models.dart';
import '../data/recovery_store.dart';
import '../data/repository.dart';
import '../theme.dart';
import '../widgets/gold_card.dart';
import '../widgets/home_tile.dart';
import 'daily_reading_screen.dart';
import 'meetings_screen.dart';

class HomeScreen extends StatefulWidget {
  final DateTime start;
  const HomeScreen({super.key, required this.start});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Timer _timer;
  DateTime _now = DateTime.now();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (mounted) setState(() => _now = DateTime.now());
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _soon(String what) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$what - قريباً')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final e = elapsedSince(widget.start, _now);
    final today = DateTime.now();

    return Scaffold(
      body: DecoratedBox(
        decoration: appBackground,
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(18, 12, 18, 18),
            children: [
              // الشعار
              SizedBox(
                height: 110,
                child: Image.asset(
                  'assets/images/logo.png',
                  errorBuilder: (_, __, ___) => const Center(
                    child: Text('حارس',
                        style: TextStyle(fontSize: 44, color: AppColors.gold, fontWeight: FontWeight.w800)),
                  ),
                ),
              ),
              const Center(
                child: Text('رحلة تعافي ودعم', style: TextStyle(color: Colors.white, fontSize: 14)),
              ),
              const SizedBox(height: 14),

              // عداد التعافي
              GoldCard(
                child: Column(
                  children: [
                    const Text('عداد التعافي',
                        style: TextStyle(color: AppColors.gold, fontSize: 18, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _Counter(value: '${e.years}', label: 'سنة'),
                        _Counter(value: '${e.months}', label: 'أشهر'),
                        _Counter(value: '${e.days}', label: 'يوماً'),
                        _Counter(
                          value: '${e.hours.toString().padLeft(2, '0')}:${e.minutes.toString().padLeft(2, '0')}',
                          label: 'ساعات',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // الأزرار (2 × 2) - في RTL الأول يظهر على اليمين
              Row(
                children: [
                  Expanded(
                    child: HomeTile(
                      label: 'قراءة لليوم فقط',
                      icon: Icons.menu_book_rounded,
                      color: AppColors.amber,
                      // imageAsset: 'assets/images/btn_reading.png',
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => DailyReadingScreen(date: today)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: HomeTile(
                      label: 'الاجتماع',
                      icon: Icons.groups_rounded,
                      color: AppColors.blue,
                      // imageAsset: 'assets/images/btn_meeting.png',
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const MeetingsScreen()),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: HomeTile(
                      label: 'بحث في الأدبيات',
                      icon: Icons.search_rounded,
                      color: AppColors.grey,
                      onTap: () => _soon('البحث في الأدبيات'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: HomeTile(
                      label: 'كتب الزمالة',
                      icon: Icons.auto_stories_rounded,
                      color: AppColors.green,
                      onTap: () => _soon('كتب الزمالة'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // رسالة اليوم (تتغير كل يوم)
              FutureBuilder<DailyReading?>(
                future: Repo.dailyFor(today),
                builder: (context, snap) {
                  final r = snap.data;
                  return GoldCard(
                    onTap: r == null
                        ? null
                        : () => Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => DailyReadingScreen(date: today)),
                            ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text('رسالة اليوم',
                                style: TextStyle(color: AppColors.gold, fontSize: 18, fontWeight: FontWeight.w800)),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppColors.goldLight,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text('لليوم فقط',
                                  style: TextStyle(color: AppColors.ink, fontSize: 12, fontWeight: FontWeight.w700)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          r?.jft ?? '...',
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.white, fontSize: 16, height: 1.7, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 6),
                        const Text('اضغط لقراءة قراءة اليوم كاملة',
                            style: TextStyle(color: Colors.white54, fontSize: 12)),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              const Center(
                child: Text('تطبيق حارس - الإصدار 1.0', style: TextStyle(color: Colors.white54, fontSize: 12)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Counter extends StatelessWidget {
  final String value;
  final String label;
  const _Counter({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(color: AppColors.goldLight, fontSize: 26, fontWeight: FontWeight.w800)),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }
}
