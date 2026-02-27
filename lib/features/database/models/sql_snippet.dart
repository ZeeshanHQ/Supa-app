class SqlSnippet {
  final String id;
  final String title;
  final String query;
  final String? description;
  final String category;

  const SqlSnippet({
    required this.id,
    required this.title,
    required this.query,
    this.description,
    required this.category,
  });

  SqlSnippet copyWith({
    String? id,
    String? title,
    String? query,
    String? description,
    String? category,
  }) {
    return SqlSnippet(
      id: id ?? this.id,
      title: title ?? this.title,
      query: query ?? this.query,
      description: description ?? this.description,
      category: category ?? this.category,
    );
  }
}
