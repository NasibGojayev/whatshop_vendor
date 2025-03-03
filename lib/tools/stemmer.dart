import 'dart:async';
import 'package:flutter/services.dart';

class Stemmer {
  late Set<String> words;
  late List<String> suffixes;

  Stemmer();

  // Loads words and suffixes asynchronously
  Future<void> loadResources() async {
    words = (await _loadFile('assets/words.txt')).toSet();
    suffixes = (await _loadFile('assets/suffix.txt'))..sort((a, b) => b.length.compareTo(a.length)); // Sort suffixes longest first
  }

  // Helper method to load a file and split it into lines
  Future<List<String>> _loadFile(String path) async {
    final fileContent = await rootBundle.loadString(path);
    return fileContent.split('\n').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
  }

  // Converts specific suffix variations to their root forms
  String _convert(String word) {
    const replacements = {
      'lığ': 'q', 'luğ': 'q', 'lağ': 'q', 'cığ': 'q',
      'liy': 'k', 'lüy': 'k', 'cağ': 'q', 'cəy': 'k',
      'ığ': 'q', 'uğ': 'q', 'ağ': 'q', 'iy': 'k',
      'üy': 'k', 'əy': 'k'
    };

    for (final suffix in replacements.keys) {
      if (word.endsWith(suffix)) {
        return word.substring(0, word.length - suffix.length) + replacements[suffix]!;
      }
    }

    // Handle special cases
    if (word == 'ed') return 'et';
    if (word == 'ged') return 'get';

    return word;
  }

  // Iteratively removes suffixes to find the longest possible root word
  String _removeSuffixes(String word) {
    for (final suffix in suffixes) {
      if (word.endsWith(suffix)) {
        final stemmed = word.substring(0, word.length - suffix.length);
        if (words.contains(stemmed)) return stemmed;
      }
    }
    return word;
  }

  // Returns the best stemmed version of a word
  String stemWord(String word) {
    word = word.toLowerCase();
    word = _convert(word);
    return words.contains(word) ? word : _removeSuffixes(word);
  }

  // Stems a list of words efficiently
  List<String> stemWords(List<String> listOfWords) {
    return listOfWords.map(stemWord).toList();
  }
}