import 'package:flutter_application_test1/infrastructure_layer/config/local_database_helper.dart';

class LocalDataService {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<List<String>> getLikedMuscles() async {
    final db = await _dbHelper.database;
    final result = await db.query('liked_muscles');
    return result.map((row) => row['muscleId'] as String).toList();
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
}
