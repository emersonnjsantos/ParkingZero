// This is a generated file - do not edit.
//
// Generated from payment/payment_service.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports
// ignore_for_file: unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use sponsorshipRequestDescriptor instead')
const SponsorshipRequest$json = {
  '1': 'SponsorshipRequest',
  '2': [
    {'1': 'reservation_id', '3': 1, '4': 1, '5': 9, '10': 'reservationId'},
    {'1': 'store_id', '3': 2, '4': 1, '5': 9, '10': 'storeId'},
    {
      '1': 'invoice',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.payment.InvoiceInfo',
      '10': 'invoice'
    },
    {'1': 'sync_id', '3': 4, '4': 1, '5': 9, '10': 'syncId'},
    {'1': 'amount_to_sponsor', '3': 5, '4': 1, '5': 1, '10': 'amountToSponsor'},
  ],
};

/// Descriptor for `SponsorshipRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sponsorshipRequestDescriptor = $convert.base64Decode(
    'ChJTcG9uc29yc2hpcFJlcXVlc3QSJQoOcmVzZXJ2YXRpb25faWQYASABKAlSDXJlc2VydmF0aW'
    '9uSWQSGQoIc3RvcmVfaWQYAiABKAlSB3N0b3JlSWQSLgoHaW52b2ljZRgDIAEoCzIULnBheW1l'
    'bnQuSW52b2ljZUluZm9SB2ludm9pY2USFwoHc3luY19pZBgEIAEoCVIGc3luY0lkEioKEWFtb3'
    'VudF90b19zcG9uc29yGAUgASgBUg9hbW91bnRUb1Nwb25zb3I=');

@$core.Deprecated('Use invoiceInfoDescriptor instead')
const InvoiceInfo$json = {
  '1': 'InvoiceInfo',
  '2': [
    {'1': 'invoice_id', '3': 1, '4': 1, '5': 9, '10': 'invoiceId'},
    {'1': 'amount_usd', '3': 2, '4': 1, '5': 1, '10': 'amountUsd'},
    {'1': 'timestamp', '3': 3, '4': 1, '5': 3, '10': 'timestamp'},
    {'1': 'store_name', '3': 4, '4': 1, '5': 9, '10': 'storeName'},
  ],
};

/// Descriptor for `InvoiceInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List invoiceInfoDescriptor = $convert.base64Decode(
    'CgtJbnZvaWNlSW5mbxIdCgppbnZvaWNlX2lkGAEgASgJUglpbnZvaWNlSWQSHQoKYW1vdW50X3'
    'VzZBgCIAEoAVIJYW1vdW50VXNkEhwKCXRpbWVzdGFtcBgDIAEoA1IJdGltZXN0YW1wEh0KCnN0'
    'b3JlX25hbWUYBCABKAlSCXN0b3JlTmFtZQ==');

@$core.Deprecated('Use sponsorshipResponseDescriptor instead')
const SponsorshipResponse$json = {
  '1': 'SponsorshipResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
    {
      '1': 'new_status',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.common.TicketStatus',
      '10': 'newStatus'
    },
    {'1': 'error_code', '3': 4, '4': 1, '5': 9, '10': 'errorCode'},
    {'1': 'ledger_entry_id', '3': 5, '4': 1, '5': 9, '10': 'ledgerEntryId'},
    {'1': 'amount_sponsored', '3': 6, '4': 1, '5': 1, '10': 'amountSponsored'},
    {'1': 'current_balance', '3': 7, '4': 1, '5': 1, '10': 'currentBalance'},
    {'1': 'total_sponsored', '3': 8, '4': 1, '5': 1, '10': 'totalSponsored'},
    {'1': 'exchange_rate', '3': 9, '4': 1, '5': 1, '10': 'exchangeRate'},
    {
      '1': 'voucher',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.common.SignedVoucher',
      '10': 'voucher'
    },
  ],
};

