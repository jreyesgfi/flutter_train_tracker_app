/*
* Copyright 2021 Amazon.com, Inc. or its affiliates. All Rights Reserved.
*
* Licensed under the Apache License, Version 2.0 (the "License").
* You may not use this file except in compliance with the License.
* A copy of the License is located at
*
*  http://aws.amazon.com/apache2.0
*
* or in the "license" file accompanying this file. This file is distributed
* on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
* express or implied. See the License for the specific language governing
* permissions and limitations under the License.
*/

// NOTE: This file is generated and may not follow lint rules defined in your app
// Generated files can be excluded from analysis in analysis_options.yaml
// For more info, see: https://dart.dev/guides/language/analysis-options#excluding-code-from-analysis

// ignore_for_file: public_member_api_docs, annotate_overrides, dead_code, dead_codepublic_member_api_docs, depend_on_referenced_packages, file_names, library_private_types_in_public_api, no_leading_underscores_for_library_prefixes, no_leading_underscores_for_local_identifiers, non_constant_identifier_names, null_check_on_nullable_type_parameter, override_on_non_overriding_member, prefer_adjacent_string_concatenation, prefer_const_constructors, prefer_if_null_operators, prefer_interpolation_to_compose_strings, slash_for_doc_comments, sort_child_properties_last, unnecessary_const, unnecessary_constructor_name, unnecessary_late, unnecessary_new, unnecessary_null_aware_assignments, unnecessary_nullable_for_final_variable_declarations, unnecessary_string_interpolations, use_build_context_synchronously

import 'ModelProvider.dart';
import 'package:amplify_core/amplify_core.dart' as amplify_core;


/** This is an auto generated class representing the Exercise type in your schema. */
class Exercise extends amplify_core.Model {
  static const classType = const _ExerciseModelType();
  final String id;
  final String? _userId;
  final amplify_core.TemporalDate? _date;
  final String? _muscle;
  final String? _exercise;
  final double? _maxWeight;
  final double? _minWeight;
  final int? _maxReps;
  final int? _minReps;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  ExerciseModelIdentifier get modelIdentifier {
      return ExerciseModelIdentifier(
        id: id
      );
  }
  
