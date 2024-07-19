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


/** This is an auto generated class representing the ExerciseData type in your schema. */
class ExerciseData extends amplify_core.Model {
  static const classType = const _ExerciseDataModelType();
  final String? _exerciseId;
  final String? _name;
  final String? _muscleId;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;
  final String? _muscleDataExercisesMuscleId;
  final String? _muscleDataExercisesName;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => modelIdentifier.serializeAsString();
  
  ExerciseDataModelIdentifier get modelIdentifier {
    try {
      return ExerciseDataModelIdentifier(
        exerciseId: _exerciseId!,
        name: _name!
      );
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get exerciseId {
    try {
      return _exerciseId!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get name {
    try {
      return _name!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get muscleId {
    try {
      return _muscleId!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  String? get muscleDataExercisesMuscleId {
    return _muscleDataExercisesMuscleId;
  }
  
  String? get muscleDataExercisesName {
    return _muscleDataExercisesName;
  }
  
  const ExerciseData._internal({required exerciseId, required name, required muscleId, createdAt, updatedAt, muscleDataExercisesMuscleId, muscleDataExercisesName}): _exerciseId = exerciseId, _name = name, _muscleId = muscleId, _createdAt = createdAt, _updatedAt = updatedAt, _muscleDataExercisesMuscleId = muscleDataExercisesMuscleId, _muscleDataExercisesName = muscleDataExercisesName;
  
  factory ExerciseData({required String exerciseId, required String name, required String muscleId, String? muscleDataExercisesMuscleId, String? muscleDataExercisesName}) {
    return ExerciseData._internal(
      exerciseId: exerciseId,
      name: name,
      muscleId: muscleId,
      muscleDataExercisesMuscleId: muscleDataExercisesMuscleId,
      muscleDataExercisesName: muscleDataExercisesName);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ExerciseData &&
      _exerciseId == other._exerciseId &&
      _name == other._name &&
      _muscleId == other._muscleId &&
      _muscleDataExercisesMuscleId == other._muscleDataExercisesMuscleId &&
      _muscleDataExercisesName == other._muscleDataExercisesName;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("ExerciseData {");
    buffer.write("exerciseId=" + "$_exerciseId" + ", ");
    buffer.write("name=" + "$_name" + ", ");
    buffer.write("muscleId=" + "$_muscleId" + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null") + ", ");
    buffer.write("muscleDataExercisesMuscleId=" + "$_muscleDataExercisesMuscleId" + ", ");
    buffer.write("muscleDataExercisesName=" + "$_muscleDataExercisesName");
    buffer.write("}");
    
    return buffer.toString();
  }
  
  ExerciseData copyWith({String? muscleId, String? muscleDataExercisesMuscleId, String? muscleDataExercisesName}) {
    return ExerciseData._internal(
      exerciseId: exerciseId,
      name: name,
      muscleId: muscleId ?? this.muscleId,
      muscleDataExercisesMuscleId: muscleDataExercisesMuscleId ?? this.muscleDataExercisesMuscleId,
      muscleDataExercisesName: muscleDataExercisesName ?? this.muscleDataExercisesName);
  }
  
  ExerciseData copyWithModelFieldValues({
    ModelFieldValue<String>? muscleId,
    ModelFieldValue<String?>? muscleDataExercisesMuscleId,
    ModelFieldValue<String?>? muscleDataExercisesName
  }) {
    return ExerciseData._internal(
      exerciseId: exerciseId,
      name: name,
      muscleId: muscleId == null ? this.muscleId : muscleId.value,
      muscleDataExercisesMuscleId: muscleDataExercisesMuscleId == null ? this.muscleDataExercisesMuscleId : muscleDataExercisesMuscleId.value,
      muscleDataExercisesName: muscleDataExercisesName == null ? this.muscleDataExercisesName : muscleDataExercisesName.value
    );
  }
  
  ExerciseData.fromJson(Map<String, dynamic> json)  
    : _exerciseId = json['exerciseId'],
      _name = json['name'],
      _muscleId = json['muscleId'],
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null,
      _muscleDataExercisesMuscleId = json['muscleDataExercisesMuscleId'],
      _muscleDataExercisesName = json['muscleDataExercisesName'];
  
  Map<String, dynamic> toJson() => {
    'exerciseId': _exerciseId, 'name': _name, 'muscleId': _muscleId, 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format(), 'muscleDataExercisesMuscleId': _muscleDataExercisesMuscleId, 'muscleDataExercisesName': _muscleDataExercisesName
  };
  
  Map<String, Object?> toMap() => {
    'exerciseId': _exerciseId,
    'name': _name,
    'muscleId': _muscleId,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt,
    'muscleDataExercisesMuscleId': _muscleDataExercisesMuscleId,
    'muscleDataExercisesName': _muscleDataExercisesName
  };

  static final amplify_core.QueryModelIdentifier<ExerciseDataModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<ExerciseDataModelIdentifier>();
  static final EXERCISEID = amplify_core.QueryField(fieldName: "exerciseId");
  static final NAME = amplify_core.QueryField(fieldName: "name");
  static final MUSCLEID = amplify_core.QueryField(fieldName: "muscleId");
  static final MUSCLEDATAEXERCISESMUSCLEID = amplify_core.QueryField(fieldName: "muscleDataExercisesMuscleId");
  static final MUSCLEDATAEXERCISESNAME = amplify_core.QueryField(fieldName: "muscleDataExercisesName");
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "ExerciseData";
    modelSchemaDefinition.pluralName = "ExerciseData";
    
    modelSchemaDefinition.authRules = [
      amplify_core.AuthRule(
        authStrategy: amplify_core.AuthStrategy.GROUPS,
        groupClaim: "cognito:groups",
        groups: [ "Public" ],
        provider: amplify_core.AuthRuleProvider.USERPOOLS,
        operations: const [
          amplify_core.ModelOperation.READ
        ]),
      amplify_core.AuthRule(
        authStrategy: amplify_core.AuthStrategy.GROUPS,
        groupClaim: "cognito:groups",
        groups: [ "dev" ],
        provider: amplify_core.AuthRuleProvider.USERPOOLS,
        operations: const [
          amplify_core.ModelOperation.READ,
          amplify_core.ModelOperation.CREATE,
          amplify_core.ModelOperation.UPDATE,
          amplify_core.ModelOperation.DELETE
        ])
    ];
    
    modelSchemaDefinition.indexes = [
      amplify_core.ModelIndex(fields: const ["exerciseId", "name"], name: null)
    ];
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ExerciseData.EXERCISEID,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ExerciseData.NAME,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ExerciseData.MUSCLEID,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
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
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ExerciseData.MUSCLEDATAEXERCISESMUSCLEID,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ExerciseData.MUSCLEDATAEXERCISESNAME,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
  });
}

class _ExerciseDataModelType extends amplify_core.ModelType<ExerciseData> {
  const _ExerciseDataModelType();
  
  @override
  ExerciseData fromJson(Map<String, dynamic> jsonData) {
    return ExerciseData.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'ExerciseData';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [ExerciseData] in your schema.
 */
class ExerciseDataModelIdentifier implements amplify_core.ModelIdentifier<ExerciseData> {
  final String exerciseId;
  final String name;

  /**
   * Create an instance of ExerciseDataModelIdentifier using [exerciseId] the primary key.
   * And [name] the sort key.
   */
  const ExerciseDataModelIdentifier({
    required this.exerciseId,
    required this.name});
  
  @override
  Map<String, dynamic> serializeAsMap() => (<String, dynamic>{
    'exerciseId': exerciseId,
    'name': name
  });
  
  @override
  List<Map<String, dynamic>> serializeAsList() => serializeAsMap()
    .entries
    .map((entry) => (<String, dynamic>{ entry.key: entry.value }))
    .toList();
  
  @override
  String serializeAsString() => serializeAsMap().values.join('#');
  
  @override
  String toString() => 'ExerciseDataModelIdentifier(exerciseId: $exerciseId, name: $name)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is ExerciseDataModelIdentifier &&
      exerciseId == other.exerciseId &&
      name == other.name;
  }
  
  @override
  int get hashCode =>
    exerciseId.hashCode ^
    name.hashCode;
}