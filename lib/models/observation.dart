class Observation {
  int? id;
  String name;
  String date;

  Observation({this.id, required this.name, required this.date});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'date': date,
    };
  }

  factory Observation.fromMap(Map<String, dynamic> map) {
    return Observation(
      id: map['id'],
      name: map['name'],
      date: map['date'],
    );
  }
}