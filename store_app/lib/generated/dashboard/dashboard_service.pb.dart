// This is a generated file - do not edit.
//
// Generated from dashboard/dashboard_service.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class GetParkingSummaryRequest extends $pb.GeneratedMessage {
  factory GetParkingSummaryRequest({
    $core.String? garageId,
    $fixnum.Int64? fromTimestamp,
    $fixnum.Int64? toTimestamp,
  }) {
    final result = create();
    if (garageId != null) result.garageId = garageId;
    if (fromTimestamp != null) result.fromTimestamp = fromTimestamp;
    if (toTimestamp != null) result.toTimestamp = toTimestamp;
    return result;
  }

  GetParkingSummaryRequest._();

  factory GetParkingSummaryRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetParkingSummaryRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetParkingSummaryRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'dashboard'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'garageId')
    ..aInt64(2, _omitFieldNames ? '' : 'fromTimestamp')
    ..aInt64(3, _omitFieldNames ? '' : 'toTimestamp')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetParkingSummaryRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetParkingSummaryRequest copyWith(
          void Function(GetParkingSummaryRequest) updates) =>
      super.copyWith((message) => updates(message as GetParkingSummaryRequest))
          as GetParkingSummaryRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetParkingSummaryRequest create() => GetParkingSummaryRequest._();
  @$core.override
  GetParkingSummaryRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetParkingSummaryRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetParkingSummaryRequest>(create);
  static GetParkingSummaryRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get garageId => $_getSZ(0);
  @$pb.TagNumber(1)
  set garageId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasGarageId() => $_has(0);
  @$pb.TagNumber(1)
  void clearGarageId() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get fromTimestamp => $_getI64(1);
  @$pb.TagNumber(2)
  set fromTimestamp($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFromTimestamp() => $_has(1);
  @$pb.TagNumber(2)
  void clearFromTimestamp() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get toTimestamp => $_getI64(2);
  @$pb.TagNumber(3)
  set toTimestamp($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasToTimestamp() => $_has(2);
  @$pb.TagNumber(3)
  void clearToTimestamp() => $_clearField(3);
}

class ParkingSummary extends $pb.GeneratedMessage {
  factory ParkingSummary({
    $core.String? garageId,
    $core.int? totalEntries,
    $core.int? totalExits,
    $core.int? currentOccupancy,
    $core.double? totalRevenue,
    $core.double? totalSponsored,
    $core.double? averageStayHours,
    $fixnum.Int64? periodStart,
    $fixnum.Int64? periodEnd,
  }) {
    final result = create();
    if (garageId != null) result.garageId = garageId;
    if (totalEntries != null) result.totalEntries = totalEntries;
    if (totalExits != null) result.totalExits = totalExits;
    if (currentOccupancy != null) result.currentOccupancy = currentOccupancy;
    if (totalRevenue != null) result.totalRevenue = totalRevenue;
    if (totalSponsored != null) result.totalSponsored = totalSponsored;
    if (averageStayHours != null) result.averageStayHours = averageStayHours;
    if (periodStart != null) result.periodStart = periodStart;
    if (periodEnd != null) result.periodEnd = periodEnd;
    return result;
  }

  ParkingSummary._();

  factory ParkingSummary.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ParkingSummary.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ParkingSummary',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'dashboard'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'garageId')
    ..aI(2, _omitFieldNames ? '' : 'totalEntries')
    ..aI(3, _omitFieldNames ? '' : 'totalExits')
    ..aI(4, _omitFieldNames ? '' : 'currentOccupancy')
    ..aD(5, _omitFieldNames ? '' : 'totalRevenue')
    ..aD(6, _omitFieldNames ? '' : 'totalSponsored')
    ..aD(7, _omitFieldNames ? '' : 'averageStayHours')
    ..aInt64(8, _omitFieldNames ? '' : 'periodStart')
    ..aInt64(9, _omitFieldNames ? '' : 'periodEnd')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ParkingSummary clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ParkingSummary copyWith(void Function(ParkingSummary) updates) =>
      super.copyWith((message) => updates(message as ParkingSummary))
          as ParkingSummary;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ParkingSummary create() => ParkingSummary._();
  @$core.override
  ParkingSummary createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ParkingSummary getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ParkingSummary>(create);
  static ParkingSummary? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get garageId => $_getSZ(0);
  @$pb.TagNumber(1)
  set garageId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasGarageId() => $_has(0);
  @$pb.TagNumber(1)
  void clearGarageId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get totalEntries => $_getIZ(1);
  @$pb.TagNumber(2)
  set totalEntries($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTotalEntries() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotalEntries() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get totalExits => $_getIZ(2);
  @$pb.TagNumber(3)
  set totalExits($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTotalExits() => $_has(2);
  @$pb.TagNumber(3)
  void clearTotalExits() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get currentOccupancy => $_getIZ(3);
  @$pb.TagNumber(4)
  set currentOccupancy($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCurrentOccupancy() => $_has(3);
  @$pb.TagNumber(4)
  void clearCurrentOccupancy() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get totalRevenue => $_getN(4);
  @$pb.TagNumber(5)
  set totalRevenue($core.double value) => $_setDouble(4, value);
  @$pb.TagNumber(5)
  $core.bool hasTotalRevenue() => $_has(4);
  @$pb.TagNumber(5)
  void clearTotalRevenue() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get totalSponsored => $_getN(5);
  @$pb.TagNumber(6)
  set totalSponsored($core.double value) => $_setDouble(5, value);
  @$pb.TagNumber(6)
  $core.bool hasTotalSponsored() => $_has(5);
  @$pb.TagNumber(6)
  void clearTotalSponsored() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.double get averageStayHours => $_getN(6);
  @$pb.TagNumber(7)
  set averageStayHours($core.double value) => $_setDouble(6, value);
  @$pb.TagNumber(7)
  $core.bool hasAverageStayHours() => $_has(6);
  @$pb.TagNumber(7)
  void clearAverageStayHours() => $_clearField(7);

  @$pb.TagNumber(8)
  $fixnum.Int64 get periodStart => $_getI64(7);
  @$pb.TagNumber(8)
  set periodStart($fixnum.Int64 value) => $_setInt64(7, value);
  @$pb.TagNumber(8)
  $core.bool hasPeriodStart() => $_has(7);
  @$pb.TagNumber(8)
  void clearPeriodStart() => $_clearField(8);

  @$pb.TagNumber(9)
  $fixnum.Int64 get periodEnd => $_getI64(8);
  @$pb.TagNumber(9)
  set periodEnd($fixnum.Int64 value) => $_setInt64(8, value);
  @$pb.TagNumber(9)
  $core.bool hasPeriodEnd() => $_has(8);
  @$pb.TagNumber(9)
  void clearPeriodEnd() => $_clearField(9);
}

class GetRevenueReportRequest extends $pb.GeneratedMessage {
  factory GetRevenueReportRequest({
    $core.String? garageId,
    $core.String? period,
    $fixnum.Int64? fromTimestamp,
    $fixnum.Int64? toTimestamp,
  }) {
    final result = create();
    if (garageId != null) result.garageId = garageId;
    if (period != null) result.period = period;
    if (fromTimestamp != null) result.fromTimestamp = fromTimestamp;
    if (toTimestamp != null) result.toTimestamp = toTimestamp;
    return result;
  }

  GetRevenueReportRequest._();

  factory GetRevenueReportRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetRevenueReportRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetRevenueReportRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'dashboard'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'garageId')
    ..aOS(2, _omitFieldNames ? '' : 'period')
    ..aInt64(3, _omitFieldNames ? '' : 'fromTimestamp')
    ..aInt64(4, _omitFieldNames ? '' : 'toTimestamp')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRevenueReportRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRevenueReportRequest copyWith(
          void Function(GetRevenueReportRequest) updates) =>
      super.copyWith((message) => updates(message as GetRevenueReportRequest))
          as GetRevenueReportRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetRevenueReportRequest create() => GetRevenueReportRequest._();
  @$core.override
  GetRevenueReportRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetRevenueReportRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetRevenueReportRequest>(create);
  static GetRevenueReportRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get garageId => $_getSZ(0);
  @$pb.TagNumber(1)
  set garageId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasGarageId() => $_has(0);
  @$pb.TagNumber(1)
  void clearGarageId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get period => $_getSZ(1);
  @$pb.TagNumber(2)
  set period($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPeriod() => $_has(1);
  @$pb.TagNumber(2)
  void clearPeriod() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get fromTimestamp => $_getI64(2);
  @$pb.TagNumber(3)
  set fromTimestamp($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFromTimestamp() => $_has(2);
  @$pb.TagNumber(3)
  void clearFromTimestamp() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get toTimestamp => $_getI64(3);
  @$pb.TagNumber(4)
  set toTimestamp($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasToTimestamp() => $_has(3);
  @$pb.TagNumber(4)
  void clearToTimestamp() => $_clearField(4);
}

class RevenueReport extends $pb.GeneratedMessage {
  factory RevenueReport({
    $core.String? garageId,
    $core.double? totalRevenue,
    $core.double? totalSponsored,
    $core.double? netRevenue,
    $core.Iterable<DailyRevenue>? dailyBreakdown,
    $core.int? totalTransactions,
  }) {
    final result = create();
    if (garageId != null) result.garageId = garageId;
    if (totalRevenue != null) result.totalRevenue = totalRevenue;
    if (totalSponsored != null) result.totalSponsored = totalSponsored;
    if (netRevenue != null) result.netRevenue = netRevenue;
    if (dailyBreakdown != null) result.dailyBreakdown.addAll(dailyBreakdown);
    if (totalTransactions != null) result.totalTransactions = totalTransactions;
    return result;
  }

  RevenueReport._();

  factory RevenueReport.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RevenueReport.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RevenueReport',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'dashboard'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'garageId')
    ..aD(2, _omitFieldNames ? '' : 'totalRevenue')
    ..aD(3, _omitFieldNames ? '' : 'totalSponsored')
    ..aD(4, _omitFieldNames ? '' : 'netRevenue')
    ..pPM<DailyRevenue>(5, _omitFieldNames ? '' : 'dailyBreakdown',
        subBuilder: DailyRevenue.create)
    ..aI(6, _omitFieldNames ? '' : 'totalTransactions')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RevenueReport clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RevenueReport copyWith(void Function(RevenueReport) updates) =>
      super.copyWith((message) => updates(message as RevenueReport))
          as RevenueReport;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RevenueReport create() => RevenueReport._();
  @$core.override
  RevenueReport createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RevenueReport getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RevenueReport>(create);
  static RevenueReport? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get garageId => $_getSZ(0);
  @$pb.TagNumber(1)
  set garageId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasGarageId() => $_has(0);
  @$pb.TagNumber(1)
  void clearGarageId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get totalRevenue => $_getN(1);
  @$pb.TagNumber(2)
  set totalRevenue($core.double value) => $_setDouble(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTotalRevenue() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotalRevenue() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get totalSponsored => $_getN(2);
  @$pb.TagNumber(3)
  set totalSponsored($core.double value) => $_setDouble(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTotalSponsored() => $_has(2);
  @$pb.TagNumber(3)
  void clearTotalSponsored() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get netRevenue => $_getN(3);
  @$pb.TagNumber(4)
  set netRevenue($core.double value) => $_setDouble(3, value);
  @$pb.TagNumber(4)
  $core.bool hasNetRevenue() => $_has(3);
  @$pb.TagNumber(4)
  void clearNetRevenue() => $_clearField(4);

  @$pb.TagNumber(5)
  $pb.PbList<DailyRevenue> get dailyBreakdown => $_getList(4);

  @$pb.TagNumber(6)
  $core.int get totalTransactions => $_getIZ(5);
  @$pb.TagNumber(6)
  set totalTransactions($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasTotalTransactions() => $_has(5);
  @$pb.TagNumber(6)
  void clearTotalTransactions() => $_clearField(6);
}

class DailyRevenue extends $pb.GeneratedMessage {
  factory DailyRevenue({
    $core.String? date,
    $core.double? revenue,
    $core.double? sponsored,
    $core.int? entries,
    $core.int? exits,
  }) {
    final result = create();
    if (date != null) result.date = date;
    if (revenue != null) result.revenue = revenue;
    if (sponsored != null) result.sponsored = sponsored;
    if (entries != null) result.entries = entries;
    if (exits != null) result.exits = exits;
    return result;
  }

  DailyRevenue._();

  factory DailyRevenue.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DailyRevenue.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DailyRevenue',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'dashboard'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'date')
    ..aD(2, _omitFieldNames ? '' : 'revenue')
    ..aD(3, _omitFieldNames ? '' : 'sponsored')
    ..aI(4, _omitFieldNames ? '' : 'entries')
    ..aI(5, _omitFieldNames ? '' : 'exits')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DailyRevenue clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DailyRevenue copyWith(void Function(DailyRevenue) updates) =>
      super.copyWith((message) => updates(message as DailyRevenue))
          as DailyRevenue;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DailyRevenue create() => DailyRevenue._();
  @$core.override
  DailyRevenue createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DailyRevenue getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DailyRevenue>(create);
  static DailyRevenue? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get date => $_getSZ(0);
  @$pb.TagNumber(1)
  set date($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDate() => $_has(0);
  @$pb.TagNumber(1)
  void clearDate() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get revenue => $_getN(1);
  @$pb.TagNumber(2)
  set revenue($core.double value) => $_setDouble(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRevenue() => $_has(1);
  @$pb.TagNumber(2)
  void clearRevenue() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get sponsored => $_getN(2);
  @$pb.TagNumber(3)
  set sponsored($core.double value) => $_setDouble(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSponsored() => $_has(2);
  @$pb.TagNumber(3)
  void clearSponsored() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get entries => $_getIZ(3);
  @$pb.TagNumber(4)
  set entries($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasEntries() => $_has(3);
  @$pb.TagNumber(4)
  void clearEntries() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get exits => $_getIZ(4);
  @$pb.TagNumber(5)
  set exits($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasExits() => $_has(4);
  @$pb.TagNumber(5)
  void clearExits() => $_clearField(5);
}

class GetStoreSummaryRequest extends $pb.GeneratedMessage {
  factory GetStoreSummaryRequest({
    $core.String? storeId,
    $fixnum.Int64? fromTimestamp,
    $fixnum.Int64? toTimestamp,
  }) {
    final result = create();
    if (storeId != null) result.storeId = storeId;
    if (fromTimestamp != null) result.fromTimestamp = fromTimestamp;
    if (toTimestamp != null) result.toTimestamp = toTimestamp;
    return result;
  }

  GetStoreSummaryRequest._();

  factory GetStoreSummaryRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetStoreSummaryRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetStoreSummaryRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'dashboard'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'storeId')
    ..aInt64(2, _omitFieldNames ? '' : 'fromTimestamp')
    ..aInt64(3, _omitFieldNames ? '' : 'toTimestamp')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetStoreSummaryRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetStoreSummaryRequest copyWith(
          void Function(GetStoreSummaryRequest) updates) =>
      super.copyWith((message) => updates(message as GetStoreSummaryRequest))
          as GetStoreSummaryRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetStoreSummaryRequest create() => GetStoreSummaryRequest._();
  @$core.override
  GetStoreSummaryRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetStoreSummaryRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetStoreSummaryRequest>(create);
  static GetStoreSummaryRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get storeId => $_getSZ(0);
  @$pb.TagNumber(1)
  set storeId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasStoreId() => $_has(0);
  @$pb.TagNumber(1)
  void clearStoreId() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get fromTimestamp => $_getI64(1);
  @$pb.TagNumber(2)
  set fromTimestamp($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFromTimestamp() => $_has(1);
  @$pb.TagNumber(2)
  void clearFromTimestamp() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get toTimestamp => $_getI64(2);
  @$pb.TagNumber(3)
  set toTimestamp($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasToTimestamp() => $_has(2);
  @$pb.TagNumber(3)
  void clearToTimestamp() => $_clearField(3);
}

class StoreSponsorshipSummary extends $pb.GeneratedMessage {
  factory StoreSponsorshipSummary({
    $core.String? storeId,
    $core.String? storeName,
    $core.double? totalSpent,
    $core.int? totalSponsorships,
    $core.int? uniqueCustomers,
    $core.double? averageInvoice,
    $core.Iterable<MonthlySponsorshipStats>? monthly,
  }) {
    final result = create();
    if (storeId != null) result.storeId = storeId;
    if (storeName != null) result.storeName = storeName;
    if (totalSpent != null) result.totalSpent = totalSpent;
    if (totalSponsorships != null) result.totalSponsorships = totalSponsorships;
    if (uniqueCustomers != null) result.uniqueCustomers = uniqueCustomers;
    if (averageInvoice != null) result.averageInvoice = averageInvoice;
    if (monthly != null) result.monthly.addAll(monthly);
    return result;
  }

  StoreSponsorshipSummary._();

  factory StoreSponsorshipSummary.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StoreSponsorshipSummary.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StoreSponsorshipSummary',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'dashboard'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'storeId')
    ..aOS(2, _omitFieldNames ? '' : 'storeName')
    ..aD(3, _omitFieldNames ? '' : 'totalSpent')
    ..aI(4, _omitFieldNames ? '' : 'totalSponsorships')
    ..aI(5, _omitFieldNames ? '' : 'uniqueCustomers')
    ..aD(6, _omitFieldNames ? '' : 'averageInvoice')
    ..pPM<MonthlySponsorshipStats>(7, _omitFieldNames ? '' : 'monthly',
        subBuilder: MonthlySponsorshipStats.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StoreSponsorshipSummary clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StoreSponsorshipSummary copyWith(
          void Function(StoreSponsorshipSummary) updates) =>
      super.copyWith((message) => updates(message as StoreSponsorshipSummary))
          as StoreSponsorshipSummary;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StoreSponsorshipSummary create() => StoreSponsorshipSummary._();
  @$core.override
  StoreSponsorshipSummary createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StoreSponsorshipSummary getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StoreSponsorshipSummary>(create);
  static StoreSponsorshipSummary? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get storeId => $_getSZ(0);
  @$pb.TagNumber(1)
  set storeId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasStoreId() => $_has(0);
  @$pb.TagNumber(1)
  void clearStoreId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get storeName => $_getSZ(1);
  @$pb.TagNumber(2)
  set storeName($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasStoreName() => $_has(1);
  @$pb.TagNumber(2)
  void clearStoreName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get totalSpent => $_getN(2);
  @$pb.TagNumber(3)
  set totalSpent($core.double value) => $_setDouble(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTotalSpent() => $_has(2);
  @$pb.TagNumber(3)
  void clearTotalSpent() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get totalSponsorships => $_getIZ(3);
  @$pb.TagNumber(4)
  set totalSponsorships($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTotalSponsorships() => $_has(3);
  @$pb.TagNumber(4)
  void clearTotalSponsorships() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get uniqueCustomers => $_getIZ(4);
  @$pb.TagNumber(5)
  set uniqueCustomers($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasUniqueCustomers() => $_has(4);
  @$pb.TagNumber(5)
  void clearUniqueCustomers() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get averageInvoice => $_getN(5);
  @$pb.TagNumber(6)
  set averageInvoice($core.double value) => $_setDouble(5, value);
  @$pb.TagNumber(6)
  $core.bool hasAverageInvoice() => $_has(5);
  @$pb.TagNumber(6)
  void clearAverageInvoice() => $_clearField(6);

  @$pb.TagNumber(7)
  $pb.PbList<MonthlySponsorshipStats> get monthly => $_getList(6);
}

class MonthlySponsorshipStats extends $pb.GeneratedMessage {
  factory MonthlySponsorshipStats({
    $core.String? month,
    $core.double? amountSpent,
    $core.int? sponsorshipCount,
    $core.int? customerCount,
  }) {
    final result = create();
    if (month != null) result.month = month;
    if (amountSpent != null) result.amountSpent = amountSpent;
    if (sponsorshipCount != null) result.sponsorshipCount = sponsorshipCount;
    if (customerCount != null) result.customerCount = customerCount;
    return result;
  }

  MonthlySponsorshipStats._();

  factory MonthlySponsorshipStats.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MonthlySponsorshipStats.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MonthlySponsorshipStats',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'dashboard'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'month')
    ..aD(2, _omitFieldNames ? '' : 'amountSpent')
    ..aI(3, _omitFieldNames ? '' : 'sponsorshipCount')
    ..aI(4, _omitFieldNames ? '' : 'customerCount')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MonthlySponsorshipStats clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MonthlySponsorshipStats copyWith(
          void Function(MonthlySponsorshipStats) updates) =>
      super.copyWith((message) => updates(message as MonthlySponsorshipStats))
          as MonthlySponsorshipStats;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MonthlySponsorshipStats create() => MonthlySponsorshipStats._();
  @$core.override
  MonthlySponsorshipStats createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MonthlySponsorshipStats getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MonthlySponsorshipStats>(create);
  static MonthlySponsorshipStats? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get month => $_getSZ(0);
  @$pb.TagNumber(1)
  set month($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMonth() => $_has(0);
  @$pb.TagNumber(1)
  void clearMonth() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get amountSpent => $_getN(1);
  @$pb.TagNumber(2)
  set amountSpent($core.double value) => $_setDouble(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAmountSpent() => $_has(1);
  @$pb.TagNumber(2)
  void clearAmountSpent() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get sponsorshipCount => $_getIZ(2);
  @$pb.TagNumber(3)
  set sponsorshipCount($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSponsorshipCount() => $_has(2);
  @$pb.TagNumber(3)
  void clearSponsorshipCount() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get customerCount => $_getIZ(3);
  @$pb.TagNumber(4)
  set customerCount($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCustomerCount() => $_has(3);
  @$pb.TagNumber(4)
  void clearCustomerCount() => $_clearField(4);
}

class GetOccupancyRequest extends $pb.GeneratedMessage {
  factory GetOccupancyRequest({
    $core.String? garageId,
  }) {
    final result = create();
    if (garageId != null) result.garageId = garageId;
    return result;
  }

  GetOccupancyRequest._();

  factory GetOccupancyRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetOccupancyRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetOccupancyRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'dashboard'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'garageId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetOccupancyRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetOccupancyRequest copyWith(void Function(GetOccupancyRequest) updates) =>
      super.copyWith((message) => updates(message as GetOccupancyRequest))
          as GetOccupancyRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetOccupancyRequest create() => GetOccupancyRequest._();
  @$core.override
  GetOccupancyRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetOccupancyRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetOccupancyRequest>(create);
  static GetOccupancyRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get garageId => $_getSZ(0);
  @$pb.TagNumber(1)
  set garageId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasGarageId() => $_has(0);
  @$pb.TagNumber(1)
  void clearGarageId() => $_clearField(1);
}

class OccupancyStats extends $pb.GeneratedMessage {
  factory OccupancyStats({
    $core.String? garageId,
    $core.int? totalSpots,
    $core.int? occupiedSpots,
    $core.int? availableSpots,
    $core.double? occupancyRate,
    $core.Iterable<HourlyOccupancy>? hourlyTrend,
  }) {
    final result = create();
    if (garageId != null) result.garageId = garageId;
    if (totalSpots != null) result.totalSpots = totalSpots;
    if (occupiedSpots != null) result.occupiedSpots = occupiedSpots;
    if (availableSpots != null) result.availableSpots = availableSpots;
    if (occupancyRate != null) result.occupancyRate = occupancyRate;
    if (hourlyTrend != null) result.hourlyTrend.addAll(hourlyTrend);
    return result;
  }

  OccupancyStats._();

  factory OccupancyStats.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory OccupancyStats.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OccupancyStats',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'dashboard'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'garageId')
    ..aI(2, _omitFieldNames ? '' : 'totalSpots')
    ..aI(3, _omitFieldNames ? '' : 'occupiedSpots')
    ..aI(4, _omitFieldNames ? '' : 'availableSpots')
    ..aD(5, _omitFieldNames ? '' : 'occupancyRate')
    ..pPM<HourlyOccupancy>(6, _omitFieldNames ? '' : 'hourlyTrend',
        subBuilder: HourlyOccupancy.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OccupancyStats clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OccupancyStats copyWith(void Function(OccupancyStats) updates) =>
      super.copyWith((message) => updates(message as OccupancyStats))
          as OccupancyStats;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OccupancyStats create() => OccupancyStats._();
  @$core.override
  OccupancyStats createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static OccupancyStats getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OccupancyStats>(create);
  static OccupancyStats? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get garageId => $_getSZ(0);
  @$pb.TagNumber(1)
  set garageId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasGarageId() => $_has(0);
  @$pb.TagNumber(1)
  void clearGarageId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get totalSpots => $_getIZ(1);
  @$pb.TagNumber(2)
  set totalSpots($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTotalSpots() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotalSpots() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get occupiedSpots => $_getIZ(2);
  @$pb.TagNumber(3)
  set occupiedSpots($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasOccupiedSpots() => $_has(2);
  @$pb.TagNumber(3)
  void clearOccupiedSpots() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get availableSpots => $_getIZ(3);
  @$pb.TagNumber(4)
  set availableSpots($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAvailableSpots() => $_has(3);
  @$pb.TagNumber(4)
  void clearAvailableSpots() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get occupancyRate => $_getN(4);
  @$pb.TagNumber(5)
  set occupancyRate($core.double value) => $_setDouble(4, value);
  @$pb.TagNumber(5)
  $core.bool hasOccupancyRate() => $_has(4);
  @$pb.TagNumber(5)
  void clearOccupancyRate() => $_clearField(5);

  @$pb.TagNumber(6)
  $pb.PbList<HourlyOccupancy> get hourlyTrend => $_getList(5);
}

class HourlyOccupancy extends $pb.GeneratedMessage {
  factory HourlyOccupancy({
    $core.int? hour,
    $core.double? averageOccupancy,
  }) {
    final result = create();
    if (hour != null) result.hour = hour;
    if (averageOccupancy != null) result.averageOccupancy = averageOccupancy;
    return result;
  }

  HourlyOccupancy._();

  factory HourlyOccupancy.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory HourlyOccupancy.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'HourlyOccupancy',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'dashboard'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'hour')
    ..aD(2, _omitFieldNames ? '' : 'averageOccupancy')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HourlyOccupancy clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HourlyOccupancy copyWith(void Function(HourlyOccupancy) updates) =>
      super.copyWith((message) => updates(message as HourlyOccupancy))
          as HourlyOccupancy;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static HourlyOccupancy create() => HourlyOccupancy._();
  @$core.override
  HourlyOccupancy createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static HourlyOccupancy getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<HourlyOccupancy>(create);
  static HourlyOccupancy? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get hour => $_getIZ(0);
  @$pb.TagNumber(1)
  set hour($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasHour() => $_has(0);
  @$pb.TagNumber(1)
  void clearHour() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get averageOccupancy => $_getN(1);
  @$pb.TagNumber(2)
  set averageOccupancy($core.double value) => $_setDouble(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAverageOccupancy() => $_has(1);
  @$pb.TagNumber(2)
  void clearAverageOccupancy() => $_clearField(2);
}

class ListBIEventsRequest extends $pb.GeneratedMessage {
  factory ListBIEventsRequest({
    $core.String? eventType,
    $fixnum.Int64? fromTimestamp,
    $fixnum.Int64? toTimestamp,
    $core.int? limit,
  }) {
    final result = create();
    if (eventType != null) result.eventType = eventType;
    if (fromTimestamp != null) result.fromTimestamp = fromTimestamp;
    if (toTimestamp != null) result.toTimestamp = toTimestamp;
    if (limit != null) result.limit = limit;
    return result;
  }

  ListBIEventsRequest._();

  factory ListBIEventsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListBIEventsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListBIEventsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'dashboard'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'eventType')
    ..aInt64(2, _omitFieldNames ? '' : 'fromTimestamp')
    ..aInt64(3, _omitFieldNames ? '' : 'toTimestamp')
    ..aI(4, _omitFieldNames ? '' : 'limit')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListBIEventsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListBIEventsRequest copyWith(void Function(ListBIEventsRequest) updates) =>
      super.copyWith((message) => updates(message as ListBIEventsRequest))
          as ListBIEventsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListBIEventsRequest create() => ListBIEventsRequest._();
  @$core.override
  ListBIEventsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListBIEventsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListBIEventsRequest>(create);
  static ListBIEventsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get eventType => $_getSZ(0);
  @$pb.TagNumber(1)
  set eventType($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEventType() => $_has(0);
  @$pb.TagNumber(1)
  void clearEventType() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get fromTimestamp => $_getI64(1);
  @$pb.TagNumber(2)
  set fromTimestamp($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFromTimestamp() => $_has(1);
  @$pb.TagNumber(2)
  void clearFromTimestamp() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get toTimestamp => $_getI64(2);
  @$pb.TagNumber(3)
  set toTimestamp($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasToTimestamp() => $_has(2);
  @$pb.TagNumber(3)
  void clearToTimestamp() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get limit => $_getIZ(3);
  @$pb.TagNumber(4)
  set limit($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasLimit() => $_has(3);
  @$pb.TagNumber(4)
  void clearLimit() => $_clearField(4);
}

class ListBIEventsResponse extends $pb.GeneratedMessage {
  factory ListBIEventsResponse({
    $core.Iterable<BIEvent>? events,
    $core.int? totalCount,
  }) {
    final result = create();
    if (events != null) result.events.addAll(events);
    if (totalCount != null) result.totalCount = totalCount;
    return result;
  }

  ListBIEventsResponse._();

  factory ListBIEventsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListBIEventsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListBIEventsResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'dashboard'),
      createEmptyInstance: create)
    ..pPM<BIEvent>(1, _omitFieldNames ? '' : 'events',
        subBuilder: BIEvent.create)
    ..aI(2, _omitFieldNames ? '' : 'totalCount')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListBIEventsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListBIEventsResponse copyWith(void Function(ListBIEventsResponse) updates) =>
      super.copyWith((message) => updates(message as ListBIEventsResponse))
          as ListBIEventsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListBIEventsResponse create() => ListBIEventsResponse._();
  @$core.override
  ListBIEventsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListBIEventsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListBIEventsResponse>(create);
  static ListBIEventsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<BIEvent> get events => $_getList(0);

  @$pb.TagNumber(2)
  $core.int get totalCount => $_getIZ(1);
  @$pb.TagNumber(2)
  set totalCount($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTotalCount() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotalCount() => $_clearField(2);
}

class BIEvent extends $pb.GeneratedMessage {
  factory BIEvent({
    $core.String? eventId,
    $core.String? eventType,
    $core.String? entityId,
    $fixnum.Int64? timestamp,
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>? metadata,
  }) {
    final result = create();
    if (eventId != null) result.eventId = eventId;
    if (eventType != null) result.eventType = eventType;
    if (entityId != null) result.entityId = entityId;
    if (timestamp != null) result.timestamp = timestamp;
    if (metadata != null) result.metadata.addEntries(metadata);
    return result;
  }

  BIEvent._();

  factory BIEvent.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory BIEvent.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BIEvent',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'dashboard'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'eventId')
    ..aOS(2, _omitFieldNames ? '' : 'eventType')
    ..aOS(3, _omitFieldNames ? '' : 'entityId')
    ..aInt64(4, _omitFieldNames ? '' : 'timestamp')
    ..m<$core.String, $core.String>(5, _omitFieldNames ? '' : 'metadata',
        entryClassName: 'BIEvent.MetadataEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('dashboard'))
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BIEvent clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BIEvent copyWith(void Function(BIEvent) updates) =>
      super.copyWith((message) => updates(message as BIEvent)) as BIEvent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BIEvent create() => BIEvent._();
  @$core.override
  BIEvent createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static BIEvent getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BIEvent>(create);
  static BIEvent? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get eventId => $_getSZ(0);
  @$pb.TagNumber(1)
  set eventId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEventId() => $_has(0);
  @$pb.TagNumber(1)
  void clearEventId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get eventType => $_getSZ(1);
  @$pb.TagNumber(2)
  set eventType($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEventType() => $_has(1);
  @$pb.TagNumber(2)
  void clearEventType() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get entityId => $_getSZ(2);
  @$pb.TagNumber(3)
  set entityId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasEntityId() => $_has(2);
  @$pb.TagNumber(3)
  void clearEntityId() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get timestamp => $_getI64(3);
  @$pb.TagNumber(4)
  set timestamp($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTimestamp() => $_has(3);
  @$pb.TagNumber(4)
  void clearTimestamp() => $_clearField(4);

  @$pb.TagNumber(5)
  $pb.PbMap<$core.String, $core.String> get metadata => $_getMap(4);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
