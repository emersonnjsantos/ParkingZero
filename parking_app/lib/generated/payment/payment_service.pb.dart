// This is a generated file - do not edit.
//
// Generated from payment/payment_service.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import '../common/types.pb.dart' as $1;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class SponsorshipRequest extends $pb.GeneratedMessage {
  factory SponsorshipRequest({
    $core.String? reservationId,
    $core.String? storeId,
    InvoiceInfo? invoice,
    $core.String? syncId,
    $core.double? amountToSponsor,
  }) {
    final result = create();
    if (reservationId != null) result.reservationId = reservationId;
    if (storeId != null) result.storeId = storeId;
    if (invoice != null) result.invoice = invoice;
    if (syncId != null) result.syncId = syncId;
    if (amountToSponsor != null) result.amountToSponsor = amountToSponsor;
    return result;
  }

  SponsorshipRequest._();

  factory SponsorshipRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SponsorshipRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SponsorshipRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'payment'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'reservationId')
    ..aOS(2, _omitFieldNames ? '' : 'storeId')
    ..aOM<InvoiceInfo>(3, _omitFieldNames ? '' : 'invoice',
        subBuilder: InvoiceInfo.create)
    ..aOS(4, _omitFieldNames ? '' : 'syncId')
    ..aD(5, _omitFieldNames ? '' : 'amountToSponsor')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SponsorshipRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SponsorshipRequest copyWith(void Function(SponsorshipRequest) updates) =>
      super.copyWith((message) => updates(message as SponsorshipRequest))
          as SponsorshipRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SponsorshipRequest create() => SponsorshipRequest._();
  @$core.override
  SponsorshipRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SponsorshipRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SponsorshipRequest>(create);
  static SponsorshipRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get reservationId => $_getSZ(0);
  @$pb.TagNumber(1)
  set reservationId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasReservationId() => $_has(0);
  @$pb.TagNumber(1)
  void clearReservationId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get storeId => $_getSZ(1);
  @$pb.TagNumber(2)
  set storeId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasStoreId() => $_has(1);
  @$pb.TagNumber(2)
  void clearStoreId() => $_clearField(2);

  @$pb.TagNumber(3)
  InvoiceInfo get invoice => $_getN(2);
  @$pb.TagNumber(3)
  set invoice(InvoiceInfo value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasInvoice() => $_has(2);
  @$pb.TagNumber(3)
  void clearInvoice() => $_clearField(3);
  @$pb.TagNumber(3)
  InvoiceInfo ensureInvoice() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.String get syncId => $_getSZ(3);
  @$pb.TagNumber(4)
  set syncId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSyncId() => $_has(3);
  @$pb.TagNumber(4)
  void clearSyncId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get amountToSponsor => $_getN(4);
  @$pb.TagNumber(5)
  set amountToSponsor($core.double value) => $_setDouble(4, value);
  @$pb.TagNumber(5)
  $core.bool hasAmountToSponsor() => $_has(4);
  @$pb.TagNumber(5)
  void clearAmountToSponsor() => $_clearField(5);
}

class InvoiceInfo extends $pb.GeneratedMessage {
  factory InvoiceInfo({
    $core.String? invoiceId,
    $core.double? amountUsd,
    $fixnum.Int64? timestamp,
    $core.String? storeName,
  }) {
    final result = create();
    if (invoiceId != null) result.invoiceId = invoiceId;
    if (amountUsd != null) result.amountUsd = amountUsd;
    if (timestamp != null) result.timestamp = timestamp;
    if (storeName != null) result.storeName = storeName;
    return result;
  }

  InvoiceInfo._();

