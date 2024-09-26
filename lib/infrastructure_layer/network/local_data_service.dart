import 'package:gymini/infrastructure_layer/config/local_database_helper.dart';

class LocalDataService {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<List<String>> getLikedMuscles() async {
    final db = await _dbHelper.database;
    final result = await db.query('liked_muscles');
    return result.map((row) => row['muscleId'] as String).toList();
  }

  Future<List<String>> getLikedExercises() async {
    final db = await _dbHelper.database;
    final result = await db.query('liked_exercises');
    return result.map((row) => row['exerciseId'] as String).toList();
  }

  Future<void> toggleMuscleLikeState(String muscleId) async {
    final db = await _dbHelper.database;

    // Try to delete the muscle ID from the liked_muscles table
    int rowsAffected = await db.delete(
      'liked_muscles',
      where: 'muscleId = ?',
      whereArgs: [muscleId],
    );
    print("reached");
    // If no rows were deleted, it means the muscle ID was not liked, so we insert it
    if (rowsAffected == 0) {
      await db.insert('liked_muscles', {'muscleId': muscleId});
    }
  }

  Future<void> toggleExerciseLikeState(String exerciseId) async {
    final db = await _dbHelper.database;

    // Try to delete the exercise ID from the liked_exercises table
    int rowsAffected = await db.delete(
      'liked_exercises',
      where: 'exerciseId = ?',
      whereArgs: [exerciseId],
    );
    print("reached");
    // If no rows were deleted, it means the exercise ID was not liked, so we insert it
    if (rowsAffected == 0) {
      await db.insert('liked_exercises', {'exerciseId': exerciseId});
    }
  }
}
