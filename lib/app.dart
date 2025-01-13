import 'package:flutter/material.dart';
import 'package:in_xotira/features/add_word/controller/word_provider.dart';
import 'package:in_xotira/features/add_word/view/add_word_screen.dart';
import 'package:in_xotira/features/home/view/home_screen.dart';
import 'package:in_xotira/features/training/training_screen.dart';
import 'package:provider/provider.dart';

class MemorizeWordsApp extends StatelessWidget {
  const MemorizeWordsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => WordProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Memorize Words',
        initialRoute: '/',
        routes: {
          '/': (context) => const HomeScreen(),
          '/add_word': (context) => const AddWordScreen(),
          '/training': (context) => const TrainingScreen(),
        },
      ),
    );
  }
}