  String get userId {
    try {
      return _userId!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  amplify_core.TemporalDate get date {
    try {
      return _date!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get muscle {
    try {
      return _muscle!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get exercise {
    try {
      return _exercise!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  double? get maxWeight {
    return _maxWeight;
  }
  
  double? get minWeight {
    return _minWeight;
  }
  
  int? get maxReps {
    return _maxReps;
  }
  
  int? get minReps {
    return _minReps;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const Exercise._internal({required this.id, required userId, required date, required muscle, required exercise, maxWeight, minWeight, maxReps, minReps, createdAt, updatedAt}): _userId = userId, _date = date, _muscle = muscle, _exercise = exercise, _maxWeight = maxWeight, _minWeight = minWeight, _maxReps = maxReps, _minReps = minReps, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory Exercise({String? id, required String userId, required amplify_core.TemporalDate date, required String muscle, required String exercise, double? maxWeight, double? minWeight, int? maxReps, int? minReps}) {
    return Exercise._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      userId: userId,
      date: date,
      muscle: muscle,
      exercise: exercise,
      maxWeight: maxWeight,
      minWeight: minWeight,
      maxReps: maxReps,
      minReps: minReps);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Exercise &&
      id == other.id &&
      _userId == other._userId &&
      _date == other._date &&
      _muscle == other._muscle &&
      _exercise == other._exercise &&
      _maxWeight == other._maxWeight &&
      _minWeight == other._minWeight &&
      _maxReps == other._maxReps &&
      _minReps == other._minReps;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Exercise {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("userId=" + "$_userId" + ", ");
    buffer.write("date=" + (_date != null ? _date!.format() : "null") + ", ");
    buffer.write("muscle=" + "$_muscle" + ", ");
    buffer.write("exercise=" + "$_exercise" + ", ");
    buffer.write("maxWeight=" + (_maxWeight != null ? _maxWeight!.toString() : "null") + ", ");
    buffer.write("minWeight=" + (_minWeight != null ? _minWeight!.toString() : "null") + ", ");
    buffer.write("maxReps=" + (_maxReps != null ? _maxReps!.toString() : "null") + ", ");
    buffer.write("minReps=" + (_minReps != null ? _minReps!.toString() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Exercise copyWith({String? userId, amplify_core.TemporalDate? date, String? muscle, String? exercise, double? maxWeight, double? minWeight, int? maxReps, int? minReps}) {
    return Exercise._internal(
      id: id,
      userId: userId ?? this.userId,
      date: date ?? this.date,
      muscle: muscle ?? this.muscle,
      exercise: exercise ?? this.exercise,
      maxWeight: maxWeight ?? this.maxWeight,
      minWeight: minWeight ?? this.minWeight,
      maxReps: maxReps ?? this.maxReps,
      minReps: minReps ?? this.minReps);
  }
  
  Exercise copyWithModelFieldValues({
    ModelFieldValue<String>? userId,
    ModelFieldValue<amplify_core.TemporalDate>? date,
    ModelFieldValue<String>? muscle,
    ModelFieldValue<String>? exercise,
    ModelFieldValue<double?>? maxWeight,
    ModelFieldValue<double?>? minWeight,
    ModelFieldValue<int?>? maxReps,
    ModelFieldValue<int?>? minReps
  }) {
    return Exercise._internal(
      id: id,
      userId: userId == null ? this.userId : userId.value,
      date: date == null ? this.date : date.value,
      muscle: muscle == null ? this.muscle : muscle.value,
      exercise: exercise == null ? this.exercise : exercise.value,
      maxWeight: maxWeight == null ? this.maxWeight : maxWeight.value,
      minWeight: minWeight == null ? this.minWeight : minWeight.value,
      maxReps: maxReps == null ? this.maxReps : maxReps.value,
      minReps: minReps == null ? this.minReps : minReps.value
    );
  }
  
  Exercise.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _userId = json['userId'],
      _date = json['date'] != null ? amplify_core.TemporalDate.fromString(json['date']) : null,
      _muscle = json['muscle'],
      _exercise = json['exercise'],
      _maxWeight = (json['maxWeight'] as num?)?.toDouble(),
      _minWeight = (json['minWeight'] as num?)?.toDouble(),
      _maxReps = (json['maxReps'] as num?)?.toInt(),
      _minReps = (json['minReps'] as num?)?.toInt(),
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'userId': _userId, 'date': _date?.format(), 'muscle': _muscle, 'exercise': _exercise, 'maxWeight': _maxWeight, 'minWeight': _minWeight, 'maxReps': _maxReps, 'minReps': _minReps, 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'userId': _userId,
    'date': _date,
    'muscle': _muscle,
    'exercise': _exercise,
    'maxWeight': _maxWeight,
    'minWeight': _minWeight,
    'maxReps': _maxReps,
    'minReps': _minReps,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<ExerciseModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<ExerciseModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final USERID = amplify_core.QueryField(fieldName: "userId");
  static final DATE = amplify_core.QueryField(fieldName: "date");
  static final MUSCLE = amplify_core.QueryField(fieldName: "muscle");
  static final EXERCISE = amplify_core.QueryField(fieldName: "exercise");
  static final MAXWEIGHT = amplify_core.QueryField(fieldName: "maxWeight");
  static final MINWEIGHT = amplify_core.QueryField(fieldName: "minWeight");
  static final MAXREPS = amplify_core.QueryField(fieldName: "maxReps");
  static final MINREPS = amplify_core.QueryField(fieldName: "minReps");
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Exercise";
    modelSchemaDefinition.pluralName = "Exercises";
    
    modelSchemaDefinition.authRules = [
      amplify_core.AuthRule(
        authStrategy: amplify_core.AuthStrategy.OWNER,
        ownerField: "userId",
        identityClaim: "cognito:username",
        provider: amplify_core.AuthRuleProvider.USERPOOLS,
        operations: const [
          amplify_core.ModelOperation.CREATE,
          amplify_core.ModelOperation.UPDATE,
          amplify_core.ModelOperation.DELETE,
          amplify_core.ModelOperation.READ
        ])
    ];
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Exercise.USERID,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Exercise.DATE,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.date)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Exercise.MUSCLE,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Exercise.EXERCISE,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Exercise.MAXWEIGHT,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.double)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Exercise.MINWEIGHT,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.double)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Exercise.MAXREPS,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Exercise.MINREPS,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.nonQueryField(
      fieldName: 'createdAt',
      isRequired: false,
      isReadOnly: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.nonQueryField(
      fieldName: 'updatedAt',
      isRequired: false,
      isReadOnly: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
  });
}

class _ExerciseModelType extends amplify_core.ModelType<Exercise> {
  const _ExerciseModelType();
  
  @override
  Exercise fromJson(Map<String, dynamic> jsonData) {
    return Exercise.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'Exercise';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [Exercise] in your schema.
 */
class ExerciseModelIdentifier implements amplify_core.ModelIdentifier<Exercise> {
  final String id;

  /** Create an instance of ExerciseModelIdentifier using [id] the primary key. */
  const ExerciseModelIdentifier({
    required this.id});
  
  @override
  Map<String, dynamic> serializeAsMap() => (<String, dynamic>{
    'id': id
  });
  
  @override
  List<Map<String, dynamic>> serializeAsList() => serializeAsMap()
    .entries
    .map((entry) => (<String, dynamic>{ entry.key: entry.value }))
    .toList();
  
  @override
  String serializeAsString() => serializeAsMap().values.join('#');
  
  @override
  String toString() => 'ExerciseModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is ExerciseModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}