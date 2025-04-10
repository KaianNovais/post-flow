import 'package:post_flow/features/auth/domain/entities/user_entity.dart';

class PlaceholderUserModel extends UserEntity {
  const PlaceholderUserModel({
    required super.id,
    required super.email,
    super.displayName,
    super.photoUrl,
  });

  factory PlaceholderUserModel.fromJson(Map<String, dynamic> json) {
    return PlaceholderUserModel(
      id: json['id'].toString(), 
      email: json['email'] ?? '',
      displayName: json['name'] ?? json['username'] ?? 'Usuário',
      photoUrl: null, 
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
    };
  }
}