// This is a generated file - do not edit.
//
// Generated from vehicle/vehicle_service.proto.

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

@$core.Deprecated('Use vehicleEntryRequestDescriptor instead')
const VehicleEntryRequest$json = {
  '1': 'VehicleEntryRequest',
  '2': [
    {'1': 'garage_id', '3': 1, '4': 1, '5': 9, '10': 'garageId'},
    {'1': 'vehicle_plate', '3': 2, '4': 1, '5': 9, '10': 'vehiclePlate'},
    {'1': 'entry_time', '3': 3, '4': 1, '5': 3, '10': 'entryTime'},
    {'1': 'user_id', '3': 4, '4': 1, '5': 9, '10': 'userId'},
  ],
};

/// Descriptor for `VehicleEntryRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List vehicleEntryRequestDescriptor = $convert.base64Decode(
    'ChNWZWhpY2xlRW50cnlSZXF1ZXN0EhsKCWdhcmFnZV9pZBgBIAEoCVIIZ2FyYWdlSWQSIwoNdm'
    'VoaWNsZV9wbGF0ZRgCIAEoCVIMdmVoaWNsZVBsYXRlEh0KCmVudHJ5X3RpbWUYAyABKANSCWVu'
    'dHJ5VGltZRIXCgd1c2VyX2lkGAQgASgJUgZ1c2VySWQ=');

@$core.Deprecated('Use vehicleEntryResponseDescriptor instead')
const VehicleEntryResponse$json = {
  '1': 'VehicleEntryResponse',
  '2': [
    {'1': 'entry_id', '3': 1, '4': 1, '5': 9, '10': 'entryId'},
    {'1': 'success', '3': 2, '4': 1, '5': 8, '10': 'success'},
    {'1': 'message', '3': 3, '4': 1, '5': 9, '10': 'message'},
    {'1': 'entry_time', '3': 4, '4': 1, '5': 3, '10': 'entryTime'},
  ],
};

/// Descriptor for `VehicleEntryResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List vehicleEntryResponseDescriptor = $convert.base64Decode(
    'ChRWZWhpY2xlRW50cnlSZXNwb25zZRIZCghlbnRyeV9pZBgBIAEoCVIHZW50cnlJZBIYCgdzdW'
    'NjZXNzGAIgASgIUgdzdWNjZXNzEhgKB21lc3NhZ2UYAyABKAlSB21lc3NhZ2USHQoKZW50cnlf'
    'dGltZRgEIAEoA1IJZW50cnlUaW1l');

@$core.Deprecated('Use vehicleExitRequestDescriptor instead')
const VehicleExitRequest$json = {
  '1': 'VehicleExitRequest',
  '2': [
    {'1': 'garage_id', '3': 1, '4': 1, '5': 9, '10': 'garageId'},
    {'1': 'vehicle_plate', '3': 2, '4': 1, '5': 9, '10': 'vehiclePlate'},
    {'1': 'exit_time', '3': 3, '4': 1, '5': 3, '10': 'exitTime'},
  ],
};

/// Descriptor for `VehicleExitRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List vehicleExitRequestDescriptor = $convert.base64Decode(
    'ChJWZWhpY2xlRXhpdFJlcXVlc3QSGwoJZ2FyYWdlX2lkGAEgASgJUghnYXJhZ2VJZBIjCg12ZW'
    'hpY2xlX3BsYXRlGAIgASgJUgx2ZWhpY2xlUGxhdGUSGwoJZXhpdF90aW1lGAMgASgDUghleGl0'
    'VGltZQ==');

