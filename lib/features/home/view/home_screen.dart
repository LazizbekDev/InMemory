import 'package:flutter/material.dart';
import 'package:in_xotira/features/add_word/controller/word_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final wordProvider = Provider.of<WordProvider>(context, listen: false);

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
      body: FutureBuilder(
        future: wordProvider.loadWords(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Failed to load words'));
          }

          return Consumer<WordProvider>(
            builder: (context, provider, child) {
              return Column(
                children: [
                  Expanded(
                    child: provider.words.isEmpty
                        ? const Center(child: Text('No words added yet!'))
                        : ListView.builder(
                            itemCount: provider.words.length,
                            itemBuilder: (context, index) {
                              final word = provider.words[index];
                              return ListTile(
                                title: Text(word.word),
                                subtitle: Text(word.meaning),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    provider.deleteWord(index);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Word deleted'),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/training');
                    },
                    child: const Text('Start Training'),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
