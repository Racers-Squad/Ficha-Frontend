class Course {
  final String short_name;
  final double course;

  Course({required this.short_name, required this.course});

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(short_name: json['short_name'], course: json['course']);
  }
}
