enum UserType { instructor, student }

class UserSocketModel {
  final int id;
  final String name;
  final String type; // 'instructor' or 'student'
  final int sessionId;

  bool get isInstructor => Type == 'instructor';
  bool get isStudent => Type == 'student';

  const UserSocketModel({
    required this.id,
    required this.name,
    required this.type,
    required this.sessionId,
  });
}
