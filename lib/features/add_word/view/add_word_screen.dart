import 'package:flutter/material.dart';
import 'package:in_xotira/features/add_word/controller/word_provider.dart';
import 'package:in_xotira/features/add_word/model/word.dart';
import 'package:provider/provider.dart';

class AddWordScreen extends StatefulWidget {
  const AddWordScreen({super.key});

  @override
  State<AddWordScreen> createState() => _AddWordScreenState();
}

class _AddWordScreenState extends State<AddWordScreen> {
  final _wordController = TextEditingController();
  final _meaningController = TextEditingController();

  @override
  void dispose() {
    _wordController.dispose();
    _meaningController.dispose();
    super.dispose();
  }

  void _addWord() {
    final word = _wordController.text.trim();
    final meaning = _meaningController.text.trim();

    if (word.isEmpty || meaning.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in both fields')),
      );
      return;
    }

    final newWord = Word(word: word, meaning: meaning);
    Provider.of<WordProvider>(context, listen: false).addWord(newWord);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Word added successfully')),
    );

    // Clear the fields
    _wordController.clear();
    _meaningController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Word'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _wordController,
              decoration: const InputDecoration(labelText: 'Word'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _meaningController,
              decoration: const InputDecoration(labelText: 'Meaning'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _addWord,
              child: const Text('Add Word'),
            ),
          ],
        ),
      ),
    );
  }
}
