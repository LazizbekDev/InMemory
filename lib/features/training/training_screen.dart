import 'dart:convert';
import 'dart:math';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flip_card/flip_card.dart';

class TrainingScreen extends StatefulWidget {
  const TrainingScreen({super.key});

  @override
  State<TrainingScreen> createState() => _TrainingScreenState();
}

class _TrainingScreenState extends State<TrainingScreen> {
  List<Map<String, String>> words = [];
  List<Map<String, String>> displayedWords = [];
  List<FlipCardController> controllers = [];
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    _loadWordsFromPreferences();
  }

  Future<void> _loadWordsFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final storedWords = prefs.getString('words') ?? '[]';
    final List<dynamic> decodedWords = jsonDecode(storedWords);

    setState(() {
      words =
          decodedWords.map((word) => Map<String, String>.from(word)).toList();
      _loadPageWords();
    });
  }

  void _loadPageWords() {
    setState(() {
      int startIndex = currentPage * 15;
      int endIndex = min(startIndex + 15, words.length);
      displayedWords = words.sublist(startIndex, endIndex);
      _initializeControllers();
    });
  }

  void _initializeControllers() {
    controllers = List.generate(
      displayedWords.length,
      (_) => FlipCardController(),
    );
  }

  void _shuffleWords() {
    setState(() {
      displayedWords.shuffle();
      _initializeControllers();
    });
  }

  void _nextPage() {
    if ((currentPage + 1) * 15 < words.length) {
      setState(() {
        currentPage++;
        _loadPageWords();
      });
    }
  }

  void _previousPage() {
    if (currentPage > 0) {
      setState(() {
        currentPage--;
        _loadPageWords();
      });
    }
  }

  void _resetAllCards() {
    for (var controller in controllers) {
      if (controller.state?.isFront == false) {
        controller.toggleCard(); // Reset flipped cards to the front
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Training'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shuffle),
            onPressed: () {
              _resetAllCards();
              _shuffleWords();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 8.0,
                childAspectRatio: 1.5,
              ),
              itemCount: displayedWords.length,
              itemBuilder: (context, index) {
                final word = displayedWords[index]['word']!;
                final meaning = displayedWords[index]['meaning']!;
                return _buildFlipCard(word, meaning, controllers[index]);
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (currentPage > 0)
                TextButton(
                  onPressed: () {
                    _resetAllCards();
                    _previousPage();
                  },
                  child: const Text('Previous'),
                ),
              if ((currentPage + 1) * 15 < words.length)
                TextButton(
                  onPressed: () {
                    _resetAllCards();
                    _nextPage();
                  },
                  child: const Text('Next'),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFlipCard(
      String word, String meaning, FlipCardController controller) {
    return FlipCard(
      controller: controller,
      front: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Center(
          child: Text(
            word,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      back: Card(
        color: Colors.amber,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Center(
          child: Text(
            meaning,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