/// Descriptor for `SponsorshipResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sponsorshipResponseDescriptor = $convert.base64Decode(
    'ChNTcG9uc29yc2hpcFJlc3BvbnNlEhgKB3N1Y2Nlc3MYASABKAhSB3N1Y2Nlc3MSGAoHbWVzc2'
    'FnZRgCIAEoCVIHbWVzc2FnZRIzCgpuZXdfc3RhdHVzGAMgASgOMhQuY29tbW9uLlRpY2tldFN0'
    'YXR1c1IJbmV3U3RhdHVzEh0KCmVycm9yX2NvZGUYBCABKAlSCWVycm9yQ29kZRImCg9sZWRnZX'
    'JfZW50cnlfaWQYBSABKAlSDWxlZGdlckVudHJ5SWQSKQoQYW1vdW50X3Nwb25zb3JlZBgGIAEo'
    'AVIPYW1vdW50U3BvbnNvcmVkEicKD2N1cnJlbnRfYmFsYW5jZRgHIAEoAVIOY3VycmVudEJhbG'
    'FuY2USJwoPdG90YWxfc3BvbnNvcmVkGAggASgBUg50b3RhbFNwb25zb3JlZBIjCg1leGNoYW5n'
    'ZV9yYXRlGAkgASgBUgxleGNoYW5nZVJhdGUSLwoHdm91Y2hlchgKIAEoCzIVLmNvbW1vbi5TaW'
    'duZWRWb3VjaGVyUgd2b3VjaGVy');

@$core.Deprecated('Use getVoucherStatusRequestDescriptor instead')
const GetVoucherStatusRequest$json = {
  '1': 'GetVoucherStatusRequest',
  '2': [
    {'1': 'reservation_id', '3': 1, '4': 1, '5': 9, '10': 'reservationId'},
  ],
};

/// Descriptor for `GetVoucherStatusRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getVoucherStatusRequestDescriptor =
    $convert.base64Decode(
        'ChdHZXRWb3VjaGVyU3RhdHVzUmVxdWVzdBIlCg5yZXNlcnZhdGlvbl9pZBgBIAEoCVINcmVzZX'
        'J2YXRpb25JZA==');

@$core.Deprecated('Use voucherStatusDescriptor instead')
const VoucherStatus$json = {
  '1': 'VoucherStatus',
  '2': [
    {'1': 'reservation_id', '3': 1, '4': 1, '5': 9, '10': 'reservationId'},
    {
      '1': 'status',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.common.TicketStatus',
      '10': 'status'
    },
    {'1': 'payer_id', '3': 3, '4': 1, '5': 9, '10': 'payerId'},
    {'1': 'payer_name', '3': 4, '4': 1, '5': 9, '10': 'payerName'},
    {'1': 'original_price', '3': 5, '4': 1, '5': 1, '10': 'originalPrice'},
    {'1': 'amount_to_pay', '3': 6, '4': 1, '5': 1, '10': 'amountToPay'},
    {'1': 'current_balance', '3': 7, '4': 1, '5': 1, '10': 'currentBalance'},
    {'1': 'total_sponsored', '3': 8, '4': 1, '5': 1, '10': 'totalSponsored'},
    {
      '1': 'sponsors_summary',
      '3': 9,
      '4': 3,
      '5': 11,
      '6': '.common.SponsorSummary',
      '10': 'sponsorsSummary'
    },
    {
      '1': 'voucher',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.common.SignedVoucher',
      '10': 'voucher'
    },
  ],
};

/// Descriptor for `VoucherStatus`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List voucherStatusDescriptor = $convert.base64Decode(
    'Cg1Wb3VjaGVyU3RhdHVzEiUKDnJlc2VydmF0aW9uX2lkGAEgASgJUg1yZXNlcnZhdGlvbklkEi'
    'wKBnN0YXR1cxgCIAEoDjIULmNvbW1vbi5UaWNrZXRTdGF0dXNSBnN0YXR1cxIZCghwYXllcl9p'
    'ZBgDIAEoCVIHcGF5ZXJJZBIdCgpwYXllcl9uYW1lGAQgASgJUglwYXllck5hbWUSJQoOb3JpZ2'
    'luYWxfcHJpY2UYBSABKAFSDW9yaWdpbmFsUHJpY2USIgoNYW1vdW50X3RvX3BheRgGIAEoAVIL'
    'YW1vdW50VG9QYXkSJwoPY3VycmVudF9iYWxhbmNlGAcgASgBUg5jdXJyZW50QmFsYW5jZRInCg'
    '90b3RhbF9zcG9uc29yZWQYCCABKAFSDnRvdGFsU3BvbnNvcmVkEkEKEHNwb25zb3JzX3N1bW1h'
    'cnkYCSADKAsyFi5jb21tb24uU3BvbnNvclN1bW1hcnlSD3Nwb25zb3JzU3VtbWFyeRIvCgd2b3'
    'VjaGVyGAogASgLMhUuY29tbW9uLlNpZ25lZFZvdWNoZXJSB3ZvdWNoZXI=');

