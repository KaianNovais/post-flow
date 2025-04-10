import 'package:post_flow/features/auth/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    super.displayName,
    super.photoUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      email: json['email'] ?? '',
      displayName: json['name'],
      photoUrl: json['avatar'], // Assumindo que a API retorna um campo 'avatar'
    );
  }
}