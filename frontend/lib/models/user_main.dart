import 'package:hive/hive.dart';

part 'user_main.g.dart';

@HiveType(typeId: 0)
class UserMain extends HiveObject {
  @HiveField(0)
  String userId;

  @HiveField(1)
  String email;

  @HiveField(2)
  String phoneNumber;

  UserMain({required this.userId, required this.email, required this.phoneNumber});

  // Copy method for updating specific fields
  UserMain copyWith({String? email, String? phoneNumber}) {
    return UserMain(
      userId: userId,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }
}
