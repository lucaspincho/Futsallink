// Em packages/futsallink_firebase/lib/firestore/firestore_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../firebase_service.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseService().firestore;
  
  // Obter coleção
  CollectionReference collection(String path) {
    return _firestore.collection(path);
  }
  
  // Obter documento
  DocumentReference document(String path) {
    return _firestore.doc(path);
  }
  
  // Adicionar documento
  Future<DocumentReference> addDocument(String collection, Map<String, dynamic> data) {
    return _firestore.collection(collection).add(data);
  }
  
  // Definir documento
  Future<void> setDocument(String path, Map<String, dynamic> data, {bool merge = true}) {
    return _firestore.doc(path).set(data, SetOptions(merge: merge));
  }
  
  // Atualizar documento
  Future<void> updateDocument(String path, Map<String, dynamic> data) {
    return _firestore.doc(path).update(data);
  }
  
  // Excluir documento
  Future<void> deleteDocument(String path) {
    return _firestore.doc(path).delete();
  }
  
  // Obter documento uma vez
  Future<DocumentSnapshot> getDocument(String path) {
    return _firestore.doc(path).get();
  }
  
  // Obter stream de documento
  Stream<DocumentSnapshot> documentStream(String path) {
    return _firestore.doc(path).snapshots();
  }
  
  // Obter stream de coleção
  Stream<QuerySnapshot> collectionStream(String path, {
    List<List<dynamic>> whereConditions = const [],
    String? orderBy,
    bool descending = false,
    int? limit,
  }) {
    Query query = _firestore.collection(path);
    
    for (final condition in whereConditions) {
      query = query.where(
        condition[0], 
        isEqualTo: condition.length > 1 ? condition[1] : null,
        isGreaterThan: condition.length > 2 ? condition[2] : null,
        isLessThan: condition.length > 3 ? condition[3] : null,
      );
    }
    
    if (orderBy != null) {
      query = query.orderBy(orderBy, descending: descending);
    }
    
    if (limit != null) {
      query = query.limit(limit);
    }
    
    return query.snapshots();
  }
}