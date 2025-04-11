import '../models/tryout_details_model.dart';

abstract class TryoutRepository {
  Future<TryoutDetailsModel> getTryoutDetails(String tryoutId);
} 