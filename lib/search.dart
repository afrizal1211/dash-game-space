class GameSearch {
  const GameSearch({required this.entries});

  final List<String> entries;

  List<String> run(String query) {
    if (query.trim().isEmpty) return entries;
    final String needle = query.toLowerCase();
    return entries
        .where((String entry) => entry.toLowerCase().contains(needle))
        .toList(growable: false);
  }
}
