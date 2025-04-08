import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:futsallink_core/futsallink_core.dart';
import 'package:futsallink_firebase/futsallink_firebase.dart';
import 'package:futsallink_player/features/profile/data/models/player_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class PlayerRemoteDataSource {
  Future<PlayerModel> createPlayer(PlayerModel player);
  Future<PlayerModel> updatePlayer(PlayerModel player);
  Future<PlayerModel> getPlayer(String uid);
  Future<String> uploadProfileImage(String uid, File imageFile);
  Future<bool> checkProfileExists(String uid);
  Future<bool> completePlayerProfile(String uid);
}

class PlayerRemoteDataSourceImpl implements PlayerRemoteDataSource {
  final FirestoreService firestoreService;
  final FirebaseStorage firebaseStorage;

  PlayerRemoteDataSourceImpl({
    required this.firestoreService,
    required this.firebaseStorage,
  });

  @override
  Future<PlayerModel> createPlayer(PlayerModel player) async {
    // Verificar se o jogador já existe
    final existingDoc = await firestoreService.getDocument('players/${player.uid}');

    if (existingDoc.exists) {
      throw Exception('Perfil de jogador já existe');
    }

    // Cria o documento com os dados do jogador
    await firestoreService.setDocument(
      'players/${player.uid}',
      player.toJson(),
    );

    return player;
  }

  @override
  Future<PlayerModel> updatePlayer(PlayerModel player) async {
    await firestoreService.updateDocument(
      'players/${player.uid}',
      player.toJson(),
    );

    return player;
  }

  @override
  Future<PlayerModel> getPlayer(String uid) async {
    print('[PlayerRemoteDataSource] Iniciando busca do jogador: $uid');
    final doc = await firestoreService.getDocument('players/$uid');

    if (!doc.exists) {
      print('[PlayerRemoteDataSource] Documento não encontrado para o jogador: $uid');
      throw Exception('Perfil de jogador não encontrado');
    }

    print('[PlayerRemoteDataSource] Documento encontrado, convertendo para PlayerModel');
    final player = PlayerModel.fromJson(doc.data() as Map<String, dynamic>);
    print('[PlayerRemoteDataSource] PlayerModel criado com sucesso: ${player.uid}');
    return player;
  }

  @override
  Future<String> uploadProfileImage(String uid, File imageFile) async {
    try {
      print('[PlayerRemoteDataSource] Iniciando upload de imagem para usuário: $uid');
      print('[PlayerRemoteDataSource] Verificando autenticação do usuário...');
      
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        print('[PlayerRemoteDataSource] Usuário não está autenticado');
        throw Exception('Usuário não está autenticado');
      }
      
      print('[PlayerRemoteDataSource] Usuário autenticado: ${currentUser.uid}');
      print('[PlayerRemoteDataSource] Tentando fazer upload para: players/$uid/profile_image');
      
      final ref = firebaseStorage.ref().child('players/$uid/profile_image');
      final uploadTask = await ref.putFile(imageFile);
      final downloadUrl = await uploadTask.ref.getDownloadURL();

      print('[PlayerRemoteDataSource] Upload concluído com sucesso');
      print('[PlayerRemoteDataSource] URL da imagem: $downloadUrl');

      // Verificar se o documento existe
      final docRef = firestoreService.document('players/$uid');
      final docSnapshot = await docRef.get();

      if (!docSnapshot.exists) {
        print('[PlayerRemoteDataSource] Documento não existe, criando novo');
        // Criar documento com dados básicos
        await docRef.set({
          'uid': uid,
          'profileImage': downloadUrl,
          'createdAt': DateTime.now().toIso8601String(),
          'updatedAt': DateTime.now().toIso8601String(),
        });
      } else {
        print('[PlayerRemoteDataSource] Documento existe, atualizando');
        // Atualizar apenas a URL da imagem
        await docRef.update({
          'profileImage': downloadUrl,
          'updatedAt': DateTime.now().toIso8601String(),
        });
      }

      return downloadUrl;
    } catch (e) {
      print('[PlayerRemoteDataSource] Erro durante o upload: $e');
      throw Exception('Falha ao fazer upload da imagem: $e');
    }
  }

  @override
  Future<bool> checkProfileExists(String uid) async {
    try {
      final doc = await firestoreService.getDocument('players/$uid');
      return doc.exists;
    } catch (e) {
      throw Exception('Erro ao verificar perfil: $e');
    }
  }

  @override
  Future<bool> completePlayerProfile(String uid) async {
    try {
      await firestoreService.updateDocument(
        'players/$uid',
        {
          'profileCompleted': true,
          'completionStatus': 2, // Valor de ProfileCompletionStatus.complete
          'updatedAt': DateTime.now().toIso8601String(),
        },
      );
      return true;
    } catch (e) {
      throw Exception('Erro ao completar perfil: $e');
    }
  }
} 