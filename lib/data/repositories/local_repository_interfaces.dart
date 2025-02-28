abstract class LocalRepository {
  Future<List<String>> getLikedMuscles();
  Future<List<String>> getLikedExercises();
  Future<void> toggleMuscleLikeState(String muscleId);
  Future<void> toggleExerciseLikeState(String exerciseId);
}