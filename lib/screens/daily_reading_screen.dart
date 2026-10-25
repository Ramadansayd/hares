import 'package:flutter/material.dart';

import '../data/models.dart';
import '../data/repository.dart';
import '../theme.dart';
import '../widgets/gold_card.dart';

/// قراءة "لليوم فقط": رسالة اليوم فوق، وتحتها القراءة كاملة. تتغير كل يوم حسب التاريخ.
class DailyReadingScreen extends StatefulWidget {
  final DateTime date;
  const DailyReadingScreen({super.key, required this.date});

  @override
  State<DailyReadingScreen> createState() => _DailyReadingScreenState();
}

class _DailyReadingScreenState extends State<DailyReadingScreen> {
  late DateTime _date = widget.date;

  void _shift(int days) =>
      setState(() => _date = DateTime(_date.year, _date.month, _date.day + days));

  Future<void> _pick() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(_date.year, 1, 1),
      lastDate: DateTime(_date.year, 12, 31),
    );
    if (d != null) setState(() => _date = d);
  }

  @override
  Widget build(BuildContext context) {
    final dateText = '${_date.day} ${arabicMonths[_date.month - 1]}';
    return Scaffold(
      appBar: AppBar(
        title: const Text('قراءة لليوم فقط'),
        backgroundColor: AppColors.ink,
        foregroundColor: AppColors.gold,
        actions: [IconButton(onPressed: _pick, icon: const Icon(Icons.calendar_month))],
      ),
      body: DecoratedBox(
        decoration: appBackground,
        child: FutureBuilder<DailyReading?>(
          future: Repo.dailyFor(_date),
          builder: (context, snap) {
            if (snap.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            final r = snap.data;
            return ListView(
              padding: const EdgeInsets.fromLTRB(18, 14, 18, 32),
              children: [
                // التنقل بين الأيام
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(onPressed: () => _shift(-1), icon: const Icon(Icons.chevron_right, color: AppColors.gold)),
                    Text(dateText,
                        style: const TextStyle(color: AppColors.goldLight, fontSize: 20, fontWeight: FontWeight.w800)),
                    IconButton(onPressed: () => _shift(1), icon: const Icon(Icons.chevron_left, color: AppColors.gold)),
                  ],
                ),
                const SizedBox(height: 8),
                if (r == null)
                  const GoldCard(child: Text('لا توجد قراءة لهذا اليوم', style: TextStyle(color: Colors.white)))
                else ...[
                  // رسالة اليوم (فوق)
                  GoldCard(
                    padding: const EdgeInsets.all(18),
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
                              decoration: BoxDecoration(color: AppColors.goldLight, borderRadius: BorderRadius.circular(8)),
                              child: const Text('لليوم فقط',
                                  style: TextStyle(color: AppColors.ink, fontSize: 12, fontWeight: FontWeight.w700)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(r.jft,
                            style: const TextStyle(color: Colors.white, fontSize: 18, height: 1.8, fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // القراءة كاملة (تحت)
                  if (r.title.isNotEmpty)
                    Text(r.title,
                        style: const TextStyle(color: AppColors.gold, fontSize: 22, fontWeight: FontWeight.w800, height: 1.5)),
                  const SizedBox(height: 10),
                  if (r.quote.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(12),
                        border: const Border(right: BorderSide(color: AppColors.gold, width: 4)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(r.quote,
                              style: const TextStyle(color: AppColors.cream, fontSize: 17, height: 1.8, fontStyle: FontStyle.italic)),
                          if (r.source.isNotEmpty) ...[
                            const SizedBox(height: 6),
                            Text(r.source, style: const TextStyle(color: Colors.white60, fontSize: 13)),
                          ],
                        ],
                      ),
                    ),
                  const SizedBox(height: 14),
                  for (final p in r.body)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 7),
                      child: Text(p,
                          textAlign: TextAlign.justify,
                          style: const TextStyle(color: Colors.white, fontSize: 17, height: 1.9)),
                    ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}
