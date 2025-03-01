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


/** This is an auto generated class representing the SessionData type in your schema. */
class SessionData extends amplify_core.Model {
  static const classType = const _SessionDataModelType();
  final String? _sessionId;
  final String? _exerciseId;
  final String? _muscleId;
  final amplify_core.TemporalDate? _timeStamp;
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
  String getId() => modelIdentifier.serializeAsString();
  
  SessionDataModelIdentifier get modelIdentifier {
    try {
      return SessionDataModelIdentifier(
        sessionId: _sessionId!,
        timeStamp: _timeStamp!
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
  
  String get sessionId {
    try {
      return _sessionId!;
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
  
  amplify_core.TemporalDate get timeStamp {
    try {
      return _timeStamp!;
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
  
  const SessionData._internal({required sessionId, required exerciseId, required muscleId, required timeStamp, maxWeight, minWeight, maxReps, minReps, createdAt, updatedAt}): _sessionId = sessionId, _exerciseId = exerciseId, _muscleId = muscleId, _timeStamp = timeStamp, _maxWeight = maxWeight, _minWeight = minWeight, _maxReps = maxReps, _minReps = minReps, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory SessionData({required String sessionId, required String exerciseId, required String muscleId, required amplify_core.TemporalDate timeStamp, double? maxWeight, double? minWeight, int? maxReps, int? minReps}) {
    return SessionData._internal(
      sessionId: sessionId,
      exerciseId: exerciseId,
      muscleId: muscleId,
      timeStamp: timeStamp,
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
    return other is SessionData &&
      _sessionId == other._sessionId &&
      _exerciseId == other._exerciseId &&
      _muscleId == other._muscleId &&
      _timeStamp == other._timeStamp &&
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
    
    buffer.write("SessionData {");
    buffer.write("sessionId=" + "$_sessionId" + ", ");
    buffer.write("exerciseId=" + "$_exerciseId" + ", ");
    buffer.write("muscleId=" + "$_muscleId" + ", ");
    buffer.write("timeStamp=" + (_timeStamp != null ? _timeStamp.format() : "null") + ", ");
    buffer.write("maxWeight=" + (_maxWeight != null ? _maxWeight.toString() : "null") + ", ");
    buffer.write("minWeight=" + (_minWeight != null ? _minWeight.toString() : "null") + ", ");
    buffer.write("maxReps=" + (_maxReps != null ? _maxReps.toString() : "null") + ", ");
    buffer.write("minReps=" + (_minReps != null ? _minReps.toString() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  SessionData copyWith({String? exerciseId, String? muscleId, double? maxWeight, double? minWeight, int? maxReps, int? minReps}) {
    return SessionData._internal(
      sessionId: sessionId,
      exerciseId: exerciseId ?? this.exerciseId,
      muscleId: muscleId ?? this.muscleId,
      timeStamp: timeStamp,
      maxWeight: maxWeight ?? this.maxWeight,
      minWeight: minWeight ?? this.minWeight,
      maxReps: maxReps ?? this.maxReps,
      minReps: minReps ?? this.minReps);
  }
  
  SessionData copyWithModelFieldValues({
    ModelFieldValue<String>? exerciseId,
    ModelFieldValue<String>? muscleId,
    ModelFieldValue<double?>? maxWeight,
    ModelFieldValue<double?>? minWeight,
    ModelFieldValue<int?>? maxReps,
    ModelFieldValue<int?>? minReps
  }) {
    return SessionData._internal(
      sessionId: sessionId,
      exerciseId: exerciseId == null ? this.exerciseId : exerciseId.value,
      muscleId: muscleId == null ? this.muscleId : muscleId.value,
      timeStamp: timeStamp,
      maxWeight: maxWeight == null ? this.maxWeight : maxWeight.value,
      minWeight: minWeight == null ? this.minWeight : minWeight.value,
      maxReps: maxReps == null ? this.maxReps : maxReps.value,
      minReps: minReps == null ? this.minReps : minReps.value
    );
  }
  
  SessionData.fromJson(Map<String, dynamic> json)  
    : _sessionId = json['sessionId'],
      _exerciseId = json['exerciseId'],
      _muscleId = json['muscleId'],
      _timeStamp = json['timeStamp'] != null ? amplify_core.TemporalDate.fromString(json['timeStamp']) : null,
      _maxWeight = (json['maxWeight'] as num?)?.toDouble(),
      _minWeight = (json['minWeight'] as num?)?.toDouble(),
      _maxReps = (json['maxReps'] as num?)?.toInt(),
      _minReps = (json['minReps'] as num?)?.toInt(),
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'sessionId': _sessionId, 'exerciseId': _exerciseId, 'muscleId': _muscleId, 'timeStamp': _timeStamp?.format(), 'maxWeight': _maxWeight, 'minWeight': _minWeight, 'maxReps': _maxReps, 'minReps': _minReps, 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'sessionId': _sessionId,
    'exerciseId': _exerciseId,
    'muscleId': _muscleId,
    'timeStamp': _timeStamp,
    'maxWeight': _maxWeight,
    'minWeight': _minWeight,
    'maxReps': _maxReps,
    'minReps': _minReps,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<SessionDataModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<SessionDataModelIdentifier>();
  static final SESSIONID = amplify_core.QueryField(fieldName: "sessionId");
  static final EXERCISEID = amplify_core.QueryField(fieldName: "exerciseId");
  static final MUSCLEID = amplify_core.QueryField(fieldName: "muscleId");
  static final TIMESTAMP = amplify_core.QueryField(fieldName: "timeStamp");
  static final MAXWEIGHT = amplify_core.QueryField(fieldName: "maxWeight");
  static final MINWEIGHT = amplify_core.QueryField(fieldName: "minWeight");
  static final MAXREPS = amplify_core.QueryField(fieldName: "maxReps");
  static final MINREPS = amplify_core.QueryField(fieldName: "minReps");
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "SessionData";
    modelSchemaDefinition.pluralName = "SessionData";
    
    modelSchemaDefinition.authRules = [
      amplify_core.AuthRule(
        authStrategy: amplify_core.AuthStrategy.OWNER,
        ownerField: "owner",
        identityClaim: "cognito:username",
        provider: amplify_core.AuthRuleProvider.USERPOOLS,
        operations: const [
          amplify_core.ModelOperation.CREATE,
          amplify_core.ModelOperation.UPDATE,
          amplify_core.ModelOperation.DELETE,
          amplify_core.ModelOperation.READ
        ])
    ];
    
    modelSchemaDefinition.indexes = [
      amplify_core.ModelIndex(fields: const ["sessionId", "timeStamp"], name: null)
    ];
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: SessionData.SESSIONID,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: SessionData.EXERCISEID,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: SessionData.MUSCLEID,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: SessionData.TIMESTAMP,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.date)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: SessionData.MAXWEIGHT,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.double)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: SessionData.MINWEIGHT,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.double)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: SessionData.MAXREPS,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: SessionData.MINREPS,
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

class _SessionDataModelType extends amplify_core.ModelType<SessionData> {
  const _SessionDataModelType();
  
  @override
  SessionData fromJson(Map<String, dynamic> jsonData) {
    return SessionData.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'SessionData';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [SessionData] in your schema.
 */
class SessionDataModelIdentifier implements amplify_core.ModelIdentifier<SessionData> {
  final String sessionId;
  final amplify_core.TemporalDate timeStamp;

  /**
   * Create an instance of SessionDataModelIdentifier using [sessionId] the primary key.
   * And [timeStamp] the sort key.
   */
  const SessionDataModelIdentifier({
    required this.sessionId,
    required this.timeStamp});
  
  @override
  Map<String, dynamic> serializeAsMap() => (<String, dynamic>{
    'sessionId': sessionId,
    'timeStamp': timeStamp
  });
  
  @override
  List<Map<String, dynamic>> serializeAsList() => serializeAsMap()
    .entries
    .map((entry) => (<String, dynamic>{ entry.key: entry.value }))
    .toList();
  
  @override
  String serializeAsString() => serializeAsMap().values.join('#');
  
  @override
  String toString() => 'SessionDataModelIdentifier(sessionId: $sessionId, timeStamp: $timeStamp)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is SessionDataModelIdentifier &&
      sessionId == other.sessionId &&
      timeStamp == other.timeStamp;
  }
  
  @override
  int get hashCode =>
    sessionId.hashCode ^
    timeStamp.hashCode;
}