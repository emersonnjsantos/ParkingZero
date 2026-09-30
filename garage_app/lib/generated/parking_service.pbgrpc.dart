// This is a generated file - do not edit.
//
// Generated from parking_service.proto.

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

import 'parking_service.pb.dart' as $0;

export 'parking_service.pb.dart';

@$pb.GrpcServiceName('parking.ParkingService')
class ParkingServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  ParkingServiceClient(super.channel, {super.options, super.interceptors});

  /// Busca de Garagens
  $grpc.ResponseFuture<$0.SearchResponse> searchGarages(
    $0.SearchRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$searchGarages, request, options: options);
  }

  $grpc.ResponseFuture<$0.Garage> getGarage(
    $0.GetGarageRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getGarage, request, options: options);
  }

  /// Sistema de Reservas
  $grpc.ResponseFuture<$0.Reservation> createReservation(
    $0.CreateReservationRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$createReservation, request, options: options);
  }

  $grpc.ResponseFuture<$0.ListReservationsResponse> listReservations(
    $0.ListReservationsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listReservations, request, options: options);
  }

  $grpc.ResponseFuture<$0.CancelReservationResponse> cancelReservation(
    $0.CancelReservationRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$cancelReservation, request, options: options);
  }

  // method descriptors

  static final _$searchGarages =
      $grpc.ClientMethod<$0.SearchRequest, $0.SearchResponse>(
          '/parking.ParkingService/SearchGarages',
          ($0.SearchRequest value) => value.writeToBuffer(),
          $0.SearchResponse.fromBuffer);
  static final _$getGarage = $grpc.ClientMethod<$0.GetGarageRequest, $0.Garage>(
      '/parking.ParkingService/GetGarage',
      ($0.GetGarageRequest value) => value.writeToBuffer(),
      $0.Garage.fromBuffer);
  static final _$createReservation =
      $grpc.ClientMethod<$0.CreateReservationRequest, $0.Reservation>(
          '/parking.ParkingService/CreateReservation',
          ($0.CreateReservationRequest value) => value.writeToBuffer(),
          $0.Reservation.fromBuffer);
  static final _$listReservations = $grpc.ClientMethod<
          $0.ListReservationsRequest, $0.ListReservationsResponse>(
      '/parking.ParkingService/ListReservations',
      ($0.ListReservationsRequest value) => value.writeToBuffer(),
      $0.ListReservationsResponse.fromBuffer);
  static final _$cancelReservation = $grpc.ClientMethod<
          $0.CancelReservationRequest, $0.CancelReservationResponse>(
      '/parking.ParkingService/CancelReservation',
      ($0.CancelReservationRequest value) => value.writeToBuffer(),
      $0.CancelReservationResponse.fromBuffer);
}

@$pb.GrpcServiceName('parking.ParkingService')
abstract class ParkingServiceBase extends $grpc.Service {
  $core.String get $name => 'parking.ParkingService';

  ParkingServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.SearchRequest, $0.SearchResponse>(
        'SearchGarages',
        searchGarages_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.SearchRequest.fromBuffer(value),
        ($0.SearchResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetGarageRequest, $0.Garage>(
        'GetGarage',
        getGarage_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.GetGarageRequest.fromBuffer(value),
        ($0.Garage value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.CreateReservationRequest, $0.Reservation>(
        'CreateReservation',
        createReservation_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CreateReservationRequest.fromBuffer(value),
        ($0.Reservation value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ListReservationsRequest,
            $0.ListReservationsResponse>(
        'ListReservations',
        listReservations_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ListReservationsRequest.fromBuffer(value),
        ($0.ListReservationsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.CancelReservationRequest,
            $0.CancelReservationResponse>(
        'CancelReservation',
        cancelReservation_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CancelReservationRequest.fromBuffer(value),
        ($0.CancelReservationResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.SearchResponse> searchGarages_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.SearchRequest> $request) async {
    return searchGarages($call, await $request);
  }

  $async.Future<$0.SearchResponse> searchGarages(
      $grpc.ServiceCall call, $0.SearchRequest request);

  $async.Future<$0.Garage> getGarage_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetGarageRequest> $request) async {
    return getGarage($call, await $request);
  }

  $async.Future<$0.Garage> getGarage(
      $grpc.ServiceCall call, $0.GetGarageRequest request);

  $async.Future<$0.Reservation> createReservation_Pre($grpc.ServiceCall $call,
      $async.Future<$0.CreateReservationRequest> $request) async {
    return createReservation($call, await $request);
  }

  $async.Future<$0.Reservation> createReservation(
      $grpc.ServiceCall call, $0.CreateReservationRequest request);

  $async.Future<$0.ListReservationsResponse> listReservations_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ListReservationsRequest> $request) async {
    return listReservations($call, await $request);
  }

  $async.Future<$0.ListReservationsResponse> listReservations(
      $grpc.ServiceCall call, $0.ListReservationsRequest request);

  $async.Future<$0.CancelReservationResponse> cancelReservation_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.CancelReservationRequest> $request) async {
    return cancelReservation($call, await $request);
  }

  $async.Future<$0.CancelReservationResponse> cancelReservation(
      $grpc.ServiceCall call, $0.CancelReservationRequest request);
}
