// mentor_dto.dart
class Mentor {
  final String id;
  final String? name;
  final String email;
  final String role;
  final String? skill;
  final String? occupation;
  final String? bio;
  final String createdAt;
  final String updatedAt;

  Mentor({
    required this.id,
    this.name,
    required this.email,
    required this.role,
    this.skill,
    this.occupation,
    this.bio,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Mentor.fromJson(Map<String, dynamic> json) {
    try {
      return Mentor(
        id: json['_id']?.toString() ?? '',
        name: json['name']?.toString(),
        email: json['email']?.toString() ?? '',
        role: json['role']?.toString() ?? '',
        skill: json['skill']?.toString(),
        occupation: json['occupation']?.toString(),
        bio: json['bio']?.toString(),
        createdAt: json['createdAt']?.toString() ?? '',
        updatedAt: json['updatedAt']?.toString() ?? '',
      );
    } catch (e) {
      print('Error parsing mentor: $e');
      print('Problematic JSON: $json');
      rethrow;
    }
  }
}