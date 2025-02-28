import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymini/domain_layer/entities/core_entities.dart';
import 'package:gymini/domain_layer/entities/session_info.dart';
import 'package:gymini/data/repositories/local_data_repository_impl.dart';
import 'package:gymini/infrastructure_layer/repository_impl/muscle_repository_impl.dart';
import 'package:gymini/data/repositories/session_repository_impl.dart';
import 'package:gymini/presentation_layer/services/training_data_transformer.dart';
import 'package:gymini/presentation_layer/widgets/training_selection/muscle_tile.dart';
import 'package:gymini/presentation_layer/widgets/training_selection/exercise_tile.dart';

final sessionDataToTileServiceProvider =
    Provider((ref) => SessionDataToTileService(ref));

class SessionDataToTileService {
  final Ref ref;

  SessionDataToTileService(this.ref);

  Future<List<MuscleTileSchema>> getMuscleTiles() async {
    final muscles = await ref.read(muscleRepositoryProvider).fetchAllMuscles();
    final likedMuscles =
        await ref.read(localRepositoryProvider).getLikedMuscles();
    final Map<String, DateTime?> lastTrainingTimes = (await ref.read(sessionRepositoryProvider)
        .fetchLastSessionsByMuscleIds())
        .map((muscleId, session) => MapEntry(muscleId, session.timeStamp));

    final List<MuscleTileSchema> muscleTiles = muscles.map((muscle)=> TrainingDataTransformer.transformMuscleToTile(
      muscle,
      lastTrainingTimes[muscle.id],
      likedMuscles
    )).toList();

    muscleTiles.sort((a, b) => b.timeSinceExercise.compareTo(a.timeSinceExercise));

    return muscleTiles;
  }

  Future<List<ExerciseTileSchema>> getExerciseTilesForMuscle(
      String muscleId) async {
    final exercises =
        await ref.read(sessionRepositoryProvider).fetchExercisesByMuscleId(
              muscleId,
            );
    final likedExercises =
        await ref.read(localRepositoryProvider).getLikedExercises();
    final lastTrainingTimes =
        await ref.read(sessionRepositoryProvider).fetchLastSessionsByExerciseIds(
              exercises.map((e) => e.id).toList(),
            );

    return exercises.map((exercise) {
      return ExerciseTileSchema(
        id: exercise.id,
        name: exercise.name,
        muscleId: exercise.muscleId,
        lastTrained: lastTrainingTimes[exercise.id]?.timeStamp,
        isLiked: likedExercises.contains(exercise.id),
      );
    }).toList();
  }


  Future<MuscleEntity> getMuscleById(String muscleId) async {
    return await ref.read(muscleRepositoryProvider).fetchMuscleById(muscleId);
  }

  

  Future<ExerciseEntity> getExerciseById(String exerciseId, String muscleId) async {
    return await ref
        .read(sessionRepositoryProvider)
        .fetchExerciseById(exerciseId, muscleId);
  }

  Future<SessionInfoSchema> getSessionSummaryForExercise(String exerciseId) async {
    final session =
        await ref.read(sessionRepositoryProvider).fetchLastSessionByExerciseId(
              exerciseId,
            );

    return SessionInfoSchema(
      exerciseName: session.exerciseId,
      muscleName: session.muscleId,
      lastTrained: session.timeStamp,
      maxWeight: session.maxWeight,
    );
  }

  Future<SessionEntity> createDefaultSession(
      String exerciseId, SessionValues sessionValues) async {
    return SessionEntity(
      id: sessionValues.id,
      exerciseId: exerciseId,
      muscleId: sessionValues.muscleId,
      timeStamp: DateTime.now(),
      maxWeight: sessionValues.maxWeight,
      minWeight: sessionValues.minWeight,
      maxReps: sessionValues.maxReps,
      minReps: sessionValues.minReps,
    );
  }

  Future<void> commitSession(SessionEntity session) async {
    await ref.read(sessionRepositoryProvider).createNewSession(session);
  }
}
