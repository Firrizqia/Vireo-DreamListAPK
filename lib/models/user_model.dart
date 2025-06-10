class UserModel {
  int? id;
  String name;
  String username;
  String email;
  String age;
  String gender;

  UserModel({
    this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.age,
    required this.gender,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'email': email,
      'age': age,
      'gender': gender,
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
    );
  }
}