  factory InvoiceInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory InvoiceInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'InvoiceInfo',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'payment'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'invoiceId')
    ..aD(2, _omitFieldNames ? '' : 'amountUsd')
    ..aInt64(3, _omitFieldNames ? '' : 'timestamp')
    ..aOS(4, _omitFieldNames ? '' : 'storeName')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InvoiceInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InvoiceInfo copyWith(void Function(InvoiceInfo) updates) =>
      super.copyWith((message) => updates(message as InvoiceInfo))
          as InvoiceInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static InvoiceInfo create() => InvoiceInfo._();
  @$core.override
  InvoiceInfo createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static InvoiceInfo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<InvoiceInfo>(create);
  static InvoiceInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get invoiceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set invoiceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasInvoiceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearInvoiceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get amountUsd => $_getN(1);
  @$pb.TagNumber(2)
  set amountUsd($core.double value) => $_setDouble(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAmountUsd() => $_has(1);
  @$pb.TagNumber(2)
  void clearAmountUsd() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get timestamp => $_getI64(2);
  @$pb.TagNumber(3)
  set timestamp($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTimestamp() => $_has(2);
  @$pb.TagNumber(3)
  void clearTimestamp() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get storeName => $_getSZ(3);
  @$pb.TagNumber(4)
  set storeName($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasStoreName() => $_has(3);
  @$pb.TagNumber(4)
  void clearStoreName() => $_clearField(4);
}

class SponsorshipResponse extends $pb.GeneratedMessage {
  factory SponsorshipResponse({
    $core.bool? success,
    $core.String? message,
    $1.TicketStatus? newStatus,
    $core.String? errorCode,
    $core.String? ledgerEntryId,
    $core.double? amountSponsored,
    $core.double? currentBalance,
    $core.double? totalSponsored,
    $core.double? exchangeRate,
    $1.SignedVoucher? voucher,
  }) {
    final result = create();
    if (success != null) result.success = success;
    if (message != null) result.message = message;
    if (newStatus != null) result.newStatus = newStatus;
    if (errorCode != null) result.errorCode = errorCode;
    if (ledgerEntryId != null) result.ledgerEntryId = ledgerEntryId;
    if (amountSponsored != null) result.amountSponsored = amountSponsored;
    if (currentBalance != null) result.currentBalance = currentBalance;
    if (totalSponsored != null) result.totalSponsored = totalSponsored;
    if (exchangeRate != null) result.exchangeRate = exchangeRate;
    if (voucher != null) result.voucher = voucher;
    return result;
  }

  SponsorshipResponse._();

  factory SponsorshipResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SponsorshipResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SponsorshipResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'payment'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..aE<$1.TicketStatus>(3, _omitFieldNames ? '' : 'newStatus',
        enumValues: $1.TicketStatus.values)
    ..aOS(4, _omitFieldNames ? '' : 'errorCode')
    ..aOS(5, _omitFieldNames ? '' : 'ledgerEntryId')
    ..aD(6, _omitFieldNames ? '' : 'amountSponsored')
    ..aD(7, _omitFieldNames ? '' : 'currentBalance')
    ..aD(8, _omitFieldNames ? '' : 'totalSponsored')
    ..aD(9, _omitFieldNames ? '' : 'exchangeRate')
    ..aOM<$1.SignedVoucher>(10, _omitFieldNames ? '' : 'voucher',
        subBuilder: $1.SignedVoucher.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SponsorshipResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SponsorshipResponse copyWith(void Function(SponsorshipResponse) updates) =>
      super.copyWith((message) => updates(message as SponsorshipResponse))
          as SponsorshipResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SponsorshipResponse create() => SponsorshipResponse._();
  @$core.override
  SponsorshipResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SponsorshipResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SponsorshipResponse>(create);
  static SponsorshipResponse? _defaultInstance;

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

  @$pb.TagNumber(3)
  $1.TicketStatus get newStatus => $_getN(2);
  @$pb.TagNumber(3)
  set newStatus($1.TicketStatus value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasNewStatus() => $_has(2);
  @$pb.TagNumber(3)
  void clearNewStatus() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get errorCode => $_getSZ(3);
  @$pb.TagNumber(4)
  set errorCode($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasErrorCode() => $_has(3);
  @$pb.TagNumber(4)
  void clearErrorCode() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get ledgerEntryId => $_getSZ(4);
  @$pb.TagNumber(5)
  set ledgerEntryId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasLedgerEntryId() => $_has(4);
  @$pb.TagNumber(5)
  void clearLedgerEntryId() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get amountSponsored => $_getN(5);
  @$pb.TagNumber(6)
  set amountSponsored($core.double value) => $_setDouble(5, value);
  @$pb.TagNumber(6)
  $core.bool hasAmountSponsored() => $_has(5);
  @$pb.TagNumber(6)
  void clearAmountSponsored() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.double get currentBalance => $_getN(6);
  @$pb.TagNumber(7)
  set currentBalance($core.double value) => $_setDouble(6, value);
  @$pb.TagNumber(7)
  $core.bool hasCurrentBalance() => $_has(6);
  @$pb.TagNumber(7)
  void clearCurrentBalance() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.double get totalSponsored => $_getN(7);
  @$pb.TagNumber(8)
  set totalSponsored($core.double value) => $_setDouble(7, value);
  @$pb.TagNumber(8)
  $core.bool hasTotalSponsored() => $_has(7);
  @$pb.TagNumber(8)
  void clearTotalSponsored() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.double get exchangeRate => $_getN(8);
  @$pb.TagNumber(9)
  set exchangeRate($core.double value) => $_setDouble(8, value);
  @$pb.TagNumber(9)
  $core.bool hasExchangeRate() => $_has(8);
  @$pb.TagNumber(9)
  void clearExchangeRate() => $_clearField(9);

  @$pb.TagNumber(10)
  $1.SignedVoucher get voucher => $_getN(9);
  @$pb.TagNumber(10)
  set voucher($1.SignedVoucher value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasVoucher() => $_has(9);
  @$pb.TagNumber(10)
  void clearVoucher() => $_clearField(10);
  @$pb.TagNumber(10)
  $1.SignedVoucher ensureVoucher() => $_ensure(9);
}

class GetVoucherStatusRequest extends $pb.GeneratedMessage {
  factory GetVoucherStatusRequest({
    $core.String? reservationId,
  }) {
    final result = create();
    if (reservationId != null) result.reservationId = reservationId;
    return result;
  }

  GetVoucherStatusRequest._();

  factory GetVoucherStatusRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetVoucherStatusRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetVoucherStatusRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'payment'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'reservationId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetVoucherStatusRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetVoucherStatusRequest copyWith(
          void Function(GetVoucherStatusRequest) updates) =>
      super.copyWith((message) => updates(message as GetVoucherStatusRequest))
          as GetVoucherStatusRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetVoucherStatusRequest create() => GetVoucherStatusRequest._();
  @$core.override
  GetVoucherStatusRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetVoucherStatusRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetVoucherStatusRequest>(create);
  static GetVoucherStatusRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get reservationId => $_getSZ(0);
  @$pb.TagNumber(1)
  set reservationId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasReservationId() => $_has(0);
  @$pb.TagNumber(1)
  void clearReservationId() => $_clearField(1);
}

class VoucherStatus extends $pb.GeneratedMessage {
  factory VoucherStatus({
    $core.String? reservationId,
    $1.TicketStatus? status,
    $core.String? payerId,
    $core.String? payerName,
    $core.double? originalPrice,
    $core.double? amountToPay,
    $core.double? currentBalance,
    $core.double? totalSponsored,
    $core.Iterable<$1.SponsorSummary>? sponsorsSummary,
    $1.SignedVoucher? voucher,
  }) {
    final result = create();
    if (reservationId != null) result.reservationId = reservationId;
    if (status != null) result.status = status;
    if (payerId != null) result.payerId = payerId;
    if (payerName != null) result.payerName = payerName;
    if (originalPrice != null) result.originalPrice = originalPrice;
    if (amountToPay != null) result.amountToPay = amountToPay;
    if (currentBalance != null) result.currentBalance = currentBalance;
    if (totalSponsored != null) result.totalSponsored = totalSponsored;
    if (sponsorsSummary != null) result.sponsorsSummary.addAll(sponsorsSummary);
    if (voucher != null) result.voucher = voucher;
    return result;
  }

  VoucherStatus._();

  factory VoucherStatus.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory VoucherStatus.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'VoucherStatus',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'payment'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'reservationId')
    ..aE<$1.TicketStatus>(2, _omitFieldNames ? '' : 'status',
        enumValues: $1.TicketStatus.values)
    ..aOS(3, _omitFieldNames ? '' : 'payerId')
    ..aOS(4, _omitFieldNames ? '' : 'payerName')
    ..aD(5, _omitFieldNames ? '' : 'originalPrice')
    ..aD(6, _omitFieldNames ? '' : 'amountToPay')
    ..aD(7, _omitFieldNames ? '' : 'currentBalance')
    ..aD(8, _omitFieldNames ? '' : 'totalSponsored')
    ..pPM<$1.SponsorSummary>(9, _omitFieldNames ? '' : 'sponsorsSummary',
        subBuilder: $1.SponsorSummary.create)
    ..aOM<$1.SignedVoucher>(10, _omitFieldNames ? '' : 'voucher',
        subBuilder: $1.SignedVoucher.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VoucherStatus clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VoucherStatus copyWith(void Function(VoucherStatus) updates) =>
      super.copyWith((message) => updates(message as VoucherStatus))
          as VoucherStatus;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static VoucherStatus create() => VoucherStatus._();
  @$core.override
  VoucherStatus createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static VoucherStatus getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<VoucherStatus>(create);
  static VoucherStatus? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get reservationId => $_getSZ(0);
  @$pb.TagNumber(1)
  set reservationId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasReservationId() => $_has(0);
  @$pb.TagNumber(1)
  void clearReservationId() => $_clearField(1);

  @$pb.TagNumber(2)
  $1.TicketStatus get status => $_getN(1);
  @$pb.TagNumber(2)
  set status($1.TicketStatus value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasStatus() => $_has(1);
  @$pb.TagNumber(2)
  void clearStatus() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get payerId => $_getSZ(2);
  @$pb.TagNumber(3)
  set payerId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPayerId() => $_has(2);
  @$pb.TagNumber(3)
  void clearPayerId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get payerName => $_getSZ(3);
  @$pb.TagNumber(4)
  set payerName($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPayerName() => $_has(3);
  @$pb.TagNumber(4)
  void clearPayerName() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get originalPrice => $_getN(4);
  @$pb.TagNumber(5)
  set originalPrice($core.double value) => $_setDouble(4, value);
  @$pb.TagNumber(5)
  $core.bool hasOriginalPrice() => $_has(4);
  @$pb.TagNumber(5)
  void clearOriginalPrice() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get amountToPay => $_getN(5);
  @$pb.TagNumber(6)
  set amountToPay($core.double value) => $_setDouble(5, value);
  @$pb.TagNumber(6)
  $core.bool hasAmountToPay() => $_has(5);
  @$pb.TagNumber(6)
  void clearAmountToPay() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.double get currentBalance => $_getN(6);
  @$pb.TagNumber(7)
  set currentBalance($core.double value) => $_setDouble(6, value);
  @$pb.TagNumber(7)
  $core.bool hasCurrentBalance() => $_has(6);
  @$pb.TagNumber(7)
  void clearCurrentBalance() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.double get totalSponsored => $_getN(7);
  @$pb.TagNumber(8)
  set totalSponsored($core.double value) => $_setDouble(7, value);
  @$pb.TagNumber(8)
  $core.bool hasTotalSponsored() => $_has(7);
  @$pb.TagNumber(8)
  void clearTotalSponsored() => $_clearField(8);

  @$pb.TagNumber(9)
  $pb.PbList<$1.SponsorSummary> get sponsorsSummary => $_getList(8);

  @$pb.TagNumber(10)
  $1.SignedVoucher get voucher => $_getN(9);
  @$pb.TagNumber(10)
  set voucher($1.SignedVoucher value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasVoucher() => $_has(9);
  @$pb.TagNumber(10)
  void clearVoucher() => $_clearField(10);
  @$pb.TagNumber(10)
  $1.SignedVoucher ensureVoucher() => $_ensure(9);
}

class VerifyExitRequest extends $pb.GeneratedMessage {
  factory VerifyExitRequest({
    $core.String? garageId,
    $core.String? vehiclePlate,
  }) {
    final result = create();
    if (garageId != null) result.garageId = garageId;
    if (vehiclePlate != null) result.vehiclePlate = vehiclePlate;
    return result;
  }

  VerifyExitRequest._();

  factory VerifyExitRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory VerifyExitRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'VerifyExitRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'payment'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'garageId')
    ..aOS(2, _omitFieldNames ? '' : 'vehiclePlate')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VerifyExitRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VerifyExitRequest copyWith(void Function(VerifyExitRequest) updates) =>
      super.copyWith((message) => updates(message as VerifyExitRequest))
          as VerifyExitRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static VerifyExitRequest create() => VerifyExitRequest._();
  @$core.override
  VerifyExitRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static VerifyExitRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<VerifyExitRequest>(create);
  static VerifyExitRequest? _defaultInstance;

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

class VerifyExitResponse extends $pb.GeneratedMessage {
  factory VerifyExitResponse({
    $core.bool? authorized,
    $core.String? message,
    $core.String? displayMessage,
    $1.TicketStatus? status,
    $core.String? payerName,
    $core.String? actionRequired,
    $core.double? amountDue,
  }) {
    final result = create();
    if (authorized != null) result.authorized = authorized;
    if (message != null) result.message = message;
    if (displayMessage != null) result.displayMessage = displayMessage;
    if (status != null) result.status = status;
    if (payerName != null) result.payerName = payerName;
    if (actionRequired != null) result.actionRequired = actionRequired;
    if (amountDue != null) result.amountDue = amountDue;
    return result;
  }

  VerifyExitResponse._();

  factory VerifyExitResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory VerifyExitResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'VerifyExitResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'payment'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'authorized')
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..aOS(3, _omitFieldNames ? '' : 'displayMessage')
    ..aE<$1.TicketStatus>(4, _omitFieldNames ? '' : 'status',
        enumValues: $1.TicketStatus.values)
    ..aOS(5, _omitFieldNames ? '' : 'payerName')
    ..aOS(6, _omitFieldNames ? '' : 'actionRequired')
    ..aD(7, _omitFieldNames ? '' : 'amountDue')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VerifyExitResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VerifyExitResponse copyWith(void Function(VerifyExitResponse) updates) =>
      super.copyWith((message) => updates(message as VerifyExitResponse))
          as VerifyExitResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static VerifyExitResponse create() => VerifyExitResponse._();
  @$core.override
  VerifyExitResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static VerifyExitResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<VerifyExitResponse>(create);
  static VerifyExitResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get authorized => $_getBF(0);
  @$pb.TagNumber(1)
  set authorized($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAuthorized() => $_has(0);
  @$pb.TagNumber(1)
  void clearAuthorized() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get message => $_getSZ(1);
  @$pb.TagNumber(2)
  set message($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessage() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get displayMessage => $_getSZ(2);
  @$pb.TagNumber(3)
  set displayMessage($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDisplayMessage() => $_has(2);
  @$pb.TagNumber(3)
  void clearDisplayMessage() => $_clearField(3);

  @$pb.TagNumber(4)
  $1.TicketStatus get status => $_getN(3);
  @$pb.TagNumber(4)
  set status($1.TicketStatus value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasStatus() => $_has(3);
  @$pb.TagNumber(4)
  void clearStatus() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get payerName => $_getSZ(4);
  @$pb.TagNumber(5)
  set payerName($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPayerName() => $_has(4);
  @$pb.TagNumber(5)
  void clearPayerName() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get actionRequired => $_getSZ(5);
  @$pb.TagNumber(6)
  set actionRequired($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasActionRequired() => $_has(5);
  @$pb.TagNumber(6)
  void clearActionRequired() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.double get amountDue => $_getN(6);
  @$pb.TagNumber(7)
  set amountDue($core.double value) => $_setDouble(6, value);
  @$pb.TagNumber(7)
  $core.bool hasAmountDue() => $_has(6);
  @$pb.TagNumber(7)
  void clearAmountDue() => $_clearField(7);
}

class ConfirmExitRequest extends $pb.GeneratedMessage {
  factory ConfirmExitRequest({
    $core.String? garageId,
    $core.String? vehiclePlate,
    $core.String? agentId,
  }) {
    final result = create();
    if (garageId != null) result.garageId = garageId;
    if (vehiclePlate != null) result.vehiclePlate = vehiclePlate;
    if (agentId != null) result.agentId = agentId;
    return result;
  }

  ConfirmExitRequest._();

  factory ConfirmExitRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ConfirmExitRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ConfirmExitRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'payment'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'garageId')
    ..aOS(2, _omitFieldNames ? '' : 'vehiclePlate')
    ..aOS(3, _omitFieldNames ? '' : 'agentId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConfirmExitRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConfirmExitRequest copyWith(void Function(ConfirmExitRequest) updates) =>
      super.copyWith((message) => updates(message as ConfirmExitRequest))
          as ConfirmExitRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ConfirmExitRequest create() => ConfirmExitRequest._();
  @$core.override
  ConfirmExitRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ConfirmExitRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ConfirmExitRequest>(create);
  static ConfirmExitRequest? _defaultInstance;

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
  $core.String get agentId => $_getSZ(2);
  @$pb.TagNumber(3)
  set agentId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAgentId() => $_has(2);
  @$pb.TagNumber(3)
  void clearAgentId() => $_clearField(3);
}

class ConfirmExitResponse extends $pb.GeneratedMessage {
  factory ConfirmExitResponse({
    $core.bool? success,
    $core.String? message,
    $1.TicketStatus? finalStatus,
  }) {
    final result = create();
    if (success != null) result.success = success;
    if (message != null) result.message = message;
    if (finalStatus != null) result.finalStatus = finalStatus;
    return result;
  }

  ConfirmExitResponse._();

  factory ConfirmExitResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ConfirmExitResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ConfirmExitResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'payment'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..aE<$1.TicketStatus>(3, _omitFieldNames ? '' : 'finalStatus',
        enumValues: $1.TicketStatus.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConfirmExitResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConfirmExitResponse copyWith(void Function(ConfirmExitResponse) updates) =>
      super.copyWith((message) => updates(message as ConfirmExitResponse))
          as ConfirmExitResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ConfirmExitResponse create() => ConfirmExitResponse._();
  @$core.override
  ConfirmExitResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ConfirmExitResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ConfirmExitResponse>(create);
  static ConfirmExitResponse? _defaultInstance;

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

  @$pb.TagNumber(3)
  $1.TicketStatus get finalStatus => $_getN(2);
  @$pb.TagNumber(3)
  set finalStatus($1.TicketStatus value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasFinalStatus() => $_has(2);
  @$pb.TagNumber(3)
  void clearFinalStatus() => $_clearField(3);
}

class SponsorshipLedgerEntry extends $pb.GeneratedMessage {
  factory SponsorshipLedgerEntry({
    $core.String? entryId,
    $core.String? storeId,
    $core.String? storeName,
    $core.double? amount,
    $core.String? invoiceId,
    $fixnum.Int64? timestamp,
    $core.String? syncId,
    $core.double? exchangeRate,
    $core.String? operatorId,
  }) {
    final result = create();
    if (entryId != null) result.entryId = entryId;
    if (storeId != null) result.storeId = storeId;
    if (storeName != null) result.storeName = storeName;
    if (amount != null) result.amount = amount;
    if (invoiceId != null) result.invoiceId = invoiceId;
    if (timestamp != null) result.timestamp = timestamp;
    if (syncId != null) result.syncId = syncId;
    if (exchangeRate != null) result.exchangeRate = exchangeRate;
    if (operatorId != null) result.operatorId = operatorId;
    return result;
  }

  SponsorshipLedgerEntry._();

  factory SponsorshipLedgerEntry.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SponsorshipLedgerEntry.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SponsorshipLedgerEntry',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'payment'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'entryId')
    ..aOS(2, _omitFieldNames ? '' : 'storeId')
    ..aOS(3, _omitFieldNames ? '' : 'storeName')
    ..aD(4, _omitFieldNames ? '' : 'amount')
    ..aOS(5, _omitFieldNames ? '' : 'invoiceId')
    ..aInt64(6, _omitFieldNames ? '' : 'timestamp')
    ..aOS(7, _omitFieldNames ? '' : 'syncId')
    ..aD(8, _omitFieldNames ? '' : 'exchangeRate')
    ..aOS(9, _omitFieldNames ? '' : 'operatorId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SponsorshipLedgerEntry clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SponsorshipLedgerEntry copyWith(
          void Function(SponsorshipLedgerEntry) updates) =>
      super.copyWith((message) => updates(message as SponsorshipLedgerEntry))
          as SponsorshipLedgerEntry;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SponsorshipLedgerEntry create() => SponsorshipLedgerEntry._();
  @$core.override
  SponsorshipLedgerEntry createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SponsorshipLedgerEntry getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SponsorshipLedgerEntry>(create);
  static SponsorshipLedgerEntry? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get entryId => $_getSZ(0);
  @$pb.TagNumber(1)
  set entryId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEntryId() => $_has(0);
  @$pb.TagNumber(1)
  void clearEntryId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get storeId => $_getSZ(1);
  @$pb.TagNumber(2)
  set storeId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasStoreId() => $_has(1);
  @$pb.TagNumber(2)
  void clearStoreId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get storeName => $_getSZ(2);
  @$pb.TagNumber(3)
  set storeName($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasStoreName() => $_has(2);
  @$pb.TagNumber(3)
  void clearStoreName() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get amount => $_getN(3);
  @$pb.TagNumber(4)
  set amount($core.double value) => $_setDouble(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAmount() => $_has(3);
  @$pb.TagNumber(4)
  void clearAmount() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get invoiceId => $_getSZ(4);
  @$pb.TagNumber(5)
  set invoiceId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasInvoiceId() => $_has(4);
  @$pb.TagNumber(5)
  void clearInvoiceId() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get timestamp => $_getI64(5);
  @$pb.TagNumber(6)
  set timestamp($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasTimestamp() => $_has(5);
  @$pb.TagNumber(6)
  void clearTimestamp() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get syncId => $_getSZ(6);
  @$pb.TagNumber(7)
  set syncId($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasSyncId() => $_has(6);
  @$pb.TagNumber(7)
  void clearSyncId() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.double get exchangeRate => $_getN(7);
  @$pb.TagNumber(8)
  set exchangeRate($core.double value) => $_setDouble(7, value);
  @$pb.TagNumber(8)
  $core.bool hasExchangeRate() => $_has(7);
  @$pb.TagNumber(8)
  void clearExchangeRate() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get operatorId => $_getSZ(8);
  @$pb.TagNumber(9)
  set operatorId($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasOperatorId() => $_has(8);
  @$pb.TagNumber(9)
  void clearOperatorId() => $_clearField(9);
}

class GetSponsorshipLedgerRequest extends $pb.GeneratedMessage {
  factory GetSponsorshipLedgerRequest({
    $core.String? reservationId,
  }) {
    final result = create();
    if (reservationId != null) result.reservationId = reservationId;
    return result;
  }

  GetSponsorshipLedgerRequest._();

  factory GetSponsorshipLedgerRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetSponsorshipLedgerRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetSponsorshipLedgerRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'payment'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'reservationId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSponsorshipLedgerRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSponsorshipLedgerRequest copyWith(
          void Function(GetSponsorshipLedgerRequest) updates) =>
      super.copyWith(
              (message) => updates(message as GetSponsorshipLedgerRequest))
          as GetSponsorshipLedgerRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetSponsorshipLedgerRequest create() =>
      GetSponsorshipLedgerRequest._();
  @$core.override
  GetSponsorshipLedgerRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetSponsorshipLedgerRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetSponsorshipLedgerRequest>(create);
  static GetSponsorshipLedgerRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get reservationId => $_getSZ(0);
  @$pb.TagNumber(1)
  set reservationId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasReservationId() => $_has(0);
  @$pb.TagNumber(1)
  void clearReservationId() => $_clearField(1);
}

class SponsorshipLedgerResponse extends $pb.GeneratedMessage {
  factory SponsorshipLedgerResponse({
    $core.String? reservationId,
    $core.double? originalPrice,
    $core.double? currentBalance,
    $core.double? totalSponsored,
    $1.TicketStatus? status,
    $core.Iterable<SponsorshipLedgerEntry>? entries,
    $1.SignedVoucher? voucher,
    $core.int? entryCount,
  }) {
    final result = create();
    if (reservationId != null) result.reservationId = reservationId;
    if (originalPrice != null) result.originalPrice = originalPrice;
    if (currentBalance != null) result.currentBalance = currentBalance;
    if (totalSponsored != null) result.totalSponsored = totalSponsored;
    if (status != null) result.status = status;
    if (entries != null) result.entries.addAll(entries);
    if (voucher != null) result.voucher = voucher;
    if (entryCount != null) result.entryCount = entryCount;
    return result;
  }

  SponsorshipLedgerResponse._();

  factory SponsorshipLedgerResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SponsorshipLedgerResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SponsorshipLedgerResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'payment'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'reservationId')
    ..aD(2, _omitFieldNames ? '' : 'originalPrice')
    ..aD(3, _omitFieldNames ? '' : 'currentBalance')
    ..aD(4, _omitFieldNames ? '' : 'totalSponsored')
    ..aE<$1.TicketStatus>(5, _omitFieldNames ? '' : 'status',
        enumValues: $1.TicketStatus.values)
    ..pPM<SponsorshipLedgerEntry>(6, _omitFieldNames ? '' : 'entries',
        subBuilder: SponsorshipLedgerEntry.create)
    ..aOM<$1.SignedVoucher>(7, _omitFieldNames ? '' : 'voucher',
        subBuilder: $1.SignedVoucher.create)
    ..aI(8, _omitFieldNames ? '' : 'entryCount')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SponsorshipLedgerResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SponsorshipLedgerResponse copyWith(
          void Function(SponsorshipLedgerResponse) updates) =>
      super.copyWith((message) => updates(message as SponsorshipLedgerResponse))
          as SponsorshipLedgerResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SponsorshipLedgerResponse create() => SponsorshipLedgerResponse._();
  @$core.override
  SponsorshipLedgerResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SponsorshipLedgerResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SponsorshipLedgerResponse>(create);
  static SponsorshipLedgerResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get reservationId => $_getSZ(0);
  @$pb.TagNumber(1)
  set reservationId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasReservationId() => $_has(0);
  @$pb.TagNumber(1)
  void clearReservationId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get originalPrice => $_getN(1);
  @$pb.TagNumber(2)
  set originalPrice($core.double value) => $_setDouble(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOriginalPrice() => $_has(1);
  @$pb.TagNumber(2)
  void clearOriginalPrice() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get currentBalance => $_getN(2);
  @$pb.TagNumber(3)
  set currentBalance($core.double value) => $_setDouble(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCurrentBalance() => $_has(2);
  @$pb.TagNumber(3)
  void clearCurrentBalance() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get totalSponsored => $_getN(3);
  @$pb.TagNumber(4)
  set totalSponsored($core.double value) => $_setDouble(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTotalSponsored() => $_has(3);
  @$pb.TagNumber(4)
  void clearTotalSponsored() => $_clearField(4);

  @$pb.TagNumber(5)
  $1.TicketStatus get status => $_getN(4);
  @$pb.TagNumber(5)
  set status($1.TicketStatus value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasStatus() => $_has(4);
  @$pb.TagNumber(5)
  void clearStatus() => $_clearField(5);

  @$pb.TagNumber(6)
  $pb.PbList<SponsorshipLedgerEntry> get entries => $_getList(5);

  @$pb.TagNumber(7)
  $1.SignedVoucher get voucher => $_getN(6);
  @$pb.TagNumber(7)
  set voucher($1.SignedVoucher value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasVoucher() => $_has(6);
  @$pb.TagNumber(7)
  void clearVoucher() => $_clearField(7);
  @$pb.TagNumber(7)
  $1.SignedVoucher ensureVoucher() => $_ensure(6);

  @$pb.TagNumber(8)
  $core.int get entryCount => $_getIZ(7);
  @$pb.TagNumber(8)
  set entryCount($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasEntryCount() => $_has(7);
  @$pb.TagNumber(8)
  void clearEntryCount() => $_clearField(8);
}

class ValidateVoucherOfflineRequest extends $pb.GeneratedMessage {
  factory ValidateVoucherOfflineRequest({
    $core.String? signedVoucherJwt,
    $core.String? garageId,
  }) {
    final result = create();
    if (signedVoucherJwt != null) result.signedVoucherJwt = signedVoucherJwt;
    if (garageId != null) result.garageId = garageId;
    return result;
  }

  ValidateVoucherOfflineRequest._();

  factory ValidateVoucherOfflineRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ValidateVoucherOfflineRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ValidateVoucherOfflineRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'payment'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'signedVoucherJwt')
    ..aOS(2, _omitFieldNames ? '' : 'garageId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ValidateVoucherOfflineRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ValidateVoucherOfflineRequest copyWith(
          void Function(ValidateVoucherOfflineRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ValidateVoucherOfflineRequest))
          as ValidateVoucherOfflineRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ValidateVoucherOfflineRequest create() =>
      ValidateVoucherOfflineRequest._();
  @$core.override
  ValidateVoucherOfflineRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ValidateVoucherOfflineRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ValidateVoucherOfflineRequest>(create);
  static ValidateVoucherOfflineRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get signedVoucherJwt => $_getSZ(0);
  @$pb.TagNumber(1)
  set signedVoucherJwt($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSignedVoucherJwt() => $_has(0);
  @$pb.TagNumber(1)
  void clearSignedVoucherJwt() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get garageId => $_getSZ(1);
  @$pb.TagNumber(2)
  set garageId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasGarageId() => $_has(1);
  @$pb.TagNumber(2)
  void clearGarageId() => $_clearField(2);
}

class ValidateVoucherOfflineResponse extends $pb.GeneratedMessage {
  factory ValidateVoucherOfflineResponse({
    $core.bool? valid,
    $core.String? vehiclePlate,
    $core.String? garageId,
    $fixnum.Int64? expiresAt,
    $core.String? jti,
    $core.String? errorMessage,
    $core.Iterable<$1.SponsorSummary>? sponsors,
  }) {
    final result = create();
    if (valid != null) result.valid = valid;
    if (vehiclePlate != null) result.vehiclePlate = vehiclePlate;
    if (garageId != null) result.garageId = garageId;
    if (expiresAt != null) result.expiresAt = expiresAt;
    if (jti != null) result.jti = jti;
    if (errorMessage != null) result.errorMessage = errorMessage;
    if (sponsors != null) result.sponsors.addAll(sponsors);
    return result;
  }

  ValidateVoucherOfflineResponse._();

  factory ValidateVoucherOfflineResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ValidateVoucherOfflineResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ValidateVoucherOfflineResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'payment'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'valid')
    ..aOS(2, _omitFieldNames ? '' : 'vehiclePlate')
    ..aOS(3, _omitFieldNames ? '' : 'garageId')
    ..aInt64(4, _omitFieldNames ? '' : 'expiresAt')
    ..aOS(5, _omitFieldNames ? '' : 'jti')
    ..aOS(6, _omitFieldNames ? '' : 'errorMessage')
    ..pPM<$1.SponsorSummary>(7, _omitFieldNames ? '' : 'sponsors',
        subBuilder: $1.SponsorSummary.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ValidateVoucherOfflineResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ValidateVoucherOfflineResponse copyWith(
          void Function(ValidateVoucherOfflineResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ValidateVoucherOfflineResponse))
          as ValidateVoucherOfflineResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ValidateVoucherOfflineResponse create() =>
      ValidateVoucherOfflineResponse._();
  @$core.override
  ValidateVoucherOfflineResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ValidateVoucherOfflineResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ValidateVoucherOfflineResponse>(create);
  static ValidateVoucherOfflineResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get valid => $_getBF(0);
  @$pb.TagNumber(1)
  set valid($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasValid() => $_has(0);
  @$pb.TagNumber(1)
  void clearValid() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get vehiclePlate => $_getSZ(1);
  @$pb.TagNumber(2)
  set vehiclePlate($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasVehiclePlate() => $_has(1);
  @$pb.TagNumber(2)
  void clearVehiclePlate() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get garageId => $_getSZ(2);
  @$pb.TagNumber(3)
  set garageId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasGarageId() => $_has(2);
  @$pb.TagNumber(3)
  void clearGarageId() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get expiresAt => $_getI64(3);
  @$pb.TagNumber(4)
  set expiresAt($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasExpiresAt() => $_has(3);
  @$pb.TagNumber(4)
  void clearExpiresAt() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get jti => $_getSZ(4);
  @$pb.TagNumber(5)
  set jti($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasJti() => $_has(4);
  @$pb.TagNumber(5)
  void clearJti() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get errorMessage => $_getSZ(5);
  @$pb.TagNumber(6)
  set errorMessage($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasErrorMessage() => $_has(5);
  @$pb.TagNumber(6)
  void clearErrorMessage() => $_clearField(6);

  @$pb.TagNumber(7)
  $pb.PbList<$1.SponsorSummary> get sponsors => $_getList(6);
}

class RegisterUsedVoucherRequest extends $pb.GeneratedMessage {
  factory RegisterUsedVoucherRequest({
    $core.String? jti,
    $core.String? reservationId,
    $core.String? garageId,
    $core.String? agentId,
    $fixnum.Int64? usedAt,
    $core.String? vehiclePlate,
    $core.String? syncId,
  }) {
    final result = create();
    if (jti != null) result.jti = jti;
    if (reservationId != null) result.reservationId = reservationId;
    if (garageId != null) result.garageId = garageId;
    if (agentId != null) result.agentId = agentId;
    if (usedAt != null) result.usedAt = usedAt;
    if (vehiclePlate != null) result.vehiclePlate = vehiclePlate;
    if (syncId != null) result.syncId = syncId;
    return result;
  }

  RegisterUsedVoucherRequest._();

  factory RegisterUsedVoucherRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RegisterUsedVoucherRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RegisterUsedVoucherRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'payment'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'jti')
    ..aOS(2, _omitFieldNames ? '' : 'reservationId')
    ..aOS(3, _omitFieldNames ? '' : 'garageId')
    ..aOS(4, _omitFieldNames ? '' : 'agentId')
    ..aInt64(5, _omitFieldNames ? '' : 'usedAt')
    ..aOS(6, _omitFieldNames ? '' : 'vehiclePlate')
    ..aOS(7, _omitFieldNames ? '' : 'syncId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RegisterUsedVoucherRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RegisterUsedVoucherRequest copyWith(
          void Function(RegisterUsedVoucherRequest) updates) =>
      super.copyWith(
              (message) => updates(message as RegisterUsedVoucherRequest))
          as RegisterUsedVoucherRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RegisterUsedVoucherRequest create() => RegisterUsedVoucherRequest._();
  @$core.override
  RegisterUsedVoucherRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RegisterUsedVoucherRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RegisterUsedVoucherRequest>(create);
  static RegisterUsedVoucherRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get jti => $_getSZ(0);
  @$pb.TagNumber(1)
  set jti($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasJti() => $_has(0);
  @$pb.TagNumber(1)
  void clearJti() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get reservationId => $_getSZ(1);
  @$pb.TagNumber(2)
  set reservationId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReservationId() => $_has(1);
  @$pb.TagNumber(2)
  void clearReservationId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get garageId => $_getSZ(2);
  @$pb.TagNumber(3)
  set garageId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasGarageId() => $_has(2);
  @$pb.TagNumber(3)
  void clearGarageId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get agentId => $_getSZ(3);
  @$pb.TagNumber(4)
  set agentId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAgentId() => $_has(3);
  @$pb.TagNumber(4)
  void clearAgentId() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get usedAt => $_getI64(4);
  @$pb.TagNumber(5)
  set usedAt($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasUsedAt() => $_has(4);
  @$pb.TagNumber(5)
  void clearUsedAt() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get vehiclePlate => $_getSZ(5);
  @$pb.TagNumber(6)
  set vehiclePlate($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasVehiclePlate() => $_has(5);
  @$pb.TagNumber(6)
  void clearVehiclePlate() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get syncId => $_getSZ(6);
  @$pb.TagNumber(7)
  set syncId($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasSyncId() => $_has(6);
  @$pb.TagNumber(7)
  void clearSyncId() => $_clearField(7);
}

class RegisterUsedVoucherResponse extends $pb.GeneratedMessage {
  factory RegisterUsedVoucherResponse({
    $core.bool? success,
    $core.String? message,
    $core.String? errorCode,
    $fixnum.Int64? usedAt,
    $core.String? usedByGarage,
  }) {
    final result = create();
    if (success != null) result.success = success;
    if (message != null) result.message = message;
    if (errorCode != null) result.errorCode = errorCode;
    if (usedAt != null) result.usedAt = usedAt;
    if (usedByGarage != null) result.usedByGarage = usedByGarage;
    return result;
  }

  RegisterUsedVoucherResponse._();

  factory RegisterUsedVoucherResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RegisterUsedVoucherResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RegisterUsedVoucherResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'payment'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..aOS(3, _omitFieldNames ? '' : 'errorCode')
    ..aInt64(4, _omitFieldNames ? '' : 'usedAt')
    ..aOS(5, _omitFieldNames ? '' : 'usedByGarage')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RegisterUsedVoucherResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RegisterUsedVoucherResponse copyWith(
          void Function(RegisterUsedVoucherResponse) updates) =>
      super.copyWith(
              (message) => updates(message as RegisterUsedVoucherResponse))
          as RegisterUsedVoucherResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RegisterUsedVoucherResponse create() =>
      RegisterUsedVoucherResponse._();
  @$core.override
  RegisterUsedVoucherResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RegisterUsedVoucherResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RegisterUsedVoucherResponse>(create);
  static RegisterUsedVoucherResponse? _defaultInstance;

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

  @$pb.TagNumber(3)
  $core.String get errorCode => $_getSZ(2);
  @$pb.TagNumber(3)
  set errorCode($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasErrorCode() => $_has(2);
  @$pb.TagNumber(3)
  void clearErrorCode() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get usedAt => $_getI64(3);
  @$pb.TagNumber(4)
  set usedAt($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasUsedAt() => $_has(3);
  @$pb.TagNumber(4)
  void clearUsedAt() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get usedByGarage => $_getSZ(4);
  @$pb.TagNumber(5)
  set usedByGarage($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasUsedByGarage() => $_has(4);
  @$pb.TagNumber(5)
  void clearUsedByGarage() => $_clearField(5);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
