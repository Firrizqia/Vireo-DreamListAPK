class UserModel {
  int? id;
  String name;
  String username;
  String email;
  String age;
  String gender;
  String motto;
  String profileImagePath;


  UserModel({
    this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.age,
    required this.gender,
    required this.motto,
    required this.profileImagePath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'email': email,
      'age': age,
      'gender': gender,
      'motto': motto,
      'profileImagePath': profileImagePath,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      name: map['name'],
      username: map['username'],
      email: map['email'],
      age: map['age'],
      gender: map['gender'],
      motto: map['motto'],
      profileImagePath: map['profileImagePath'] ?? '',
    );
  }
}
