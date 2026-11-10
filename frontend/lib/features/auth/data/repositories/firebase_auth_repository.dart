import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show debugPrint;

import '../../domain/entities/app_user.dart';
import '../../domain/errors/auth_failure.dart';
import '../../domain/repositories/auth_repository.dart';

/// Implementacao do [AuthRepository] com Firebase Authentication e o perfil
/// do usuario guardado na colecao `users` do Firestore.
class FirebaseAuthRepository implements AuthRepository {
  FirebaseAuthRepository({FirebaseAuth? auth, FirebaseFirestore? firestore})
    : _auth = auth ?? FirebaseAuth.instance,
      _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _users =>
      _firestore.collection('users');

  @override
  Stream<AppUser?> get authStateChanges => _auth.authStateChanges().map(
    (user) => user == null ? null : _toAppUser(user),
  );

  @override
  AppUser? get currentUser {
    final user = _auth.currentUser;
    return user == null ? null : _toAppUser(user);
  }

  @override
  Future<AppUser> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user;
      if (user == null) {
        throw const AuthFailure('Não foi possível entrar. Tente novamente.');
      }
      await _recordLogin(user);
      return _toAppUser(user);
    } on FirebaseAuthException catch (error) {
      throw _translate(error);
    }
  }

  @override
  Future<AppUser> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user;
      if (user == null) {
        throw const AuthFailure(
          'Não foi possível criar a conta. Tente novamente.',
        );
      }
      if (name.isNotEmpty) {
        await user.updateDisplayName(name);
      }
      await _saveProfile(user, name);
      return _toAppUser(user);
    } on FirebaseAuthException catch (error) {
      throw _translate(error);
    }
  }

  @override
  Future<AppUser> signInAnonymously() async {
    try {
      final credential = await _auth.signInAnonymously();
      final user = credential.user;
      if (user == null) {
        throw const AuthFailure('Não foi possível continuar sem cadastro.');
      }
      return _toAppUser(user);
    } on FirebaseAuthException catch (error) {
      throw _translate(error);
    }
  }

  @override
  Future<void> sendPasswordReset({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (error) {
      throw _translate(error);
    }
  }

  @override
  Future<void> signOut() => _auth.signOut();

  AppUser _toAppUser(User user) => AppUser(
    uid: user.uid,
    email: user.email,
    displayName: user.displayName,
    isAnonymous: user.isAnonymous,
  );

  /// Perfil do usuario no Firestore. O cadastro nao falha se o Firestore
  /// estiver inacessivel: o Authentication e a fonte da verdade.
  Future<void> _saveProfile(User user, String name) async {
    try {
      await _users.doc(user.uid).set({
        'uid': user.uid,
        'email': user.email,
        'displayName': name,
        'isAnonymous': user.isAnonymous,
        'createdAt': FieldValue.serverTimestamp(),
        'lastLoginAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (error) {
      debugPrint('Falha ao salvar o perfil no Firestore: $error');
    }
  }

  Future<void> _recordLogin(User user) async {
    try {
      await _users.doc(user.uid).set({
        'uid': user.uid,
        'lastLoginAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (error) {
      debugPrint('Falha ao registrar o acesso no Firestore: $error');
    }
  }

  AuthFailure _translate(FirebaseAuthException error) => AuthFailure(
    switch (error.code) {
      'invalid-email' => 'O e-mail digitado não é válido.',
      'user-not-found' ||
      'wrong-password' ||
      'invalid-credential' => 'E-mail ou senha incorretos.',
      'user-disabled' => 'Esta conta foi desativada. Fale com o suporte.',
      'email-already-in-use' => 'Já existe uma conta com este e-mail.',
      'weak-password' => 'A senha é muito fraca. Use pelo menos 8 caracteres.',
      'network-request-failed' =>
        'Confira a conexão com a internet e tente '
            'novamente.',
      'too-many-requests' =>
        'Muitas tentativas. Aguarde alguns instantes e '
            'tente novamente.',
      'operation-not-allowed' =>
        'Este tipo de acesso não está liberado no '
            'projeto.',
      _ => 'Não foi possível concluir agora. Tente novamente.',
    },
  );
}
