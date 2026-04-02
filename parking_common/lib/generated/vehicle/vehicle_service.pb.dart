// This is a generated file - do not edit.
//
// Generated from vehicle/vehicle_service.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import '../common/types.pbenum.dart' as $1;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class VehicleEntryRequest extends $pb.GeneratedMessage {
  factory VehicleEntryRequest({
    $core.String? garageId,
    $core.String? vehiclePlate,
    $fixnum.Int64? entryTime,
    $core.String? userId,
  }) {
    final result = create();
    if (garageId != null) result.garageId = garageId;
    if (vehiclePlate != null) result.vehiclePlate = vehiclePlate;
    if (entryTime != null) result.entryTime = entryTime;
    if (userId != null) result.userId = userId;
    return result;
  }

  VehicleEntryRequest._();

  factory VehicleEntryRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory VehicleEntryRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'VehicleEntryRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'vehicle'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'garageId')
    ..aOS(2, _omitFieldNames ? '' : 'vehiclePlate')
    ..aInt64(3, _omitFieldNames ? '' : 'entryTime')
    ..aOS(4, _omitFieldNames ? '' : 'userId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VehicleEntryRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VehicleEntryRequest copyWith(void Function(VehicleEntryRequest) updates) =>
      super.copyWith((message) => updates(message as VehicleEntryRequest))
          as VehicleEntryRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static VehicleEntryRequest create() => VehicleEntryRequest._();
  @$core.override
  VehicleEntryRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static VehicleEntryRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<VehicleEntryRequest>(create);
  static VehicleEntryRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get garageId => $_getSZ(0);
  @$pb.TagNumber(1)
  set garageId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasGarageId() => $_has(0);
  @$pb.TagNumber(1)
  void clearGarageId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get vehiclePlate => $_getSZ(1);
  @$pb.TagNumber(2)
  set vehiclePlate($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasVehiclePlate() => $_has(1);
  @$pb.TagNumber(2)
  void clearVehiclePlate() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get entryTime => $_getI64(2);
  @$pb.TagNumber(3)
  set entryTime($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasEntryTime() => $_has(2);
  @$pb.TagNumber(3)
  void clearEntryTime() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get userId => $_getSZ(3);
  @$pb.TagNumber(4)
  set userId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasUserId() => $_has(3);
  @$pb.TagNumber(4)
  void clearUserId() => $_clearField(4);
}

class VehicleEntryResponse extends $pb.GeneratedMessage {
  factory VehicleEntryResponse({
    $core.String? entryId,
    $core.bool? success,
    $core.String? message,
    $fixnum.Int64? entryTime,
  }) {
    final result = create();
    if (entryId != null) result.entryId = entryId;
    if (success != null) result.success = success;
    if (message != null) result.message = message;
    if (entryTime != null) result.entryTime = entryTime;
    return result;
  }

  VehicleEntryResponse._();

  factory VehicleEntryResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory VehicleEntryResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'VehicleEntryResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'vehicle'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'entryId')
    ..aOB(2, _omitFieldNames ? '' : 'success')
    ..aOS(3, _omitFieldNames ? '' : 'message')
    ..aInt64(4, _omitFieldNames ? '' : 'entryTime')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VehicleEntryResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VehicleEntryResponse copyWith(void Function(VehicleEntryResponse) updates) =>
      super.copyWith((message) => updates(message as VehicleEntryResponse))
          as VehicleEntryResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static VehicleEntryResponse create() => VehicleEntryResponse._();
  @$core.override
  VehicleEntryResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static VehicleEntryResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<VehicleEntryResponse>(create);
  static VehicleEntryResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get entryId => $_getSZ(0);
  @$pb.TagNumber(1)
  set entryId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEntryId() => $_has(0);
  @$pb.TagNumber(1)
  void clearEntryId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get success => $_getBF(1);
  @$pb.TagNumber(2)
  set success($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSuccess() => $_has(1);
  @$pb.TagNumber(2)
  void clearSuccess() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get message => $_getSZ(2);
  @$pb.TagNumber(3)
  set message($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasMessage() => $_has(2);
  @$pb.TagNumber(3)
  void clearMessage() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get entryTime => $_getI64(3);
  @$pb.TagNumber(4)
  set entryTime($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasEntryTime() => $_has(3);
  @$pb.TagNumber(4)
  void clearEntryTime() => $_clearField(4);
}

class VehicleExitRequest extends $pb.GeneratedMessage {
  factory VehicleExitRequest({
    $core.String? garageId,
    $core.String? vehiclePlate,
    $fixnum.Int64? exitTime,
  }) {
    final result = create();
    if (garageId != null) result.garageId = garageId;
    if (vehiclePlate != null) result.vehiclePlate = vehiclePlate;
    if (exitTime != null) result.exitTime = exitTime;
    return result;
  }

  VehicleExitRequest._();

  factory VehicleExitRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory VehicleExitRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'VehicleExitRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'vehicle'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'garageId')
    ..aOS(2, _omitFieldNames ? '' : 'vehiclePlate')
    ..aInt64(3, _omitFieldNames ? '' : 'exitTime')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VehicleExitRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VehicleExitRequest copyWith(void Function(VehicleExitRequest) updates) =>
      super.copyWith((message) => updates(message as VehicleExitRequest))
          as VehicleExitRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static VehicleExitRequest create() => VehicleExitRequest._();
  @$core.override
  VehicleExitRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static VehicleExitRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<VehicleExitRequest>(create);
  static VehicleExitRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get garageId => $_getSZ(0);
  @$pb.TagNumber(1)
  set garageId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasGarageId() => $_has(0);
  @$pb.TagNumber(1)
  void clearGarageId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get vehiclePlate => $_getSZ(1);
  @$pb.TagNumber(2)
  set vehiclePlate($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasVehiclePlate() => $_has(1);
  @$pb.TagNumber(2)
  void clearVehiclePlate() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get exitTime => $_getI64(2);
  @$pb.TagNumber(3)
  set exitTime($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasExitTime() => $_has(2);
  @$pb.TagNumber(3)
  void clearExitTime() => $_clearField(3);
}

class VehicleExitResponse extends $pb.GeneratedMessage {
  factory VehicleExitResponse({
    $core.String? entryId,
    $core.double? totalAmount,
    $fixnum.Int64? durationSeconds,
    $fixnum.Int64? entryTime,
    $fixnum.Int64? exitTime,
    $core.bool? success,
    $core.String? message,
  }) {
    final result = create();
    if (entryId != null) result.entryId = entryId;
    if (totalAmount != null) result.totalAmount = totalAmount;
    if (durationSeconds != null) result.durationSeconds = durationSeconds;
    if (entryTime != null) result.entryTime = entryTime;
    if (exitTime != null) result.exitTime = exitTime;
    if (success != null) result.success = success;
    if (message != null) result.message = message;
    return result;
  }

  VehicleExitResponse._();

  factory VehicleExitResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory VehicleExitResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'VehicleExitResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'vehicle'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'entryId')
    ..aD(2, _omitFieldNames ? '' : 'totalAmount')
    ..aInt64(3, _omitFieldNames ? '' : 'durationSeconds')
    ..aInt64(4, _omitFieldNames ? '' : 'entryTime')
    ..aInt64(5, _omitFieldNames ? '' : 'exitTime')
    ..aOB(6, _omitFieldNames ? '' : 'success')
    ..aOS(7, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VehicleExitResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VehicleExitResponse copyWith(void Function(VehicleExitResponse) updates) =>
      super.copyWith((message) => updates(message as VehicleExitResponse))
          as VehicleExitResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static VehicleExitResponse create() => VehicleExitResponse._();
  @$core.override
  VehicleExitResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static VehicleExitResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<VehicleExitResponse>(create);
  static VehicleExitResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get entryId => $_getSZ(0);
  @$pb.TagNumber(1)
  set entryId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEntryId() => $_has(0);
  @$pb.TagNumber(1)
  void clearEntryId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get totalAmount => $_getN(1);
  @$pb.TagNumber(2)
  set totalAmount($core.double value) => $_setDouble(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTotalAmount() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotalAmount() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get durationSeconds => $_getI64(2);
  @$pb.TagNumber(3)
  set durationSeconds($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDurationSeconds() => $_has(2);
  @$pb.TagNumber(3)
  void clearDurationSeconds() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get entryTime => $_getI64(3);
  @$pb.TagNumber(4)
  set entryTime($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasEntryTime() => $_has(3);
  @$pb.TagNumber(4)
  void clearEntryTime() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get exitTime => $_getI64(4);
  @$pb.TagNumber(5)
  set exitTime($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasExitTime() => $_has(4);
  @$pb.TagNumber(5)
  void clearExitTime() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get success => $_getBF(5);
  @$pb.TagNumber(6)
  set success($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasSuccess() => $_has(5);
  @$pb.TagNumber(6)
  void clearSuccess() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get message => $_getSZ(6);
  @$pb.TagNumber(7)
  set message($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasMessage() => $_has(6);
  @$pb.TagNumber(7)
  void clearMessage() => $_clearField(7);
}

class VehicleEntry extends $pb.GeneratedMessage {
  factory VehicleEntry({
    $core.String? id,
    $core.String? garageId,
    $core.String? vehiclePlate,
    $fixnum.Int64? entryTime,
    $fixnum.Int64? exitTime,
    $core.double? amountPaid,
    $1.VehicleStatus? status,
    $core.String? userId,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (garageId != null) result.garageId = garageId;
    if (vehiclePlate != null) result.vehiclePlate = vehiclePlate;
    if (entryTime != null) result.entryTime = entryTime;
    if (exitTime != null) result.exitTime = exitTime;
    if (amountPaid != null) result.amountPaid = amountPaid;
    if (status != null) result.status = status;
    if (userId != null) result.userId = userId;
    return result;
  }

  VehicleEntry._();

  factory VehicleEntry.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory VehicleEntry.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'VehicleEntry',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'vehicle'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'garageId')
    ..aOS(3, _omitFieldNames ? '' : 'vehiclePlate')
    ..aInt64(4, _omitFieldNames ? '' : 'entryTime')
    ..aInt64(5, _omitFieldNames ? '' : 'exitTime')
    ..aD(6, _omitFieldNames ? '' : 'amountPaid')
    ..aE<$1.VehicleStatus>(7, _omitFieldNames ? '' : 'status',
        enumValues: $1.VehicleStatus.values)
    ..aOS(8, _omitFieldNames ? '' : 'userId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VehicleEntry clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VehicleEntry copyWith(void Function(VehicleEntry) updates) =>
      super.copyWith((message) => updates(message as VehicleEntry))
          as VehicleEntry;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static VehicleEntry create() => VehicleEntry._();
  @$core.override
  VehicleEntry createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static VehicleEntry getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<VehicleEntry>(create);
  static VehicleEntry? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get garageId => $_getSZ(1);
  @$pb.TagNumber(2)
  set garageId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasGarageId() => $_has(1);
  @$pb.TagNumber(2)
  void clearGarageId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get vehiclePlate => $_getSZ(2);
  @$pb.TagNumber(3)
  set vehiclePlate($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasVehiclePlate() => $_has(2);
  @$pb.TagNumber(3)
  void clearVehiclePlate() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get entryTime => $_getI64(3);
  @$pb.TagNumber(4)
  set entryTime($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasEntryTime() => $_has(3);
  @$pb.TagNumber(4)
  void clearEntryTime() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get exitTime => $_getI64(4);
  @$pb.TagNumber(5)
  set exitTime($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasExitTime() => $_has(4);
  @$pb.TagNumber(5)
  void clearExitTime() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get amountPaid => $_getN(5);
  @$pb.TagNumber(6)
  set amountPaid($core.double value) => $_setDouble(5, value);
  @$pb.TagNumber(6)
  $core.bool hasAmountPaid() => $_has(5);
  @$pb.TagNumber(6)
  void clearAmountPaid() => $_clearField(6);

  @$pb.TagNumber(7)
  $1.VehicleStatus get status => $_getN(6);
  @$pb.TagNumber(7)
  set status($1.VehicleStatus value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasStatus() => $_has(6);
  @$pb.TagNumber(7)
  void clearStatus() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get userId => $_getSZ(7);
  @$pb.TagNumber(8)
  set userId($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasUserId() => $_has(7);
  @$pb.TagNumber(8)
  void clearUserId() => $_clearField(8);
}

class GetActiveVehiclesRequest extends $pb.GeneratedMessage {
  factory GetActiveVehiclesRequest({
    $core.String? garageId,
  }) {
    final result = create();
    if (garageId != null) result.garageId = garageId;
    return result;
  }

  GetActiveVehiclesRequest._();

  factory GetActiveVehiclesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetActiveVehiclesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetActiveVehiclesRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'vehicle'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'garageId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetActiveVehiclesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetActiveVehiclesRequest copyWith(
          void Function(GetActiveVehiclesRequest) updates) =>
      super.copyWith((message) => updates(message as GetActiveVehiclesRequest))
          as GetActiveVehiclesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetActiveVehiclesRequest create() => GetActiveVehiclesRequest._();
  @$core.override
  GetActiveVehiclesRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetActiveVehiclesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetActiveVehiclesRequest>(create);
  static GetActiveVehiclesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get garageId => $_getSZ(0);
  @$pb.TagNumber(1)
  set garageId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasGarageId() => $_has(0);
  @$pb.TagNumber(1)
  void clearGarageId() => $_clearField(1);
}

class GetActiveVehiclesResponse extends $pb.GeneratedMessage {
  factory GetActiveVehiclesResponse({
    $core.Iterable<VehicleEntry>? vehicles,
    $core.int? totalActive,
  }) {
    final result = create();
    if (vehicles != null) result.vehicles.addAll(vehicles);
    if (totalActive != null) result.totalActive = totalActive;
    return result;
  }

  GetActiveVehiclesResponse._();

  factory GetActiveVehiclesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetActiveVehiclesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetActiveVehiclesResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'vehicle'),
      createEmptyInstance: create)
    ..pPM<VehicleEntry>(1, _omitFieldNames ? '' : 'vehicles',
        subBuilder: VehicleEntry.create)
    ..aI(2, _omitFieldNames ? '' : 'totalActive')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetActiveVehiclesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetActiveVehiclesResponse copyWith(
          void Function(GetActiveVehiclesResponse) updates) =>
      super.copyWith((message) => updates(message as GetActiveVehiclesResponse))
          as GetActiveVehiclesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetActiveVehiclesResponse create() => GetActiveVehiclesResponse._();
  @$core.override
  GetActiveVehiclesResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetActiveVehiclesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetActiveVehiclesResponse>(create);
  static GetActiveVehiclesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<VehicleEntry> get vehicles => $_getList(0);

  @$pb.TagNumber(2)
  $core.int get totalActive => $_getIZ(1);
  @$pb.TagNumber(2)
  set totalActive($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTotalActive() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotalActive() => $_clearField(2);
}

class GetVehicleEntryRequest extends $pb.GeneratedMessage {
  factory GetVehicleEntryRequest({
    $core.String? garageId,
    $core.String? vehiclePlate,
  }) {
    final result = create();
    if (garageId != null) result.garageId = garageId;
    if (vehiclePlate != null) result.vehiclePlate = vehiclePlate;
    return result;
  }

  GetVehicleEntryRequest._();

  factory GetVehicleEntryRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetVehicleEntryRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetVehicleEntryRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'vehicle'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'garageId')
    ..aOS(2, _omitFieldNames ? '' : 'vehiclePlate')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetVehicleEntryRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetVehicleEntryRequest copyWith(
          void Function(GetVehicleEntryRequest) updates) =>
      super.copyWith((message) => updates(message as GetVehicleEntryRequest))
          as GetVehicleEntryRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetVehicleEntryRequest create() => GetVehicleEntryRequest._();
  @$core.override
  GetVehicleEntryRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetVehicleEntryRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetVehicleEntryRequest>(create);
  static GetVehicleEntryRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get garageId => $_getSZ(0);
  @$pb.TagNumber(1)
  set garageId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasGarageId() => $_has(0);
  @$pb.TagNumber(1)
  void clearGarageId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get vehiclePlate => $_getSZ(1);
  @$pb.TagNumber(2)
  set vehiclePlate($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasVehiclePlate() => $_has(1);
  @$pb.TagNumber(2)
  void clearVehiclePlate() => $_clearField(2);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
