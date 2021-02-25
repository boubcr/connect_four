import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserEntity extends Equatable {
  final String id;
  final String displayName;
  final String email;
  final String photoURL;
  final String phoneNumber;
  final String providerId;

  UserEntity(
      {this.id,
        this.email,
        this.displayName,
        this.photoURL,
        this.phoneNumber,
        this.providerId});

  @override
  List<Object> get props =>
      [id, email, displayName, photoURL, phoneNumber, providerId];

  @override
  String toString() {
    return 'UserEntity { '
        'email: $email, '
        'displayName: $displayName, '
        'photoURL: $photoURL, '
        'phoneNumber: $phoneNumber, '
        'providerId: $providerId, '
        'id: $id }';
  }

  static UserEntity fromSnapshot(DocumentSnapshot snap) {
    final map = snap.data();
    return UserEntity(
        id: map['id'],
        email: map['email'],
        displayName: map['displayName'],
        photoURL: map['photoURL'],
        providerId: map['providerId'],
        phoneNumber: map['phoneNumber']);
  }

  Map<String, Object> toDocument() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL,
      'providerId': providerId,
      'phoneNumber': phoneNumber
    };
  }
}
