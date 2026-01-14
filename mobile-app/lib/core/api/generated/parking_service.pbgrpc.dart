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

  $grpc.ResponseFuture<$0.SearchResponse> searchGarages(
    $0.SearchRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$searchGarages, request, options: options);
  }

  // method descriptors

  static final _$searchGarages =
      $grpc.ClientMethod<$0.SearchRequest, $0.SearchResponse>(
          '/parking.ParkingService/SearchGarages',
          ($0.SearchRequest value) => value.writeToBuffer(),
          $0.SearchResponse.fromBuffer);
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
  }

  $async.Future<$0.SearchResponse> searchGarages_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.SearchRequest> $request) async {
    return searchGarages($call, await $request);
  }

  $async.Future<$0.SearchResponse> searchGarages(
      $grpc.ServiceCall call, $0.SearchRequest request);
}
