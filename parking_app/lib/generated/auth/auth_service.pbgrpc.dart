// This is a generated file - do not edit.
//
// Generated from auth/auth_service.proto.

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

import 'auth_service.pb.dart' as $0;

export 'auth_service.pb.dart';

/// AuthService — Cadastro, login e gestão de usuários/parceiros
@$pb.GrpcServiceName('auth.AuthService')
class AuthServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  AuthServiceClient(super.channel, {super.options, super.interceptors});

  /// Registro de novos usuários
  $grpc.ResponseFuture<$0.RegisterUserResponse> registerUser(
    $0.RegisterUserRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$registerUser, request, options: options);
  }

  /// Registro de parceiros (loja ou estacionamento)
  $grpc.ResponseFuture<$0.RegisterPartnerResponse> registerPartner(
    $0.RegisterPartnerRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$registerPartner, request, options: options);
  }

  /// Obter perfil do usuário/parceiro
  $grpc.ResponseFuture<$0.UserProfile> getProfile(
    $0.GetProfileRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getProfile, request, options: options);
  }

  /// Atualizar perfil
  $grpc.ResponseFuture<$0.UserProfile> updateProfile(
    $0.UpdateProfileRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$updateProfile, request, options: options);
  }

  /// Listar funcionários de um parceiro
  $grpc.ResponseFuture<$0.ListPartnerStaffResponse> listPartnerStaff(
    $0.ListPartnerStaffRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listPartnerStaff, request, options: options);
  }

  /// Adicionar funcionário a um parceiro
  $grpc.ResponseFuture<$0.AddPartnerStaffResponse> addPartnerStaff(
    $0.AddPartnerStaffRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$addPartnerStaff, request, options: options);
  }

  /// Remover funcionário
  $grpc.ResponseFuture<$0.RemovePartnerStaffResponse> removePartnerStaff(
    $0.RemovePartnerStaffRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$removePartnerStaff, request, options: options);
  }

  // method descriptors

  static final _$registerUser =
      $grpc.ClientMethod<$0.RegisterUserRequest, $0.RegisterUserResponse>(
          '/auth.AuthService/RegisterUser',
          ($0.RegisterUserRequest value) => value.writeToBuffer(),
          $0.RegisterUserResponse.fromBuffer);
  static final _$registerPartner =
      $grpc.ClientMethod<$0.RegisterPartnerRequest, $0.RegisterPartnerResponse>(
          '/auth.AuthService/RegisterPartner',
          ($0.RegisterPartnerRequest value) => value.writeToBuffer(),
          $0.RegisterPartnerResponse.fromBuffer);
  static final _$getProfile =
      $grpc.ClientMethod<$0.GetProfileRequest, $0.UserProfile>(
          '/auth.AuthService/GetProfile',
          ($0.GetProfileRequest value) => value.writeToBuffer(),
          $0.UserProfile.fromBuffer);
  static final _$updateProfile =
      $grpc.ClientMethod<$0.UpdateProfileRequest, $0.UserProfile>(
          '/auth.AuthService/UpdateProfile',
          ($0.UpdateProfileRequest value) => value.writeToBuffer(),
          $0.UserProfile.fromBuffer);
  static final _$listPartnerStaff = $grpc.ClientMethod<
          $0.ListPartnerStaffRequest, $0.ListPartnerStaffResponse>(
      '/auth.AuthService/ListPartnerStaff',
      ($0.ListPartnerStaffRequest value) => value.writeToBuffer(),
      $0.ListPartnerStaffResponse.fromBuffer);
  static final _$addPartnerStaff =
      $grpc.ClientMethod<$0.AddPartnerStaffRequest, $0.AddPartnerStaffResponse>(
          '/auth.AuthService/AddPartnerStaff',
          ($0.AddPartnerStaffRequest value) => value.writeToBuffer(),
          $0.AddPartnerStaffResponse.fromBuffer);
  static final _$removePartnerStaff = $grpc.ClientMethod<
          $0.RemovePartnerStaffRequest, $0.RemovePartnerStaffResponse>(
      '/auth.AuthService/RemovePartnerStaff',
      ($0.RemovePartnerStaffRequest value) => value.writeToBuffer(),
      $0.RemovePartnerStaffResponse.fromBuffer);
}

