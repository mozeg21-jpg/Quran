class Reciter {
  final String id;
  final String name;
  final String server;
  final String rewaya;
  final int count;

  Reciter({
    required this.id,
    required this.name,
    required this.server,
    required this.rewaya,
    required this.count,
  });

  factory Reciter.fromJson(Map<String, dynamic> json) {
    return Reciter(
      id: json['id']?.toString() ?? '',
      name: json['name'] as String? ?? '',
      server: json['Server'] as String? ?? json['server'] as String? ?? '',
      rewaya: json['rewaya'] as String? ?? 'حفص عن عاصم',
      count: int.tryParse(json['count']?.toString() ?? '0') ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'server': server,
      'rewaya': rewaya,
      'count': count,
    };
  }
}
