// This is a generated file - do not edit.
//
// Generated from common/types.proto.

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

@$core.Deprecated('Use reservationStatusDescriptor instead')
const ReservationStatus$json = {
  '1': 'ReservationStatus',
  '2': [
    {'1': 'RESERVATION_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'PENDING', '2': 1},
    {'1': 'ACTIVE', '2': 2},
    {'1': 'COMPLETED', '2': 3},
    {'1': 'CANCELLED', '2': 4},
  ],
};

/// Descriptor for `ReservationStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List reservationStatusDescriptor = $convert.base64Decode(
    'ChFSZXNlcnZhdGlvblN0YXR1cxIiCh5SRVNFUlZBVElPTl9TVEFUVVNfVU5TUEVDSUZJRUQQAB'
    'ILCgdQRU5ESU5HEAESCgoGQUNUSVZFEAISDQoJQ09NUExFVEVEEAMSDQoJQ0FOQ0VMTEVEEAQ=');

@$core.Deprecated('Use vehicleStatusDescriptor instead')
const VehicleStatus$json = {
  '1': 'VehicleStatus',
  '2': [
    {'1': 'VEHICLE_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'PARKED', '2': 1},
    {'1': 'EXITED', '2': 2},
  ],
};

/// Descriptor for `VehicleStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List vehicleStatusDescriptor = $convert.base64Decode(
    'Cg1WZWhpY2xlU3RhdHVzEh4KGlZFSElDTEVfU1RBVFVTX1VOU1BFQ0lGSUVEEAASCgoGUEFSS0'
    'VEEAESCgoGRVhJVEVEEAI=');

@$core.Deprecated('Use ticketStatusDescriptor instead')
const TicketStatus$json = {
  '1': 'TicketStatus',
  '2': [
    {'1': 'TICKET_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'TICKET_CREATED', '2': 1},
    {'1': 'TICKET_PARTIALLY_SPONSORED', '2': 2},
    {'1': 'TICKET_SPONSORED', '2': 3},
    {'1': 'TICKET_COMPLETED', '2': 4},
  ],
};

/// Descriptor for `TicketStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List ticketStatusDescriptor = $convert.base64Decode(
    'CgxUaWNrZXRTdGF0dXMSHQoZVElDS0VUX1NUQVRVU19VTlNQRUNJRklFRBAAEhIKDlRJQ0tFVF'
    '9DUkVBVEVEEAESHgoaVElDS0VUX1BBUlRJQUxMWV9TUE9OU09SRUQQAhIUChBUSUNLRVRfU1BP'
    'TlNPUkVEEAMSFAoQVElDS0VUX0NPTVBMRVRFRBAE');

@$core.Deprecated('Use campaignDescriptor instead')
const Campaign$json = {
  '1': 'Campaign',
  '2': [
    {'1': 'partner_name', '3': 1, '4': 1, '5': 9, '10': 'partnerName'},
    {'1': 'discount_rule', '3': 2, '4': 1, '5': 9, '10': 'discountRule'},
  ],
};

/// Descriptor for `Campaign`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List campaignDescriptor = $convert.base64Decode(
    'CghDYW1wYWlnbhIhCgxwYXJ0bmVyX25hbWUYASABKAlSC3BhcnRuZXJOYW1lEiMKDWRpc2NvdW'
    '50X3J1bGUYAiABKAlSDGRpc2NvdW50UnVsZQ==');

@$core.Deprecated('Use sponsorSummaryDescriptor instead')
const SponsorSummary$json = {
  '1': 'SponsorSummary',
  '2': [
    {'1': 'store_name', '3': 1, '4': 1, '5': 9, '10': 'storeName'},
    {'1': 'amount', '3': 2, '4': 1, '5': 1, '10': 'amount'},
  ],
};

/// Descriptor for `SponsorSummary`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sponsorSummaryDescriptor = $convert.base64Decode(
    'Cg5TcG9uc29yU3VtbWFyeRIdCgpzdG9yZV9uYW1lGAEgASgJUglzdG9yZU5hbWUSFgoGYW1vdW'
    '50GAIgASgBUgZhbW91bnQ=');

@$core.Deprecated('Use signedVoucherDescriptor instead')
const SignedVoucher$json = {
  '1': 'SignedVoucher',
  '2': [
    {'1': 'jwt', '3': 1, '4': 1, '5': 9, '10': 'jwt'},
    {'1': 'jti', '3': 2, '4': 1, '5': 9, '10': 'jti'},
    {'1': 'expires_at', '3': 3, '4': 1, '5': 3, '10': 'expiresAt'},
    {'1': 'qr_code_data', '3': 4, '4': 1, '5': 9, '10': 'qrCodeData'},
  ],
};

/// Descriptor for `SignedVoucher`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List signedVoucherDescriptor = $convert.base64Decode(
    'Cg1TaWduZWRWb3VjaGVyEhAKA2p3dBgBIAEoCVIDand0EhAKA2p0aRgCIAEoCVIDanRpEh0KCm'
    'V4cGlyZXNfYXQYAyABKANSCWV4cGlyZXNBdBIgCgxxcl9jb2RlX2RhdGEYBCABKAlSCnFyQ29k'
    'ZURhdGE=');
