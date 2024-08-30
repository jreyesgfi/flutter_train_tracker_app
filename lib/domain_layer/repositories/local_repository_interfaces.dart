abstract class LocalRepository {
  Future<List<String>> getLikedMuscles();
  Future<void> toggleMuscleLikeState(String muscleId);
}