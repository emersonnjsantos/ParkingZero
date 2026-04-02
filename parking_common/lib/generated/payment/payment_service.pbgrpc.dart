// This is a generated file - do not edit.
//
// Generated from payment/payment_service.proto.

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

import 'payment_service.pb.dart' as $0;

export 'payment_service.pb.dart';

/// PaymentService — Sistema de patrocínio de lojas, vouchers e saída
@$pb.GrpcServiceName('payment.PaymentService')
class PaymentServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  PaymentServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.SponsorshipResponse> requestSponsorship(
    $0.SponsorshipRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$requestSponsorship, request, options: options);
  }

  $grpc.ResponseFuture<$0.VoucherStatus> getVoucherStatus(
    $0.GetVoucherStatusRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getVoucherStatus, request, options: options);
  }

  $grpc.ResponseFuture<$0.VerifyExitResponse> verifyExit(
    $0.VerifyExitRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$verifyExit, request, options: options);
  }

  $grpc.ResponseFuture<$0.ConfirmExitResponse> confirmExit(
    $0.ConfirmExitRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$confirmExit, request, options: options);
  }

  $grpc.ResponseFuture<$0.SponsorshipLedgerResponse> getSponsorshipLedger(
    $0.GetSponsorshipLedgerRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getSponsorshipLedger, request, options: options);
  }

  $grpc.ResponseFuture<$0.RegisterUsedVoucherResponse> registerUsedVoucher(
    $0.RegisterUsedVoucherRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$registerUsedVoucher, request, options: options);
  }

  // method descriptors

  static final _$requestSponsorship =
      $grpc.ClientMethod<$0.SponsorshipRequest, $0.SponsorshipResponse>(
          '/payment.PaymentService/RequestSponsorship',
          ($0.SponsorshipRequest value) => value.writeToBuffer(),
          $0.SponsorshipResponse.fromBuffer);
  static final _$getVoucherStatus =
      $grpc.ClientMethod<$0.GetVoucherStatusRequest, $0.VoucherStatus>(
          '/payment.PaymentService/GetVoucherStatus',
          ($0.GetVoucherStatusRequest value) => value.writeToBuffer(),
          $0.VoucherStatus.fromBuffer);
  static final _$verifyExit =
      $grpc.ClientMethod<$0.VerifyExitRequest, $0.VerifyExitResponse>(
          '/payment.PaymentService/VerifyExit',
          ($0.VerifyExitRequest value) => value.writeToBuffer(),
          $0.VerifyExitResponse.fromBuffer);
  static final _$confirmExit =
      $grpc.ClientMethod<$0.ConfirmExitRequest, $0.ConfirmExitResponse>(
          '/payment.PaymentService/ConfirmExit',
          ($0.ConfirmExitRequest value) => value.writeToBuffer(),
          $0.ConfirmExitResponse.fromBuffer);
  static final _$getSponsorshipLedger = $grpc.ClientMethod<
          $0.GetSponsorshipLedgerRequest, $0.SponsorshipLedgerResponse>(
      '/payment.PaymentService/GetSponsorshipLedger',
      ($0.GetSponsorshipLedgerRequest value) => value.writeToBuffer(),
      $0.SponsorshipLedgerResponse.fromBuffer);
  static final _$registerUsedVoucher = $grpc.ClientMethod<
          $0.RegisterUsedVoucherRequest, $0.RegisterUsedVoucherResponse>(
      '/payment.PaymentService/RegisterUsedVoucher',
      ($0.RegisterUsedVoucherRequest value) => value.writeToBuffer(),
      $0.RegisterUsedVoucherResponse.fromBuffer);
}

@$pb.GrpcServiceName('payment.PaymentService')
abstract class PaymentServiceBase extends $grpc.Service {
  $core.String get $name => 'payment.PaymentService';

  PaymentServiceBase() {
    $addMethod(
        $grpc.ServiceMethod<$0.SponsorshipRequest, $0.SponsorshipResponse>(
            'RequestSponsorship',
            requestSponsorship_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.SponsorshipRequest.fromBuffer(value),
            ($0.SponsorshipResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.GetVoucherStatusRequest, $0.VoucherStatus>(
            'GetVoucherStatus',
            getVoucherStatus_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.GetVoucherStatusRequest.fromBuffer(value),
            ($0.VoucherStatus value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.VerifyExitRequest, $0.VerifyExitResponse>(
        'VerifyExit',
        verifyExit_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.VerifyExitRequest.fromBuffer(value),
        ($0.VerifyExitResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.ConfirmExitRequest, $0.ConfirmExitResponse>(
            'ConfirmExit',
            confirmExit_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.ConfirmExitRequest.fromBuffer(value),
            ($0.ConfirmExitResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetSponsorshipLedgerRequest,
            $0.SponsorshipLedgerResponse>(
        'GetSponsorshipLedger',
        getSponsorshipLedger_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetSponsorshipLedgerRequest.fromBuffer(value),
        ($0.SponsorshipLedgerResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.RegisterUsedVoucherRequest,
            $0.RegisterUsedVoucherResponse>(
        'RegisterUsedVoucher',
        registerUsedVoucher_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.RegisterUsedVoucherRequest.fromBuffer(value),
        ($0.RegisterUsedVoucherResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.SponsorshipResponse> requestSponsorship_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.SponsorshipRequest> $request) async {
    return requestSponsorship($call, await $request);
  }

  $async.Future<$0.SponsorshipResponse> requestSponsorship(
      $grpc.ServiceCall call, $0.SponsorshipRequest request);

  $async.Future<$0.VoucherStatus> getVoucherStatus_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetVoucherStatusRequest> $request) async {
    return getVoucherStatus($call, await $request);
  }

  $async.Future<$0.VoucherStatus> getVoucherStatus(
      $grpc.ServiceCall call, $0.GetVoucherStatusRequest request);

  $async.Future<$0.VerifyExitResponse> verifyExit_Pre($grpc.ServiceCall $call,
      $async.Future<$0.VerifyExitRequest> $request) async {
    return verifyExit($call, await $request);
  }

  $async.Future<$0.VerifyExitResponse> verifyExit(
      $grpc.ServiceCall call, $0.VerifyExitRequest request);

  $async.Future<$0.ConfirmExitResponse> confirmExit_Pre($grpc.ServiceCall $call,
      $async.Future<$0.ConfirmExitRequest> $request) async {
    return confirmExit($call, await $request);
  }

  $async.Future<$0.ConfirmExitResponse> confirmExit(
      $grpc.ServiceCall call, $0.ConfirmExitRequest request);

  $async.Future<$0.SponsorshipLedgerResponse> getSponsorshipLedger_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetSponsorshipLedgerRequest> $request) async {
    return getSponsorshipLedger($call, await $request);
  }

  $async.Future<$0.SponsorshipLedgerResponse> getSponsorshipLedger(
      $grpc.ServiceCall call, $0.GetSponsorshipLedgerRequest request);

  $async.Future<$0.RegisterUsedVoucherResponse> registerUsedVoucher_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.RegisterUsedVoucherRequest> $request) async {
    return registerUsedVoucher($call, await $request);
  }

  $async.Future<$0.RegisterUsedVoucherResponse> registerUsedVoucher(
      $grpc.ServiceCall call, $0.RegisterUsedVoucherRequest request);
}
