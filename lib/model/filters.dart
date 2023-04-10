class Filters {
  final List<String> filters;
  const Filters({required this.filters});

  factory Filters.fromJson(List<dynamic> json) {
    return Filters(
      filters: List<String>.from(json),
    );
  }
}
