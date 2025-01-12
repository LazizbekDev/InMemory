import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:in_xotira/features/add_word/model/word.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WordProvider extends ChangeNotifier {
  final List<Word> _words = [];

  List<Word> get words => _words;

  Future<void> loadWords() async {
    final prefs = await SharedPreferences.getInstance();
    final wordsString = prefs.getString('words');
    if (wordsString != null) {
      final List<dynamic> wordsJson = jsonDecode(wordsString);
      _words.clear();
      _words.addAll(wordsJson.map((json) => Word.fromJson(json)));
      notifyListeners();
    }
  }

  Future<void> addWord(Word word) async {
    _words.add(word);
    notifyListeners();
    await _saveWords();
  }

  Future<void> deleteWord(int index) async {
    _words.removeAt(index);
    notifyListeners();
    await _saveWords();
  }

  // SharedPreferences-ga saqlash
  Future<void> _saveWords() async {
    final prefs = await SharedPreferences.getInstance();
    final wordsJson = _words.map((word) => word.toJson()).toList();
    prefs.setString('words', jsonEncode(wordsJson));
  }
}
