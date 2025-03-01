import 'package:frontend/models/UserDTO.dart';
import 'package:hive/hive.dart';

part 'user_main.g.dart';

@HiveType(typeId: 0)
class UserMain extends HiveObject {
  @HiveField(0)
  String uid; // Firebase UID stored in Hive

  @HiveField(1)
  String firstName;

  @HiveField(2)
  String lastName;

  UserMain({
    required this.uid,
    required this.firstName,
    required this.lastName,
  });

  // Convert DTO to Hive Model
  factory UserMain.fromDTO(String uid, UserDTO dto) {
    return UserMain(
      uid: uid,
      firstName: dto.firstName,
      lastName: dto.lastName,
    );
  }

  get userId => null;

  UserMain copyWith({required String firstName, required String lastName}) {
    return UserMain(
      uid: this.uid,
      firstName: firstName,
      lastName: lastName,
    );
  }
}
