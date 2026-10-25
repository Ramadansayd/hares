import 'package:flutter/material.dart';

import '../data/models.dart';
import '../data/repository.dart';
import '../theme.dart';
import '../widgets/gold_card.dart';

/// خانة "الاجتماع": صفحات 1 إلى 11 من الكتاب.
class MeetingsScreen extends StatelessWidget {
  const MeetingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الاجتماع'),
        backgroundColor: AppColors.ink,
        foregroundColor: AppColors.gold,
      ),
      body: DecoratedBox(
        decoration: appBackground,
        child: FutureBuilder<List<MeetingPage>>(
          future: Repo.meetings(),
          builder: (context, snap) {
            if (!snap.hasData) return const Center(child: CircularProgressIndicator());
            final pages = snap.data!;
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: pages.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, i) {
                final p = pages[i];
                return GoldCard(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => MeetingReader(pages: pages, initialIndex: i)),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: AppColors.gold,
                        child: Text('${p.page}', style: const TextStyle(color: AppColors.ink, fontWeight: FontWeight.w800)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(p.title,
                            style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                      ),
                      const Icon(Icons.chevron_left, color: AppColors.gold),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class MeetingReader extends StatefulWidget {
  final List<MeetingPage> pages;
  final int initialIndex;
  const MeetingReader({super.key, required this.pages, required this.initialIndex});

  @override
  State<MeetingReader> createState() => _MeetingReaderState();
}

class _MeetingReaderState extends State<MeetingReader> {
  late final PageController _controller = PageController(initialPage: widget.initialIndex);
  late int _index = widget.initialIndex;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.pages.length;
    return Scaffold(
      appBar: AppBar(
        title: Text('صفحة ${widget.pages[_index].page} من $total'),
        backgroundColor: AppColors.ink,
        foregroundColor: AppColors.gold,
      ),
      body: DecoratedBox(
        decoration: appBackground,
        child: PageView.builder(
          controller: _controller,
          itemCount: total,
          onPageChanged: (i) => setState(() => _index = i),
          itemBuilder: (context, i) => _PageView(page: widget.pages[i]),
        ),
      ),
    );
  }
}

class _PageView extends StatelessWidget {
  final MeetingPage page;
  const _PageView({required this.page});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      child: GoldCard(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(page.title,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.gold, fontSize: 22, fontWeight: FontWeight.w800, height: 1.5)),
            const Divider(color: Colors.white24, height: 28),
            for (final b in page.blocks) _BlockView(b),
          ],
        ),
      ),
    );
  }
}

class _BlockView extends StatelessWidget {
  final Block b;
  const _BlockView(this.b);

  @override
  Widget build(BuildContext context) {
    const body = TextStyle(color: Colors.white, fontSize: 17, height: 1.9);
    switch (b.type) {
      case 'h':
        return Padding(
          padding: const EdgeInsets.only(top: 12, bottom: 6),
          child: Text(b.text,
              style: const TextStyle(color: AppColors.goldLight, fontSize: 18, fontWeight: FontWeight.w800, height: 1.6)),
        );
      case 'b':
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 6, left: 8),
                child: Icon(Icons.circle, size: 8, color: AppColors.gold),
              ),
              Expanded(child: Text(b.text, style: body)),
            ],
          ),
        );
      case 's':
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Text(b.text, style: body.copyWith(fontWeight: FontWeight.w600)),
        );
      default:
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Text(b.text, textAlign: TextAlign.justify, style: body),
        );
    }
  }
}