@$pb.GrpcServiceName('auth.AuthService')
abstract class AuthServiceBase extends $grpc.Service {
  $core.String get $name => 'auth.AuthService';

  AuthServiceBase() {
    $addMethod(
        $grpc.ServiceMethod<$0.RegisterUserRequest, $0.RegisterUserResponse>(
            'RegisterUser',
            registerUser_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.RegisterUserRequest.fromBuffer(value),
            ($0.RegisterUserResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.RegisterPartnerRequest,
            $0.RegisterPartnerResponse>(
        'RegisterPartner',
        registerPartner_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.RegisterPartnerRequest.fromBuffer(value),
        ($0.RegisterPartnerResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetProfileRequest, $0.UserProfile>(
        'GetProfile',
        getProfile_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.GetProfileRequest.fromBuffer(value),
        ($0.UserProfile value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.UpdateProfileRequest, $0.UserProfile>(
        'UpdateProfile',
        updateProfile_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.UpdateProfileRequest.fromBuffer(value),
        ($0.UserProfile value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ListPartnerStaffRequest,
            $0.ListPartnerStaffResponse>(
        'ListPartnerStaff',
        listPartnerStaff_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ListPartnerStaffRequest.fromBuffer(value),
        ($0.ListPartnerStaffResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.AddPartnerStaffRequest,
            $0.AddPartnerStaffResponse>(
        'AddPartnerStaff',
        addPartnerStaff_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.AddPartnerStaffRequest.fromBuffer(value),
        ($0.AddPartnerStaffResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.RemovePartnerStaffRequest,
            $0.RemovePartnerStaffResponse>(
        'RemovePartnerStaff',
        removePartnerStaff_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.RemovePartnerStaffRequest.fromBuffer(value),
        ($0.RemovePartnerStaffResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.RegisterUserResponse> registerUser_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.RegisterUserRequest> $request) async {
    return registerUser($call, await $request);
  }

  $async.Future<$0.RegisterUserResponse> registerUser(
      $grpc.ServiceCall call, $0.RegisterUserRequest request);

  $async.Future<$0.RegisterPartnerResponse> registerPartner_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.RegisterPartnerRequest> $request) async {
    return registerPartner($call, await $request);
  }

  $async.Future<$0.RegisterPartnerResponse> registerPartner(
      $grpc.ServiceCall call, $0.RegisterPartnerRequest request);

  $async.Future<$0.UserProfile> getProfile_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetProfileRequest> $request) async {
    return getProfile($call, await $request);
  }

  $async.Future<$0.UserProfile> getProfile(
      $grpc.ServiceCall call, $0.GetProfileRequest request);

  $async.Future<$0.UserProfile> updateProfile_Pre($grpc.ServiceCall $call,
      $async.Future<$0.UpdateProfileRequest> $request) async {
    return updateProfile($call, await $request);
  }

  $async.Future<$0.UserProfile> updateProfile(
      $grpc.ServiceCall call, $0.UpdateProfileRequest request);

  $async.Future<$0.ListPartnerStaffResponse> listPartnerStaff_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ListPartnerStaffRequest> $request) async {
    return listPartnerStaff($call, await $request);
  }

  $async.Future<$0.ListPartnerStaffResponse> listPartnerStaff(
      $grpc.ServiceCall call, $0.ListPartnerStaffRequest request);

  $async.Future<$0.AddPartnerStaffResponse> addPartnerStaff_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.AddPartnerStaffRequest> $request) async {
    return addPartnerStaff($call, await $request);
  }

  $async.Future<$0.AddPartnerStaffResponse> addPartnerStaff(
      $grpc.ServiceCall call, $0.AddPartnerStaffRequest request);

  $async.Future<$0.RemovePartnerStaffResponse> removePartnerStaff_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.RemovePartnerStaffRequest> $request) async {
    return removePartnerStaff($call, await $request);
  }

  $async.Future<$0.RemovePartnerStaffResponse> removePartnerStaff(
      $grpc.ServiceCall call, $0.RemovePartnerStaffRequest request);
}