@$core.Deprecated('Use verifyExitRequestDescriptor instead')
const VerifyExitRequest$json = {
  '1': 'VerifyExitRequest',
  '2': [
    {'1': 'garage_id', '3': 1, '4': 1, '5': 9, '10': 'garageId'},
    {'1': 'vehicle_plate', '3': 2, '4': 1, '5': 9, '10': 'vehiclePlate'},
  ],
};

/// Descriptor for `VerifyExitRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List verifyExitRequestDescriptor = $convert.base64Decode(
    'ChFWZXJpZnlFeGl0UmVxdWVzdBIbCglnYXJhZ2VfaWQYASABKAlSCGdhcmFnZUlkEiMKDXZlaG'
    'ljbGVfcGxhdGUYAiABKAlSDHZlaGljbGVQbGF0ZQ==');

@$core.Deprecated('Use verifyExitResponseDescriptor instead')
const VerifyExitResponse$json = {
  '1': 'VerifyExitResponse',
  '2': [
    {'1': 'authorized', '3': 1, '4': 1, '5': 8, '10': 'authorized'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
    {'1': 'display_message', '3': 3, '4': 1, '5': 9, '10': 'displayMessage'},
    {
      '1': 'status',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.common.TicketStatus',
      '10': 'status'
    },
    {'1': 'payer_name', '3': 5, '4': 1, '5': 9, '10': 'payerName'},
    {'1': 'action_required', '3': 6, '4': 1, '5': 9, '10': 'actionRequired'},
    {'1': 'amount_due', '3': 7, '4': 1, '5': 1, '10': 'amountDue'},
  ],
};

/// Descriptor for `VerifyExitResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List verifyExitResponseDescriptor = $convert.base64Decode(
    'ChJWZXJpZnlFeGl0UmVzcG9uc2USHgoKYXV0aG9yaXplZBgBIAEoCFIKYXV0aG9yaXplZBIYCg'
    'dtZXNzYWdlGAIgASgJUgdtZXNzYWdlEicKD2Rpc3BsYXlfbWVzc2FnZRgDIAEoCVIOZGlzcGxh'
    'eU1lc3NhZ2USLAoGc3RhdHVzGAQgASgOMhQuY29tbW9uLlRpY2tldFN0YXR1c1IGc3RhdHVzEh'
    '0KCnBheWVyX25hbWUYBSABKAlSCXBheWVyTmFtZRInCg9hY3Rpb25fcmVxdWlyZWQYBiABKAlS'
    'DmFjdGlvblJlcXVpcmVkEh0KCmFtb3VudF9kdWUYByABKAFSCWFtb3VudER1ZQ==');

@$core.Deprecated('Use confirmExitRequestDescriptor instead')
const ConfirmExitRequest$json = {
  '1': 'ConfirmExitRequest',
  '2': [
    {'1': 'garage_id', '3': 1, '4': 1, '5': 9, '10': 'garageId'},
    {'1': 'vehicle_plate', '3': 2, '4': 1, '5': 9, '10': 'vehiclePlate'},
    {'1': 'agent_id', '3': 3, '4': 1, '5': 9, '10': 'agentId'},
  ],
};

/// Descriptor for `ConfirmExitRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List confirmExitRequestDescriptor = $convert.base64Decode(
    'ChJDb25maXJtRXhpdFJlcXVlc3QSGwoJZ2FyYWdlX2lkGAEgASgJUghnYXJhZ2VJZBIjCg12ZW'
    'hpY2xlX3BsYXRlGAIgASgJUgx2ZWhpY2xlUGxhdGUSGQoIYWdlbnRfaWQYAyABKAlSB2FnZW50'
    'SWQ=');

