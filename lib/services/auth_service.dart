import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Retorna o usuário atual
  User? get currentUser => _auth.currentUser;

  // Stream para ouvir mudanças no estado de autenticação
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Cadastrar novo usuário
  Future<String?> registerUser({
    required String name,
    required String cpf,
    required String phone,
    required String email,
    required String password,
  }) async {
    try {
      // Criar usuário no Firebase Auth
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      // Salvar dados adicionais no Firestore na coleção 'clients'
      await _firestore.collection('clients').doc(userCredential.user!.uid).set({
        'name': name,
        'cpf': cpf,
        'phone': phone,
        'e-mail': email,
        'password':
            password, // Nota: em produção, não salve a senha em texto plano
      });

      return null; // Sucesso, sem erro
    } on FirebaseAuthException catch (e) {
      return _getErrorMessage(e.code);
    } catch (e) {
      return 'Erro ao cadastrar: $e';
    }
  }

  // Login com email e senha
  Future<String?> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null; // Sucesso, sem erro
    } on FirebaseAuthException catch (e) {
      return _getErrorMessage(e.code);
    } catch (e) {
      return 'Erro ao fazer login: $e';
    }
  }

  // Logout
  Future<void> logout() async {
    await _auth.signOut();
  }

  // Buscar dados do usuário no Firestore
  Future<Map<String, dynamic>?> getUserData() async {
    try {
      if (currentUser == null) return null;

      DocumentSnapshot doc = await _firestore
          .collection('clients')
          .doc(currentUser!.uid)
          .get();

      if (doc.exists) {
        return doc.data() as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      print('Erro ao buscar dados do usuário: $e');
      return null;
    }
  }

  // Converter códigos de erro para mensagens amigáveis
  String _getErrorMessage(String code) {
    switch (code) {
      case 'weak-password':
        return 'A senha é muito fraca. Use pelo menos 6 caracteres.';
      case 'email-already-in-use':
        return 'Este e-mail já está cadastrado.';
      case 'invalid-email':
        return 'E-mail inválido.';
      case 'user-not-found':
        return 'Usuário não encontrado.';
      case 'wrong-password':
        return 'Senha incorreta.';
      case 'invalid-credential':
        return 'E-mail ou senha incorretos.';
      case 'user-disabled':
        return 'Esta conta foi desativada.';
      case 'too-many-requests':
        return 'Muitas tentativas. Tente novamente mais tarde.';
      default:
        return 'Erro: $code';
    }
  }

  // Atualizar perfil do usuário
  Future<void> updateUserProfile({
    required String name,
    required String phone,
  }) async {
    try {
      if (currentUser == null) throw Exception('Usuário não logado');

      await _firestore.collection('clients').doc(currentUser!.uid).update({
        'name': name,
        'phone': phone,
      });
    } catch (e) {
      throw Exception('Erro ao atualizar perfil: $e');
    }
  }
}
