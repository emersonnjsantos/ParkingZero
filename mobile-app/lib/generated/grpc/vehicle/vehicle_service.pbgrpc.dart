// This is a generated file - do not edit.
//
// Generated from vehicle/vehicle_service.proto.

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

import 'vehicle_service.pb.dart' as $0;

export 'vehicle_service.pb.dart';

/// VehicleService — Entrada/saída de veículos com latência crítica (B+Tree local)
@$pb.GrpcServiceName('vehicle.VehicleService')
class VehicleServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  VehicleServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.VehicleEntryResponse> recordVehicleEntry(
    $0.VehicleEntryRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$recordVehicleEntry, request, options: options);
  }

  $grpc.ResponseFuture<$0.VehicleExitResponse> recordVehicleExit(
    $0.VehicleExitRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$recordVehicleExit, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetActiveVehiclesResponse> getActiveVehicles(
    $0.GetActiveVehiclesRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getActiveVehicles, request, options: options);
  }

  $grpc.ResponseFuture<$0.VehicleEntry> getVehicleEntry(
    $0.GetVehicleEntryRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getVehicleEntry, request, options: options);
  }

  // method descriptors

  static final _$recordVehicleEntry =
      $grpc.ClientMethod<$0.VehicleEntryRequest, $0.VehicleEntryResponse>(
          '/vehicle.VehicleService/RecordVehicleEntry',
          ($0.VehicleEntryRequest value) => value.writeToBuffer(),
          $0.VehicleEntryResponse.fromBuffer);
  static final _$recordVehicleExit =
      $grpc.ClientMethod<$0.VehicleExitRequest, $0.VehicleExitResponse>(
          '/vehicle.VehicleService/RecordVehicleExit',
          ($0.VehicleExitRequest value) => value.writeToBuffer(),
          $0.VehicleExitResponse.fromBuffer);
  static final _$getActiveVehicles = $grpc.ClientMethod<
          $0.GetActiveVehiclesRequest, $0.GetActiveVehiclesResponse>(
      '/vehicle.VehicleService/GetActiveVehicles',
      ($0.GetActiveVehiclesRequest value) => value.writeToBuffer(),
      $0.GetActiveVehiclesResponse.fromBuffer);
  static final _$getVehicleEntry =
      $grpc.ClientMethod<$0.GetVehicleEntryRequest, $0.VehicleEntry>(
          '/vehicle.VehicleService/GetVehicleEntry',
          ($0.GetVehicleEntryRequest value) => value.writeToBuffer(),
          $0.VehicleEntry.fromBuffer);
}

@$pb.GrpcServiceName('vehicle.VehicleService')
abstract class VehicleServiceBase extends $grpc.Service {
  $core.String get $name => 'vehicle.VehicleService';

  VehicleServiceBase() {
    $addMethod(
        $grpc.ServiceMethod<$0.VehicleEntryRequest, $0.VehicleEntryResponse>(
            'RecordVehicleEntry',
            recordVehicleEntry_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.VehicleEntryRequest.fromBuffer(value),
            ($0.VehicleEntryResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.VehicleExitRequest, $0.VehicleExitResponse>(
            'RecordVehicleExit',
            recordVehicleExit_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.VehicleExitRequest.fromBuffer(value),
            ($0.VehicleExitResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetActiveVehiclesRequest,
            $0.GetActiveVehiclesResponse>(
        'GetActiveVehicles',
        getActiveVehicles_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetActiveVehiclesRequest.fromBuffer(value),
        ($0.GetActiveVehiclesResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetVehicleEntryRequest, $0.VehicleEntry>(
        'GetVehicleEntry',
        getVehicleEntry_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetVehicleEntryRequest.fromBuffer(value),
        ($0.VehicleEntry value) => value.writeToBuffer()));
  }

  $async.Future<$0.VehicleEntryResponse> recordVehicleEntry_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.VehicleEntryRequest> $request) async {
    return recordVehicleEntry($call, await $request);
  }

  $async.Future<$0.VehicleEntryResponse> recordVehicleEntry(
      $grpc.ServiceCall call, $0.VehicleEntryRequest request);

  $async.Future<$0.VehicleExitResponse> recordVehicleExit_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.VehicleExitRequest> $request) async {
    return recordVehicleExit($call, await $request);
  }

  $async.Future<$0.VehicleExitResponse> recordVehicleExit(
      $grpc.ServiceCall call, $0.VehicleExitRequest request);

  $async.Future<$0.GetActiveVehiclesResponse> getActiveVehicles_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetActiveVehiclesRequest> $request) async {
    return getActiveVehicles($call, await $request);
  }

  $async.Future<$0.GetActiveVehiclesResponse> getActiveVehicles(
      $grpc.ServiceCall call, $0.GetActiveVehiclesRequest request);

  $async.Future<$0.VehicleEntry> getVehicleEntry_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetVehicleEntryRequest> $request) async {
    return getVehicleEntry($call, await $request);
  }

  $async.Future<$0.VehicleEntry> getVehicleEntry(
      $grpc.ServiceCall call, $0.GetVehicleEntryRequest request);
}