@$core.Deprecated('Use confirmExitResponseDescriptor instead')
const ConfirmExitResponse$json = {
  '1': 'ConfirmExitResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
    {
      '1': 'final_status',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.common.TicketStatus',
      '10': 'finalStatus'
    },
  ],
};

/// Descriptor for `ConfirmExitResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List confirmExitResponseDescriptor = $convert.base64Decode(
    'ChNDb25maXJtRXhpdFJlc3BvbnNlEhgKB3N1Y2Nlc3MYASABKAhSB3N1Y2Nlc3MSGAoHbWVzc2'
    'FnZRgCIAEoCVIHbWVzc2FnZRI3CgxmaW5hbF9zdGF0dXMYAyABKA4yFC5jb21tb24uVGlja2V0'
    'U3RhdHVzUgtmaW5hbFN0YXR1cw==');

@$core.Deprecated('Use sponsorshipLedgerEntryDescriptor instead')
const SponsorshipLedgerEntry$json = {
  '1': 'SponsorshipLedgerEntry',
  '2': [
    {'1': 'entry_id', '3': 1, '4': 1, '5': 9, '10': 'entryId'},
    {'1': 'store_id', '3': 2, '4': 1, '5': 9, '10': 'storeId'},
    {'1': 'store_name', '3': 3, '4': 1, '5': 9, '10': 'storeName'},
    {'1': 'amount', '3': 4, '4': 1, '5': 1, '10': 'amount'},
    {'1': 'invoice_id', '3': 5, '4': 1, '5': 9, '10': 'invoiceId'},
    {'1': 'timestamp', '3': 6, '4': 1, '5': 3, '10': 'timestamp'},
    {'1': 'sync_id', '3': 7, '4': 1, '5': 9, '10': 'syncId'},
    {'1': 'exchange_rate', '3': 8, '4': 1, '5': 1, '10': 'exchangeRate'},
    {'1': 'operator_id', '3': 9, '4': 1, '5': 9, '10': 'operatorId'},
  ],
};

/// Descriptor for `SponsorshipLedgerEntry`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sponsorshipLedgerEntryDescriptor = $convert.base64Decode(
    'ChZTcG9uc29yc2hpcExlZGdlckVudHJ5EhkKCGVudHJ5X2lkGAEgASgJUgdlbnRyeUlkEhkKCH'
    'N0b3JlX2lkGAIgASgJUgdzdG9yZUlkEh0KCnN0b3JlX25hbWUYAyABKAlSCXN0b3JlTmFtZRIW'
    'CgZhbW91bnQYBCABKAFSBmFtb3VudBIdCgppbnZvaWNlX2lkGAUgASgJUglpbnZvaWNlSWQSHA'
    'oJdGltZXN0YW1wGAYgASgDUgl0aW1lc3RhbXASFwoHc3luY19pZBgHIAEoCVIGc3luY0lkEiMK'
    'DWV4Y2hhbmdlX3JhdGUYCCABKAFSDGV4Y2hhbmdlUmF0ZRIfCgtvcGVyYXRvcl9pZBgJIAEoCV'
    'IKb3BlcmF0b3JJZA==');

@$core.Deprecated('Use getSponsorshipLedgerRequestDescriptor instead')
const GetSponsorshipLedgerRequest$json = {
  '1': 'GetSponsorshipLedgerRequest',
  '2': [
    {'1': 'reservation_id', '3': 1, '4': 1, '5': 9, '10': 'reservationId'},
  ],
};

/// Descriptor for `GetSponsorshipLedgerRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getSponsorshipLedgerRequestDescriptor =
    $convert.base64Decode(
        'ChtHZXRTcG9uc29yc2hpcExlZGdlclJlcXVlc3QSJQoOcmVzZXJ2YXRpb25faWQYASABKAlSDX'
        'Jlc2VydmF0aW9uSWQ=');

