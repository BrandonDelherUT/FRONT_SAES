class UserModel {

  final String? id;
  final String fullName;
  final String username;
  final String email;
  final String password;
  final DateTime dateOfBirth;
  final int? age;
  final String gender;
  final DateTime hireDate;
  final String position;
  final String phoneNumber;

  UserModel({
    this.id,
    required this.fullName,
    required this.username,
    required this.email,
    required this.password,
    required this.dateOfBirth,
    this.age,
    required this.gender,
    required this.hireDate,
    required this.position,
    required this.phoneNumber,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      fullName: json['fullName'],
      username: json['username'],
      email: json['email'],
      password: json['password'],
      dateOfBirth: DateTime.parse(json['dateOfBirth']),
      age: json['age'],
      gender: json['gender'],
      hireDate: DateTime.parse(json['hireDate']),
      position: json['position'],
      phoneNumber: json['phoneNumber'],
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'id': id,
      'fullName': fullName,
      'username': username,
      'email': email,
      'password': password,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'age': age,
      'gender': gender,
      'hireDate': hireDate.toIso8601String(),
      'position': position,
      'phoneNumber': phoneNumber
    };
  }

}