@$core.Deprecated('Use vehicleExitResponseDescriptor instead')
const VehicleExitResponse$json = {
  '1': 'VehicleExitResponse',
  '2': [
    {'1': 'entry_id', '3': 1, '4': 1, '5': 9, '10': 'entryId'},
    {'1': 'total_amount', '3': 2, '4': 1, '5': 1, '10': 'totalAmount'},
    {'1': 'duration_seconds', '3': 3, '4': 1, '5': 3, '10': 'durationSeconds'},
    {'1': 'entry_time', '3': 4, '4': 1, '5': 3, '10': 'entryTime'},
    {'1': 'exit_time', '3': 5, '4': 1, '5': 3, '10': 'exitTime'},
    {'1': 'success', '3': 6, '4': 1, '5': 8, '10': 'success'},
    {'1': 'message', '3': 7, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `VehicleExitResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List vehicleExitResponseDescriptor = $convert.base64Decode(
    'ChNWZWhpY2xlRXhpdFJlc3BvbnNlEhkKCGVudHJ5X2lkGAEgASgJUgdlbnRyeUlkEiEKDHRvdG'
    'FsX2Ftb3VudBgCIAEoAVILdG90YWxBbW91bnQSKQoQZHVyYXRpb25fc2Vjb25kcxgDIAEoA1IP'
    'ZHVyYXRpb25TZWNvbmRzEh0KCmVudHJ5X3RpbWUYBCABKANSCWVudHJ5VGltZRIbCglleGl0X3'
    'RpbWUYBSABKANSCGV4aXRUaW1lEhgKB3N1Y2Nlc3MYBiABKAhSB3N1Y2Nlc3MSGAoHbWVzc2Fn'
    'ZRgHIAEoCVIHbWVzc2FnZQ==');

@$core.Deprecated('Use vehicleEntryDescriptor instead')
const VehicleEntry$json = {
  '1': 'VehicleEntry',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'garage_id', '3': 2, '4': 1, '5': 9, '10': 'garageId'},
    {'1': 'vehicle_plate', '3': 3, '4': 1, '5': 9, '10': 'vehiclePlate'},
    {'1': 'entry_time', '3': 4, '4': 1, '5': 3, '10': 'entryTime'},
    {'1': 'exit_time', '3': 5, '4': 1, '5': 3, '10': 'exitTime'},
    {'1': 'amount_paid', '3': 6, '4': 1, '5': 1, '10': 'amountPaid'},
    {
      '1': 'status',
      '3': 7,
      '4': 1,
      '5': 14,
      '6': '.common.VehicleStatus',
      '10': 'status'
    },
    {'1': 'user_id', '3': 8, '4': 1, '5': 9, '10': 'userId'},
  ],
};

/// Descriptor for `VehicleEntry`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List vehicleEntryDescriptor = $convert.base64Decode(
    'CgxWZWhpY2xlRW50cnkSDgoCaWQYASABKAlSAmlkEhsKCWdhcmFnZV9pZBgCIAEoCVIIZ2FyYW'
    'dlSWQSIwoNdmVoaWNsZV9wbGF0ZRgDIAEoCVIMdmVoaWNsZVBsYXRlEh0KCmVudHJ5X3RpbWUY'
    'BCABKANSCWVudHJ5VGltZRIbCglleGl0X3RpbWUYBSABKANSCGV4aXRUaW1lEh8KC2Ftb3VudF'
    '9wYWlkGAYgASgBUgphbW91bnRQYWlkEi0KBnN0YXR1cxgHIAEoDjIVLmNvbW1vbi5WZWhpY2xl'
    'U3RhdHVzUgZzdGF0dXMSFwoHdXNlcl9pZBgIIAEoCVIGdXNlcklk');

@$core.Deprecated('Use getActiveVehiclesRequestDescriptor instead')
const GetActiveVehiclesRequest$json = {
  '1': 'GetActiveVehiclesRequest',
  '2': [
    {'1': 'garage_id', '3': 1, '4': 1, '5': 9, '10': 'garageId'},
  ],
};

/// Descriptor for `GetActiveVehiclesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getActiveVehiclesRequestDescriptor =
    $convert.base64Decode(
        'ChhHZXRBY3RpdmVWZWhpY2xlc1JlcXVlc3QSGwoJZ2FyYWdlX2lkGAEgASgJUghnYXJhZ2VJZA'
        '==');

@$core.Deprecated('Use getActiveVehiclesResponseDescriptor instead')
const GetActiveVehiclesResponse$json = {
  '1': 'GetActiveVehiclesResponse',
  '2': [
    {
      '1': 'vehicles',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.vehicle.VehicleEntry',
      '10': 'vehicles'
    },
    {'1': 'total_active', '3': 2, '4': 1, '5': 5, '10': 'totalActive'},
  ],
};

/// Descriptor for `GetActiveVehiclesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getActiveVehiclesResponseDescriptor = $convert.base64Decode(
    'ChlHZXRBY3RpdmVWZWhpY2xlc1Jlc3BvbnNlEjEKCHZlaGljbGVzGAEgAygLMhUudmVoaWNsZS'
    '5WZWhpY2xlRW50cnlSCHZlaGljbGVzEiEKDHRvdGFsX2FjdGl2ZRgCIAEoBVILdG90YWxBY3Rp'
    'dmU=');

@$core.Deprecated('Use getVehicleEntryRequestDescriptor instead')
const GetVehicleEntryRequest$json = {
  '1': 'GetVehicleEntryRequest',
  '2': [
    {'1': 'garage_id', '3': 1, '4': 1, '5': 9, '10': 'garageId'},
    {'1': 'vehicle_plate', '3': 2, '4': 1, '5': 9, '10': 'vehiclePlate'},
  ],
};

/// Descriptor for `GetVehicleEntryRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getVehicleEntryRequestDescriptor =
    $convert.base64Decode(
        'ChZHZXRWZWhpY2xlRW50cnlSZXF1ZXN0EhsKCWdhcmFnZV9pZBgBIAEoCVIIZ2FyYWdlSWQSIw'
        'oNdmVoaWNsZV9wbGF0ZRgCIAEoCVIMdmVoaWNsZVBsYXRl');
