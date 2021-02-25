import 'package:equatable/equatable.dart';
import 'package:game_manager/entities/entities.dart';

class UserDto extends Equatable {
  final String id;
  final String displayName;
  final String email;
  final String photoURL;
  final String phoneNumber;
  final String providerId;

  UserDto(
      {this.id,
        this.email,
        this.displayName = '',
        this.photoURL,
        this.phoneNumber,
        this.providerId});

  UserDto copyWith(
      {String id,
        String email,
        String displayName,
        String photoURL,
        String phoneNumber,
        String providerId}) {
    return UserDto(
        id: id ?? this.id,
        email: email ?? this.email,
        displayName: displayName ?? this.displayName,
        photoURL: photoURL ?? this.photoURL,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        providerId: providerId ?? this.providerId);
  }

  @override
  List<Object> get props =>
      [id, email, displayName, photoURL, phoneNumber, providerId];

  @override
  String toString() {
    return 'UserDto { '
        'email: $email, '
        'displayName: $displayName, '
        'photoURL: $photoURL, '
        'phoneNumber: $phoneNumber, '
        'providerId: $providerId, '
        'id: $id }';
  }

  bool get hasPhoto => this.photoURL != '' && this.photoURL != null;

  UserEntity toEntity() {
    return UserEntity(
        id: id,
        email: email,
        displayName: displayName,
        photoURL: photoURL,
        phoneNumber: phoneNumber,
        providerId: providerId);
  }

  static UserDto fromJson(Map<String, Object> json) {
    return UserDto(
        id: json['id'],
        email: json['email'],
        displayName: json['displayName'],
        photoURL: json['photoURL'],
        phoneNumber: json['phoneNumber'],
        providerId: json['providerId']);
  }

  static UserDto fromEntity(UserEntity entity) {
    return UserDto(
      id: entity.id,
      email: entity.email,
      displayName: entity.displayName,
      photoURL: entity.photoURL,
      phoneNumber: entity.phoneNumber,
      providerId: entity.providerId,
    );
  }
}
