import '../../domain/entities/user_preview.dart';

class UserPreviewModel extends UserPreview {
  const UserPreviewModel({
    required super.id,
    required super.name,
    super.avatarUrl,
  });

  factory UserPreviewModel.fromJson(Map<String, dynamic> json) {
    return UserPreviewModel(
      id: json['id'] as String,
      name: json['name'] as String,
      avatarUrl: json['avatarUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'avatarUrl': avatarUrl};
  }
}
