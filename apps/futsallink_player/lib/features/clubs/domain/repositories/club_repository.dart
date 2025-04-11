import '../models/club_details_model.dart';

abstract class ClubRepository {
  Future<ClubDetailsModel> getClubDetails(String clubId);
} 