import 'package:simple_chat/features/home/domain/entities/friend.dart';

class FriendModel extends Friend {
  const FriendModel({required super.id, required super.name, super.avatarUrl});

  factory FriendModel.fromJson(Map<String, dynamic> json) {
    return FriendModel(
      id: json['friendId'] as String,
      name: json['friendName'] as String,
      avatarUrl: json['friendAvatarUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'friendId': id, 'friendName': name, 'friendAvatarUrl': avatarUrl};
  }
}
