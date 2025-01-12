import 'package:flutter/material.dart';
import 'package:in_xotira/features/add_word/controller/word_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final wordProvider = Provider.of<WordProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Memorize Words'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, '/add_word');
            },
          ),
        ],
      ),
      body: wordProvider.words.isEmpty
          ? const Center(
              child: Text('No words added yet!'),
            )
          : ListView.builder(
              itemCount: wordProvider.words.length,
              itemBuilder: (context, index) {
                final word = wordProvider.words[index];
                return ListTile(
                  title: Text(word.word),
                  subtitle: Text(word.meaning),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      wordProvider.deleteWord(index);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Word deleted')),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
