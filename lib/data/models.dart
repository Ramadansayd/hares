class Block {
  /// p = فقرة، h = عنوان فرعي، b = نقطة، s = بند مرقّم (الخطوات والتقاليد)
  final String type;
  final String text;
  const Block(this.type, this.text);
  factory Block.fromJson(Map<String, dynamic> j) =>
      Block(j['t'] as String, j['x'] as String);
}

class MeetingPage {
  final int page;
  final String title;
  final List<Block> blocks;
  const MeetingPage(this.page, this.title, this.blocks);
  factory MeetingPage.fromJson(Map<String, dynamic> j) => MeetingPage(
        j['page'] as int,
        j['title'] as String,
        (j['blocks'] as List)
            .map((e) => Block.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}

class DailyReading {
  final int month;
  final int day;
  final String title;
  final String quote;
  final String source;
  final List<String> body;
  final String jft; // رسالة "لليوم فقط"
  const DailyReading({
    required this.month,
    required this.day,
    required this.title,
    required this.quote,
    required this.source,
    required this.body,
    required this.jft,
  });
  factory DailyReading.fromJson(Map<String, dynamic> j) => DailyReading(
        month: j['month'] as int,
        day: j['day'] as int,
        title: j['title'] as String,
        quote: j['quote'] as String,
        source: j['source'] as String,
        body: (j['body'] as List).map((e) => e as String).toList(),
        jft: j['jft'] as String,
      );
}
