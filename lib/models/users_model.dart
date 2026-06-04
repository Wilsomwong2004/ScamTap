class UserModel {
  final String uid;
  final String username;
  final String email;

  UserModel({
    required this.uid,
    required this.username,
    required this.email,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      username: map['Username'] ?? 'User',
      email: map['email'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'Username': username,
      'email': email,
    };
  }
}