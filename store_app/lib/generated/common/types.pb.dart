// This is a generated file - do not edit.
//
// Generated from common/types.proto.

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

export 'types.pbenum.dart';

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
      package: const $pb.PackageName(_omitMessageNames ? '' : 'common'),
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

class SponsorSummary extends $pb.GeneratedMessage {
  factory SponsorSummary({
    $core.String? storeName,
    $core.double? amount,
  }) {
    final result = create();
    if (storeName != null) result.storeName = storeName;
    if (amount != null) result.amount = amount;
    return result;
  }

  SponsorSummary._();

  factory SponsorSummary.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SponsorSummary.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SponsorSummary',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'common'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'storeName')
    ..aD(2, _omitFieldNames ? '' : 'amount')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SponsorSummary clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SponsorSummary copyWith(void Function(SponsorSummary) updates) =>
      super.copyWith((message) => updates(message as SponsorSummary))
          as SponsorSummary;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SponsorSummary create() => SponsorSummary._();
  @$core.override
  SponsorSummary createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SponsorSummary getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SponsorSummary>(create);
  static SponsorSummary? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get storeName => $_getSZ(0);
  @$pb.TagNumber(1)
  set storeName($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasStoreName() => $_has(0);
  @$pb.TagNumber(1)
  void clearStoreName() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get amount => $_getN(1);
  @$pb.TagNumber(2)
  set amount($core.double value) => $_setDouble(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAmount() => $_has(1);
  @$pb.TagNumber(2)
  void clearAmount() => $_clearField(2);
}

class SignedVoucher extends $pb.GeneratedMessage {
  factory SignedVoucher({
    $core.String? jwt,
    $core.String? jti,
    $fixnum.Int64? expiresAt,
    $core.String? qrCodeData,
  }) {
    final result = create();
    if (jwt != null) result.jwt = jwt;
    if (jti != null) result.jti = jti;
    if (expiresAt != null) result.expiresAt = expiresAt;
    if (qrCodeData != null) result.qrCodeData = qrCodeData;
    return result;
  }

  SignedVoucher._();

  factory SignedVoucher.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SignedVoucher.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SignedVoucher',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'common'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'jwt')
    ..aOS(2, _omitFieldNames ? '' : 'jti')
    ..aInt64(3, _omitFieldNames ? '' : 'expiresAt')
    ..aOS(4, _omitFieldNames ? '' : 'qrCodeData')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SignedVoucher clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SignedVoucher copyWith(void Function(SignedVoucher) updates) =>
      super.copyWith((message) => updates(message as SignedVoucher))
          as SignedVoucher;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SignedVoucher create() => SignedVoucher._();
  @$core.override
  SignedVoucher createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SignedVoucher getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SignedVoucher>(create);
  static SignedVoucher? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get jwt => $_getSZ(0);
  @$pb.TagNumber(1)
  set jwt($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasJwt() => $_has(0);
  @$pb.TagNumber(1)
  void clearJwt() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get jti => $_getSZ(1);
  @$pb.TagNumber(2)
  set jti($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasJti() => $_has(1);
  @$pb.TagNumber(2)
  void clearJti() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get expiresAt => $_getI64(2);
  @$pb.TagNumber(3)
  set expiresAt($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasExpiresAt() => $_has(2);
  @$pb.TagNumber(3)
  void clearExpiresAt() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get qrCodeData => $_getSZ(3);
  @$pb.TagNumber(4)
  set qrCodeData($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasQrCodeData() => $_has(3);
  @$pb.TagNumber(4)
  void clearQrCodeData() => $_clearField(4);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
