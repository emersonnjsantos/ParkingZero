// This is a generated file - do not edit.
//
// Generated from parking_service.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'parking_service.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'parking_service.pbenum.dart';

class SearchRequest extends $pb.GeneratedMessage {
  factory SearchRequest({
    $core.double? latitude,
    $core.double? longitude,
    $core.int? radiusMeters,
  }) {
    final result = create();
    if (latitude != null) result.latitude = latitude;
    if (longitude != null) result.longitude = longitude;
    if (radiusMeters != null) result.radiusMeters = radiusMeters;
    return result;
  }

  SearchRequest._();

  factory SearchRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SearchRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SearchRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'parking'),
      createEmptyInstance: create)
    ..aD(1, _omitFieldNames ? '' : 'latitude')
    ..aD(2, _omitFieldNames ? '' : 'longitude')
    ..aI(3, _omitFieldNames ? '' : 'radiusMeters')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchRequest copyWith(void Function(SearchRequest) updates) =>
      super.copyWith((message) => updates(message as SearchRequest))
          as SearchRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SearchRequest create() => SearchRequest._();
  @$core.override
  SearchRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SearchRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SearchRequest>(create);
  static SearchRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get latitude => $_getN(0);
  @$pb.TagNumber(1)
  set latitude($core.double value) => $_setDouble(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLatitude() => $_has(0);
  @$pb.TagNumber(1)
  void clearLatitude() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get longitude => $_getN(1);
  @$pb.TagNumber(2)
  set longitude($core.double value) => $_setDouble(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLongitude() => $_has(1);
  @$pb.TagNumber(2)
  void clearLongitude() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get radiusMeters => $_getIZ(2);
  @$pb.TagNumber(3)
  set radiusMeters($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRadiusMeters() => $_has(2);
  @$pb.TagNumber(3)
  void clearRadiusMeters() => $_clearField(3);
}

class SearchResponse extends $pb.GeneratedMessage {
  factory SearchResponse({
    $core.Iterable<Garage>? garages,
  }) {
    final result = create();
    if (garages != null) result.garages.addAll(garages);
    return result;
  }

  SearchResponse._();

  factory SearchResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SearchResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SearchResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'parking'),
      createEmptyInstance: create)
    ..pPM<Garage>(1, _omitFieldNames ? '' : 'garages',
        subBuilder: Garage.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchResponse copyWith(void Function(SearchResponse) updates) =>
      super.copyWith((message) => updates(message as SearchResponse))
          as SearchResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SearchResponse create() => SearchResponse._();
  @$core.override
  SearchResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SearchResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SearchResponse>(create);
  static SearchResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Garage> get garages => $_getList(0);
}

class GetGarageRequest extends $pb.GeneratedMessage {
  factory GetGarageRequest({
    $core.String? garageId,
  }) {
    final result = create();
    if (garageId != null) result.garageId = garageId;
    return result;
  }

  GetGarageRequest._();

  factory GetGarageRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetGarageRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetGarageRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'parking'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'garageId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetGarageRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetGarageRequest copyWith(void Function(GetGarageRequest) updates) =>
      super.copyWith((message) => updates(message as GetGarageRequest))
          as GetGarageRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetGarageRequest create() => GetGarageRequest._();
  @$core.override
  GetGarageRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetGarageRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetGarageRequest>(create);
  static GetGarageRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get garageId => $_getSZ(0);
  @$pb.TagNumber(1)
  set garageId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasGarageId() => $_has(0);
  @$pb.TagNumber(1)
  void clearGarageId() => $_clearField(1);
}

class Garage extends $pb.GeneratedMessage {
  factory Garage({
    $core.String? id,
    $core.String? name,
    $core.double? basePrice,
    $core.double? latitude,
    $core.double? longitude,
    $core.String? imageUrl,
    $core.Iterable<Campaign>? campaigns,
    $core.String? address,
    $core.String? phone,
    $core.int? totalSpots,
    $core.int? availableSpots,
    $core.Iterable<$core.String>? amenities,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (name != null) result.name = name;
    if (basePrice != null) result.basePrice = basePrice;
    if (latitude != null) result.latitude = latitude;
    if (longitude != null) result.longitude = longitude;
    if (imageUrl != null) result.imageUrl = imageUrl;
    if (campaigns != null) result.campaigns.addAll(campaigns);
    if (address != null) result.address = address;
    if (phone != null) result.phone = phone;
    if (totalSpots != null) result.totalSpots = totalSpots;
    if (availableSpots != null) result.availableSpots = availableSpots;
    if (amenities != null) result.amenities.addAll(amenities);
    return result;
  }

  Garage._();

  factory Garage.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Garage.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Garage',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'parking'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aD(3, _omitFieldNames ? '' : 'basePrice')
    ..aD(4, _omitFieldNames ? '' : 'latitude')
    ..aD(5, _omitFieldNames ? '' : 'longitude')
    ..aOS(6, _omitFieldNames ? '' : 'imageUrl')
    ..pPM<Campaign>(7, _omitFieldNames ? '' : 'campaigns',
        subBuilder: Campaign.create)
    ..aOS(8, _omitFieldNames ? '' : 'address')
    ..aOS(9, _omitFieldNames ? '' : 'phone')
    ..aI(10, _omitFieldNames ? '' : 'totalSpots')
    ..aI(11, _omitFieldNames ? '' : 'availableSpots')
    ..pPS(12, _omitFieldNames ? '' : 'amenities')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Garage clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Garage copyWith(void Function(Garage) updates) =>
      super.copyWith((message) => updates(message as Garage)) as Garage;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Garage create() => Garage._();
  @$core.override
  Garage createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Garage getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Garage>(create);
  static Garage? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get basePrice => $_getN(2);
  @$pb.TagNumber(3)
  set basePrice($core.double value) => $_setDouble(2, value);
  @$pb.TagNumber(3)
  $core.bool hasBasePrice() => $_has(2);
  @$pb.TagNumber(3)
  void clearBasePrice() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get latitude => $_getN(3);
  @$pb.TagNumber(4)
  set latitude($core.double value) => $_setDouble(3, value);
  @$pb.TagNumber(4)
  $core.bool hasLatitude() => $_has(3);
  @$pb.TagNumber(4)
  void clearLatitude() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get longitude => $_getN(4);
  @$pb.TagNumber(5)
  set longitude($core.double value) => $_setDouble(4, value);
  @$pb.TagNumber(5)
  $core.bool hasLongitude() => $_has(4);
  @$pb.TagNumber(5)
  void clearLongitude() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get imageUrl => $_getSZ(5);
  @$pb.TagNumber(6)
  set imageUrl($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasImageUrl() => $_has(5);
  @$pb.TagNumber(6)
  void clearImageUrl() => $_clearField(6);

  @$pb.TagNumber(7)
  $pb.PbList<Campaign> get campaigns => $_getList(6);

  @$pb.TagNumber(8)
  $core.String get address => $_getSZ(7);
  @$pb.TagNumber(8)
  set address($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasAddress() => $_has(7);
  @$pb.TagNumber(8)
  void clearAddress() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get phone => $_getSZ(8);
  @$pb.TagNumber(9)
  set phone($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasPhone() => $_has(8);
  @$pb.TagNumber(9)
  void clearPhone() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.int get totalSpots => $_getIZ(9);
  @$pb.TagNumber(10)
  set totalSpots($core.int value) => $_setSignedInt32(9, value);
  @$pb.TagNumber(10)
  $core.bool hasTotalSpots() => $_has(9);
  @$pb.TagNumber(10)
  void clearTotalSpots() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.int get availableSpots => $_getIZ(10);
  @$pb.TagNumber(11)
  set availableSpots($core.int value) => $_setSignedInt32(10, value);
  @$pb.TagNumber(11)
  $core.bool hasAvailableSpots() => $_has(10);
  @$pb.TagNumber(11)
  void clearAvailableSpots() => $_clearField(11);

  @$pb.TagNumber(12)
  $pb.PbList<$core.String> get amenities => $_getList(11);
}

class Campaign extends $pb.GeneratedMessage {
  factory Campaign({
    $core.String? partnerName,
    $core.String? discountRule,
  }) {
    final result = create();
    if (partnerName != null) result.partnerName = partnerName;
    if (discountRule != null) result.discountRule = discountRule;
    return result;
  }

  Campaign._();

  factory Campaign.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Campaign.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Campaign',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'parking'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'partnerName')
    ..aOS(2, _omitFieldNames ? '' : 'discountRule')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Campaign clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Campaign copyWith(void Function(Campaign) updates) =>
      super.copyWith((message) => updates(message as Campaign)) as Campaign;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Campaign create() => Campaign._();
  @$core.override
  Campaign createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Campaign getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Campaign>(create);
  static Campaign? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get partnerName => $_getSZ(0);
  @$pb.TagNumber(1)
  set partnerName($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPartnerName() => $_has(0);
  @$pb.TagNumber(1)
  void clearPartnerName() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get discountRule => $_getSZ(1);
  @$pb.TagNumber(2)
  set discountRule($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDiscountRule() => $_has(1);
  @$pb.TagNumber(2)
  void clearDiscountRule() => $_clearField(2);
}

class CreateReservationRequest extends $pb.GeneratedMessage {
  factory CreateReservationRequest({
    $core.String? userId,
    $core.String? garageId,
    $fixnum.Int64? startTime,
    $fixnum.Int64? endTime,
    $core.String? vehiclePlate,
  }) {
    final result = create();
    if (userId != null) result.userId = userId;
    if (garageId != null) result.garageId = garageId;
    if (startTime != null) result.startTime = startTime;
    if (endTime != null) result.endTime = endTime;
    if (vehiclePlate != null) result.vehiclePlate = vehiclePlate;
    return result;
  }

  CreateReservationRequest._();

  factory CreateReservationRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CreateReservationRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateReservationRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'parking'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'userId')
    ..aOS(2, _omitFieldNames ? '' : 'garageId')
    ..aInt64(3, _omitFieldNames ? '' : 'startTime')
    ..aInt64(4, _omitFieldNames ? '' : 'endTime')
    ..aOS(5, _omitFieldNames ? '' : 'vehiclePlate')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateReservationRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateReservationRequest copyWith(
          void Function(CreateReservationRequest) updates) =>
      super.copyWith((message) => updates(message as CreateReservationRequest))
          as CreateReservationRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateReservationRequest create() => CreateReservationRequest._();
  @$core.override
  CreateReservationRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CreateReservationRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateReservationRequest>(create);
  static CreateReservationRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userId => $_getSZ(0);
  @$pb.TagNumber(1)
  set userId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get garageId => $_getSZ(1);
  @$pb.TagNumber(2)
  set garageId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasGarageId() => $_has(1);
  @$pb.TagNumber(2)
  void clearGarageId() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get startTime => $_getI64(2);
  @$pb.TagNumber(3)
  set startTime($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasStartTime() => $_has(2);
  @$pb.TagNumber(3)
  void clearStartTime() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get endTime => $_getI64(3);
  @$pb.TagNumber(4)
  set endTime($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasEndTime() => $_has(3);
  @$pb.TagNumber(4)
  void clearEndTime() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get vehiclePlate => $_getSZ(4);
  @$pb.TagNumber(5)
  set vehiclePlate($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasVehiclePlate() => $_has(4);
  @$pb.TagNumber(5)
  void clearVehiclePlate() => $_clearField(5);
}

class Reservation extends $pb.GeneratedMessage {
  factory Reservation({
    $core.String? id,
    $core.String? userId,
    $core.String? garageId,
    $core.String? garageName,
    $fixnum.Int64? startTime,
    $fixnum.Int64? endTime,
    $core.String? vehiclePlate,
    $core.double? totalPrice,
    ReservationStatus? status,
    $fixnum.Int64? createdAt,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (userId != null) result.userId = userId;
    if (garageId != null) result.garageId = garageId;
    if (garageName != null) result.garageName = garageName;
    if (startTime != null) result.startTime = startTime;
    if (endTime != null) result.endTime = endTime;
    if (vehiclePlate != null) result.vehiclePlate = vehiclePlate;
    if (totalPrice != null) result.totalPrice = totalPrice;
    if (status != null) result.status = status;
    if (createdAt != null) result.createdAt = createdAt;
    return result;
  }

  Reservation._();

  factory Reservation.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Reservation.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Reservation',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'parking'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'userId')
    ..aOS(3, _omitFieldNames ? '' : 'garageId')
    ..aOS(4, _omitFieldNames ? '' : 'garageName')
    ..aInt64(5, _omitFieldNames ? '' : 'startTime')
    ..aInt64(6, _omitFieldNames ? '' : 'endTime')
    ..aOS(7, _omitFieldNames ? '' : 'vehiclePlate')
    ..aD(8, _omitFieldNames ? '' : 'totalPrice')
    ..aE<ReservationStatus>(9, _omitFieldNames ? '' : 'status',
        enumValues: ReservationStatus.values)
    ..aInt64(10, _omitFieldNames ? '' : 'createdAt')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Reservation clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Reservation copyWith(void Function(Reservation) updates) =>
      super.copyWith((message) => updates(message as Reservation))
          as Reservation;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Reservation create() => Reservation._();
  @$core.override
  Reservation createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Reservation getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Reservation>(create);
  static Reservation? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get userId => $_getSZ(1);
  @$pb.TagNumber(2)
  set userId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUserId() => $_has(1);
  @$pb.TagNumber(2)
  void clearUserId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get garageId => $_getSZ(2);
  @$pb.TagNumber(3)
  set garageId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasGarageId() => $_has(2);
  @$pb.TagNumber(3)
  void clearGarageId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get garageName => $_getSZ(3);
  @$pb.TagNumber(4)
  set garageName($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasGarageName() => $_has(3);
  @$pb.TagNumber(4)
  void clearGarageName() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get startTime => $_getI64(4);
  @$pb.TagNumber(5)
  set startTime($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasStartTime() => $_has(4);
  @$pb.TagNumber(5)
  void clearStartTime() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get endTime => $_getI64(5);
  @$pb.TagNumber(6)
  set endTime($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasEndTime() => $_has(5);
  @$pb.TagNumber(6)
  void clearEndTime() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get vehiclePlate => $_getSZ(6);
  @$pb.TagNumber(7)
  set vehiclePlate($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasVehiclePlate() => $_has(6);
  @$pb.TagNumber(7)
  void clearVehiclePlate() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.double get totalPrice => $_getN(7);
  @$pb.TagNumber(8)
  set totalPrice($core.double value) => $_setDouble(7, value);
  @$pb.TagNumber(8)
  $core.bool hasTotalPrice() => $_has(7);
  @$pb.TagNumber(8)
  void clearTotalPrice() => $_clearField(8);

  @$pb.TagNumber(9)
  ReservationStatus get status => $_getN(8);
  @$pb.TagNumber(9)
  set status(ReservationStatus value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasStatus() => $_has(8);
  @$pb.TagNumber(9)
  void clearStatus() => $_clearField(9);

  @$pb.TagNumber(10)
  $fixnum.Int64 get createdAt => $_getI64(9);
  @$pb.TagNumber(10)
  set createdAt($fixnum.Int64 value) => $_setInt64(9, value);
  @$pb.TagNumber(10)
  $core.bool hasCreatedAt() => $_has(9);
  @$pb.TagNumber(10)
  void clearCreatedAt() => $_clearField(10);
}

class ListReservationsRequest extends $pb.GeneratedMessage {
  factory ListReservationsRequest({
    $core.String? userId,
    ReservationStatus? statusFilter,
  }) {
    final result = create();
    if (userId != null) result.userId = userId;
    if (statusFilter != null) result.statusFilter = statusFilter;
    return result;
  }

  ListReservationsRequest._();

  factory ListReservationsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListReservationsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListReservationsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'parking'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'userId')
    ..aE<ReservationStatus>(2, _omitFieldNames ? '' : 'statusFilter',
        enumValues: ReservationStatus.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListReservationsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListReservationsRequest copyWith(
          void Function(ListReservationsRequest) updates) =>
      super.copyWith((message) => updates(message as ListReservationsRequest))
          as ListReservationsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListReservationsRequest create() => ListReservationsRequest._();
  @$core.override
  ListReservationsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListReservationsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListReservationsRequest>(create);
  static ListReservationsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userId => $_getSZ(0);
  @$pb.TagNumber(1)
  set userId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => $_clearField(1);

  @$pb.TagNumber(2)
  ReservationStatus get statusFilter => $_getN(1);
  @$pb.TagNumber(2)
  set statusFilter(ReservationStatus value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasStatusFilter() => $_has(1);
  @$pb.TagNumber(2)
  void clearStatusFilter() => $_clearField(2);
}

class ListReservationsResponse extends $pb.GeneratedMessage {
  factory ListReservationsResponse({
    $core.Iterable<Reservation>? reservations,
  }) {
    final result = create();
    if (reservations != null) result.reservations.addAll(reservations);
    return result;
  }

  ListReservationsResponse._();

  factory ListReservationsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListReservationsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListReservationsResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'parking'),
      createEmptyInstance: create)
    ..pPM<Reservation>(1, _omitFieldNames ? '' : 'reservations',
        subBuilder: Reservation.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListReservationsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListReservationsResponse copyWith(
          void Function(ListReservationsResponse) updates) =>
      super.copyWith((message) => updates(message as ListReservationsResponse))
          as ListReservationsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListReservationsResponse create() => ListReservationsResponse._();
  @$core.override
  ListReservationsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListReservationsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListReservationsResponse>(create);
  static ListReservationsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Reservation> get reservations => $_getList(0);
}

class CancelReservationRequest extends $pb.GeneratedMessage {
  factory CancelReservationRequest({
    $core.String? reservationId,
    $core.String? userId,
  }) {
    final result = create();
    if (reservationId != null) result.reservationId = reservationId;
    if (userId != null) result.userId = userId;
    return result;
  }

  CancelReservationRequest._();

  factory CancelReservationRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CancelReservationRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CancelReservationRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'parking'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'reservationId')
    ..aOS(2, _omitFieldNames ? '' : 'userId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancelReservationRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancelReservationRequest copyWith(
          void Function(CancelReservationRequest) updates) =>
      super.copyWith((message) => updates(message as CancelReservationRequest))
          as CancelReservationRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CancelReservationRequest create() => CancelReservationRequest._();
  @$core.override
  CancelReservationRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CancelReservationRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CancelReservationRequest>(create);
  static CancelReservationRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get reservationId => $_getSZ(0);
  @$pb.TagNumber(1)
  set reservationId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasReservationId() => $_has(0);
  @$pb.TagNumber(1)
  void clearReservationId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get userId => $_getSZ(1);
  @$pb.TagNumber(2)
  set userId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUserId() => $_has(1);
  @$pb.TagNumber(2)
  void clearUserId() => $_clearField(2);
}

class CancelReservationResponse extends $pb.GeneratedMessage {
  factory CancelReservationResponse({
    $core.bool? success,
    $core.String? message,
  }) {
    final result = create();
    if (success != null) result.success = success;
    if (message != null) result.message = message;
    return result;
  }

  CancelReservationResponse._();

  factory CancelReservationResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CancelReservationResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CancelReservationResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'parking'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancelReservationResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancelReservationResponse copyWith(
          void Function(CancelReservationResponse) updates) =>
      super.copyWith((message) => updates(message as CancelReservationResponse))
          as CancelReservationResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CancelReservationResponse create() => CancelReservationResponse._();
  @$core.override
  CancelReservationResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CancelReservationResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CancelReservationResponse>(create);
  static CancelReservationResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get message => $_getSZ(1);
  @$pb.TagNumber(2)
  set message($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessage() => $_clearField(2);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