@$core.Deprecated('Use sponsorshipLedgerResponseDescriptor instead')
const SponsorshipLedgerResponse$json = {
  '1': 'SponsorshipLedgerResponse',
  '2': [
    {'1': 'reservation_id', '3': 1, '4': 1, '5': 9, '10': 'reservationId'},
    {'1': 'original_price', '3': 2, '4': 1, '5': 1, '10': 'originalPrice'},
    {'1': 'current_balance', '3': 3, '4': 1, '5': 1, '10': 'currentBalance'},
    {'1': 'total_sponsored', '3': 4, '4': 1, '5': 1, '10': 'totalSponsored'},
    {
      '1': 'status',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.common.TicketStatus',
      '10': 'status'
    },
    {
      '1': 'entries',
      '3': 6,
      '4': 3,
      '5': 11,
      '6': '.payment.SponsorshipLedgerEntry',
      '10': 'entries'
    },
    {
      '1': 'voucher',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.common.SignedVoucher',
      '10': 'voucher'
    },
    {'1': 'entry_count', '3': 8, '4': 1, '5': 5, '10': 'entryCount'},
  ],
};

/// Descriptor for `SponsorshipLedgerResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sponsorshipLedgerResponseDescriptor = $convert.base64Decode(
    'ChlTcG9uc29yc2hpcExlZGdlclJlc3BvbnNlEiUKDnJlc2VydmF0aW9uX2lkGAEgASgJUg1yZX'
    'NlcnZhdGlvbklkEiUKDm9yaWdpbmFsX3ByaWNlGAIgASgBUg1vcmlnaW5hbFByaWNlEicKD2N1'
    'cnJlbnRfYmFsYW5jZRgDIAEoAVIOY3VycmVudEJhbGFuY2USJwoPdG90YWxfc3BvbnNvcmVkGA'
    'QgASgBUg50b3RhbFNwb25zb3JlZBIsCgZzdGF0dXMYBSABKA4yFC5jb21tb24uVGlja2V0U3Rh'
    'dHVzUgZzdGF0dXMSOQoHZW50cmllcxgGIAMoCzIfLnBheW1lbnQuU3BvbnNvcnNoaXBMZWRnZX'
    'JFbnRyeVIHZW50cmllcxIvCgd2b3VjaGVyGAcgASgLMhUuY29tbW9uLlNpZ25lZFZvdWNoZXJS'
    'B3ZvdWNoZXISHwoLZW50cnlfY291bnQYCCABKAVSCmVudHJ5Q291bnQ=');

@$core.Deprecated('Use validateVoucherOfflineRequestDescriptor instead')
const ValidateVoucherOfflineRequest$json = {
  '1': 'ValidateVoucherOfflineRequest',
  '2': [
    {
      '1': 'signed_voucher_jwt',
      '3': 1,
      '4': 1,
      '5': 9,
      '10': 'signedVoucherJwt'
    },
    {'1': 'garage_id', '3': 2, '4': 1, '5': 9, '10': 'garageId'},
  ],
};

/// Descriptor for `ValidateVoucherOfflineRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List validateVoucherOfflineRequestDescriptor =
    $convert.base64Decode(
        'Ch1WYWxpZGF0ZVZvdWNoZXJPZmZsaW5lUmVxdWVzdBIsChJzaWduZWRfdm91Y2hlcl9qd3QYAS'
        'ABKAlSEHNpZ25lZFZvdWNoZXJKd3QSGwoJZ2FyYWdlX2lkGAIgASgJUghnYXJhZ2VJZA==');

@$core.Deprecated('Use validateVoucherOfflineResponseDescriptor instead')
const ValidateVoucherOfflineResponse$json = {
  '1': 'ValidateVoucherOfflineResponse',
  '2': [
    {'1': 'valid', '3': 1, '4': 1, '5': 8, '10': 'valid'},
    {'1': 'vehicle_plate', '3': 2, '4': 1, '5': 9, '10': 'vehiclePlate'},
    {'1': 'garage_id', '3': 3, '4': 1, '5': 9, '10': 'garageId'},
    {'1': 'expires_at', '3': 4, '4': 1, '5': 3, '10': 'expiresAt'},
    {'1': 'jti', '3': 5, '4': 1, '5': 9, '10': 'jti'},
    {'1': 'error_message', '3': 6, '4': 1, '5': 9, '10': 'errorMessage'},
    {
      '1': 'sponsors',
      '3': 7,
      '4': 3,
      '5': 11,
      '6': '.common.SponsorSummary',
      '10': 'sponsors'
    },
  ],
};

