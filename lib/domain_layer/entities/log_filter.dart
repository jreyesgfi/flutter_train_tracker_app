
import 'package:gymini/domain_layer/entities/core_entities.dart';
import 'package:tuple/tuple.dart';
import 'package:gymini/utils/helpers/copy_with.dart';

class LogFilter {
  final Tuple2<DateTime?, DateTime?>? timeRange;
  final MuscleEntity? musclePicked;
  final ExerciseEntity? exercisePicked;

  const LogFilter({
    this.timeRange,
    this.musclePicked,
    this.exercisePicked,
  });

  LogFilter copyWith({
    Object? timeRange      = copyWithUnset,
    Object? musclePicked   = copyWithUnset,
    Object? exercisePicked = copyWithUnset,
  }) {
    return LogFilter(
      timeRange:      valueOrCurrent(timeRange,       this.timeRange),
      musclePicked:   valueOrCurrent(musclePicked,    this.musclePicked),
      exercisePicked: valueOrCurrent(exercisePicked,  this.exercisePicked),
    );
  }
}
