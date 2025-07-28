// Add this model class for User data
class User {
  final String id;
  final String name;
  final String email;
  final String phoneNumber;
  final String? profileImage;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    this.profileImage,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      name: json['Name'] ?? '',
      email: json['Email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      profileImage: json['ProfileImage'],
    );
  }
}