/// Descriptor for `ValidateVoucherOfflineResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List validateVoucherOfflineResponseDescriptor = $convert.base64Decode(
    'Ch5WYWxpZGF0ZVZvdWNoZXJPZmZsaW5lUmVzcG9uc2USFAoFdmFsaWQYASABKAhSBXZhbGlkEi'
    'MKDXZlaGljbGVfcGxhdGUYAiABKAlSDHZlaGljbGVQbGF0ZRIbCglnYXJhZ2VfaWQYAyABKAlS'
    'CGdhcmFnZUlkEh0KCmV4cGlyZXNfYXQYBCABKANSCWV4cGlyZXNBdBIQCgNqdGkYBSABKAlSA2'
    'p0aRIjCg1lcnJvcl9tZXNzYWdlGAYgASgJUgxlcnJvck1lc3NhZ2USMgoIc3BvbnNvcnMYByAD'
    'KAsyFi5jb21tb24uU3BvbnNvclN1bW1hcnlSCHNwb25zb3Jz');

@$core.Deprecated('Use registerUsedVoucherRequestDescriptor instead')
const RegisterUsedVoucherRequest$json = {
  '1': 'RegisterUsedVoucherRequest',
  '2': [
    {'1': 'jti', '3': 1, '4': 1, '5': 9, '10': 'jti'},
    {'1': 'reservation_id', '3': 2, '4': 1, '5': 9, '10': 'reservationId'},
    {'1': 'garage_id', '3': 3, '4': 1, '5': 9, '10': 'garageId'},
    {'1': 'agent_id', '3': 4, '4': 1, '5': 9, '10': 'agentId'},
    {'1': 'used_at', '3': 5, '4': 1, '5': 3, '10': 'usedAt'},
    {'1': 'vehicle_plate', '3': 6, '4': 1, '5': 9, '10': 'vehiclePlate'},
    {'1': 'sync_id', '3': 7, '4': 1, '5': 9, '10': 'syncId'},
  ],
};

/// Descriptor for `RegisterUsedVoucherRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List registerUsedVoucherRequestDescriptor = $convert.base64Decode(
    'ChpSZWdpc3RlclVzZWRWb3VjaGVyUmVxdWVzdBIQCgNqdGkYASABKAlSA2p0aRIlCg5yZXNlcn'
    'ZhdGlvbl9pZBgCIAEoCVINcmVzZXJ2YXRpb25JZBIbCglnYXJhZ2VfaWQYAyABKAlSCGdhcmFn'
    'ZUlkEhkKCGFnZW50X2lkGAQgASgJUgdhZ2VudElkEhcKB3VzZWRfYXQYBSABKANSBnVzZWRBdB'
    'IjCg12ZWhpY2xlX3BsYXRlGAYgASgJUgx2ZWhpY2xlUGxhdGUSFwoHc3luY19pZBgHIAEoCVIG'
    'c3luY0lk');

@$core.Deprecated('Use registerUsedVoucherResponseDescriptor instead')
const RegisterUsedVoucherResponse$json = {
  '1': 'RegisterUsedVoucherResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
    {'1': 'error_code', '3': 3, '4': 1, '5': 9, '10': 'errorCode'},
    {'1': 'used_at', '3': 4, '4': 1, '5': 3, '10': 'usedAt'},
    {'1': 'used_by_garage', '3': 5, '4': 1, '5': 9, '10': 'usedByGarage'},
  ],
};

/// Descriptor for `RegisterUsedVoucherResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List registerUsedVoucherResponseDescriptor = $convert.base64Decode(
    'ChtSZWdpc3RlclVzZWRWb3VjaGVyUmVzcG9uc2USGAoHc3VjY2VzcxgBIAEoCFIHc3VjY2Vzcx'
    'IYCgdtZXNzYWdlGAIgASgJUgdtZXNzYWdlEh0KCmVycm9yX2NvZGUYAyABKAlSCWVycm9yQ29k'
    'ZRIXCgd1c2VkX2F0GAQgASgDUgZ1c2VkQXQSJAoOdXNlZF9ieV9nYXJhZ2UYBSABKAlSDHVzZW'
    'RCeUdhcmFnZQ==');
