import 'package:users_api_deneme/models/user_location.dart';

class Users{
    final UserName name;
    final String gender;
    final String nat;
    final String email;
    final String phone;
    final UserLocation location;
    final UserDob dob;
    final UserPicture picture;

  Users({required this.name,
  required this.gender, 
  required this.nat,
  required this.email, 
  required this.phone,
  required this.location,
  required this.dob,
  required this.picture});
}

class UserName{
  final String title;
  final String first;
  final String last;

  UserName({required this.title, required this.first, required this.last});
}

class UserDob{
  final DateTime date;
  final int age;

  UserDob({required this.date, required this.age});
  
}

class UserPicture{
  final String large;
  final String thumbnail;

  UserPicture({required this.large, required this.thumbnail});
}