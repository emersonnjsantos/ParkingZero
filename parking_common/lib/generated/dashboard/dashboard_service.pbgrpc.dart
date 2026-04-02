// This is a generated file - do not edit.
//
// Generated from dashboard/dashboard_service.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'package:protobuf/protobuf.dart' as $pb;

import 'dashboard_service.pb.dart' as $0;

export 'dashboard_service.pb.dart';

/// DashboardService — Analytics e relatórios para donos e lojas
@$pb.GrpcServiceName('dashboard.DashboardService')
class DashboardServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  DashboardServiceClient(super.channel, {super.options, super.interceptors});

  /// Resumo geral do estacionamento
  $grpc.ResponseFuture<$0.ParkingSummary> getParkingSummary(
    $0.GetParkingSummaryRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getParkingSummary, request, options: options);
  }

  /// Receita por período
  $grpc.ResponseFuture<$0.RevenueReport> getRevenueReport(
    $0.GetRevenueReportRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getRevenueReport, request, options: options);
  }

  /// Resumo de patrocínios para lojas
  $grpc.ResponseFuture<$0.StoreSponsorshipSummary> getStoreSponsorshipSummary(
    $0.GetStoreSummaryRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getStoreSponsorshipSummary, request,
        options: options);
  }

  /// Ocupação em tempo real
  $grpc.ResponseFuture<$0.OccupancyStats> getOccupancyStats(
    $0.GetOccupancyRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getOccupancyStats, request, options: options);
  }

  /// Eventos BI (admin)
  $grpc.ResponseFuture<$0.ListBIEventsResponse> listBIEvents(
    $0.ListBIEventsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listBIEvents, request, options: options);
  }

  // method descriptors

  static final _$getParkingSummary =
      $grpc.ClientMethod<$0.GetParkingSummaryRequest, $0.ParkingSummary>(
          '/dashboard.DashboardService/GetParkingSummary',
          ($0.GetParkingSummaryRequest value) => value.writeToBuffer(),
          $0.ParkingSummary.fromBuffer);
  static final _$getRevenueReport =
      $grpc.ClientMethod<$0.GetRevenueReportRequest, $0.RevenueReport>(
          '/dashboard.DashboardService/GetRevenueReport',
          ($0.GetRevenueReportRequest value) => value.writeToBuffer(),
          $0.RevenueReport.fromBuffer);
  static final _$getStoreSponsorshipSummary =
      $grpc.ClientMethod<$0.GetStoreSummaryRequest, $0.StoreSponsorshipSummary>(
          '/dashboard.DashboardService/GetStoreSponsorshipSummary',
          ($0.GetStoreSummaryRequest value) => value.writeToBuffer(),
          $0.StoreSponsorshipSummary.fromBuffer);
  static final _$getOccupancyStats =
      $grpc.ClientMethod<$0.GetOccupancyRequest, $0.OccupancyStats>(
          '/dashboard.DashboardService/GetOccupancyStats',
          ($0.GetOccupancyRequest value) => value.writeToBuffer(),
          $0.OccupancyStats.fromBuffer);
  static final _$listBIEvents =
      $grpc.ClientMethod<$0.ListBIEventsRequest, $0.ListBIEventsResponse>(
          '/dashboard.DashboardService/ListBIEvents',
          ($0.ListBIEventsRequest value) => value.writeToBuffer(),
          $0.ListBIEventsResponse.fromBuffer);
}

@$pb.GrpcServiceName('dashboard.DashboardService')
abstract class DashboardServiceBase extends $grpc.Service {
  $core.String get $name => 'dashboard.DashboardService';

  DashboardServiceBase() {
    $addMethod(
        $grpc.ServiceMethod<$0.GetParkingSummaryRequest, $0.ParkingSummary>(
            'GetParkingSummary',
            getParkingSummary_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.GetParkingSummaryRequest.fromBuffer(value),
            ($0.ParkingSummary value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.GetRevenueReportRequest, $0.RevenueReport>(
            'GetRevenueReport',
            getRevenueReport_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.GetRevenueReportRequest.fromBuffer(value),
            ($0.RevenueReport value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetStoreSummaryRequest,
            $0.StoreSponsorshipSummary>(
        'GetStoreSponsorshipSummary',
        getStoreSponsorshipSummary_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetStoreSummaryRequest.fromBuffer(value),
        ($0.StoreSponsorshipSummary value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetOccupancyRequest, $0.OccupancyStats>(
        'GetOccupancyStats',
        getOccupancyStats_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetOccupancyRequest.fromBuffer(value),
        ($0.OccupancyStats value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.ListBIEventsRequest, $0.ListBIEventsResponse>(
            'ListBIEvents',
            listBIEvents_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.ListBIEventsRequest.fromBuffer(value),
            ($0.ListBIEventsResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.ParkingSummary> getParkingSummary_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetParkingSummaryRequest> $request) async {
    return getParkingSummary($call, await $request);
  }

  $async.Future<$0.ParkingSummary> getParkingSummary(
      $grpc.ServiceCall call, $0.GetParkingSummaryRequest request);

  $async.Future<$0.RevenueReport> getRevenueReport_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetRevenueReportRequest> $request) async {
    return getRevenueReport($call, await $request);
  }

  $async.Future<$0.RevenueReport> getRevenueReport(
      $grpc.ServiceCall call, $0.GetRevenueReportRequest request);

  $async.Future<$0.StoreSponsorshipSummary> getStoreSponsorshipSummary_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetStoreSummaryRequest> $request) async {
    return getStoreSponsorshipSummary($call, await $request);
  }

  $async.Future<$0.StoreSponsorshipSummary> getStoreSponsorshipSummary(
      $grpc.ServiceCall call, $0.GetStoreSummaryRequest request);

  $async.Future<$0.OccupancyStats> getOccupancyStats_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetOccupancyRequest> $request) async {
    return getOccupancyStats($call, await $request);
  }

  $async.Future<$0.OccupancyStats> getOccupancyStats(
      $grpc.ServiceCall call, $0.GetOccupancyRequest request);

  $async.Future<$0.ListBIEventsResponse> listBIEvents_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ListBIEventsRequest> $request) async {
    return listBIEvents($call, await $request);
  }

  $async.Future<$0.ListBIEventsResponse> listBIEvents(
      $grpc.ServiceCall call, $0.ListBIEventsRequest request);
}
