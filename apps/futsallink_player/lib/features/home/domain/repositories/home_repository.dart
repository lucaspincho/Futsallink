import '../models/club_model.dart';
import '../models/tryout_model.dart';

abstract class HomeRepository {
  Future<List<ClubModel>> getClubs();
  Future<List<TryoutModel>> getTryouts();
} 