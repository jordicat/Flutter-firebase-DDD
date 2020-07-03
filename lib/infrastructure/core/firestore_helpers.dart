import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase_ddd_notes/domain/auth/i_auth_facade.dart';
import 'package:flutter_firebase_ddd_notes/domain/core/errors.dart';

import '../../injection.dart';

extension FirestoreX on Firestore {
  Future<DocumentReference> userDocument() async {
    final userOption = await getIt<IAuthFacade>().getSignedInUser();
    final user = userOption.getOrElse(() => throw NotAuthenticatedError());
    return Firestore.instance
        .collection('users')
        .document(user.id.getOrCrash().toString());
  }
}

extension DocumentReferenceX on DocumentReference {
  CollectionReference get noteCollection => collection('notes');
}
