import 'package:equatable/equatable.dart';

class UserPreview extends Equatable {
  final String id;
  final String name;
  final String? avatarUrl;

  const UserPreview({required this.id, required this.name, this.avatarUrl});

  @override
  List<Object?> get props => [id, name, avatarUrl];
}
