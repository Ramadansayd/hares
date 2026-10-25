import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'data/recovery_store.dart';
import 'screens/home_screen.dart';
import 'screens/start_screen.dart';
import 'theme.dart';

void main() => runApp(const HaresApp());

class HaresApp extends StatelessWidget {
  const HaresApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'حارس',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      locale: const Locale('ar'),
      supportedLocales: const [Locale('ar')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const _Gate(),
    );
  }
}

/// لو تاريخ البداية محفوظ يفتح الرئيسية، غير كده يفتح شاشة الإهداء والبداية.
class _Gate extends StatelessWidget {
  const _Gate();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DateTime?>(
      future: RecoveryStore.load(),
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Scaffold(body: DecoratedBox(decoration: appBackground, child: SizedBox.expand()));
        }
        final start = snap.data;
        return start == null ? const StartScreen() : HomeScreen(start: start);
      },
    );
  }
}
