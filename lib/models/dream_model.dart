import 'dart:convert';

class Dream {
  final int? id;
  final String title;
  final String desc;
  final String date;
  final double progress;
  final List<String> steps;

  Dream({
    this.id,
    required this.title,
    required this.desc,
    required this.date,
    required this.progress,
    required this.steps,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'desc': desc,
      'date': date,
      'progress': progress,
      'steps': jsonEncode(steps), // Simpan list sebagai JSON string
    };
  }

  factory Dream.fromMap(Map<String, dynamic> map) {
    return Dream(
      id: map['id'],
      title: map['title'],
      desc: map['desc'],
      date: map['date'],
      progress: (map['progress'] as num).toDouble(),
      steps: (map['steps'] != null && map['steps'] is String)
          ? List<String>.from(jsonDecode(map['steps']))
          : [],
    );
  }
}
