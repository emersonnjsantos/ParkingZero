// This is a generated file - do not edit.
//
// Generated from garage/garage_service.proto.

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

@$core.Deprecated('Use searchRequestDescriptor instead')
const SearchRequest$json = {
  '1': 'SearchRequest',
  '2': [
    {'1': 'latitude', '3': 1, '4': 1, '5': 1, '10': 'latitude'},
    {'1': 'longitude', '3': 2, '4': 1, '5': 1, '10': 'longitude'},
    {'1': 'radius_meters', '3': 3, '4': 1, '5': 5, '10': 'radiusMeters'},
  ],
};

/// Descriptor for `SearchRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List searchRequestDescriptor = $convert.base64Decode(
    'Cg1TZWFyY2hSZXF1ZXN0EhoKCGxhdGl0dWRlGAEgASgBUghsYXRpdHVkZRIcCglsb25naXR1ZG'
    'UYAiABKAFSCWxvbmdpdHVkZRIjCg1yYWRpdXNfbWV0ZXJzGAMgASgFUgxyYWRpdXNNZXRlcnM=');

@$core.Deprecated('Use searchResponseDescriptor instead')
const SearchResponse$json = {
  '1': 'SearchResponse',
  '2': [
    {
      '1': 'garages',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.garage.Garage',
      '10': 'garages'
    },
  ],
};

/// Descriptor for `SearchResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List searchResponseDescriptor = $convert.base64Decode(
    'Cg5TZWFyY2hSZXNwb25zZRIoCgdnYXJhZ2VzGAEgAygLMg4uZ2FyYWdlLkdhcmFnZVIHZ2FyYW'
    'dlcw==');

@$core.Deprecated('Use getGarageRequestDescriptor instead')
const GetGarageRequest$json = {
  '1': 'GetGarageRequest',
  '2': [
    {'1': 'garage_id', '3': 1, '4': 1, '5': 9, '10': 'garageId'},
  ],
};

/// Descriptor for `GetGarageRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getGarageRequestDescriptor = $convert.base64Decode(
    'ChBHZXRHYXJhZ2VSZXF1ZXN0EhsKCWdhcmFnZV9pZBgBIAEoCVIIZ2FyYWdlSWQ=');

@$core.Deprecated('Use garageDescriptor instead')
const Garage$json = {
  '1': 'Garage',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'base_price', '3': 3, '4': 1, '5': 1, '10': 'basePrice'},
    {'1': 'latitude', '3': 4, '4': 1, '5': 1, '10': 'latitude'},
    {'1': 'longitude', '3': 5, '4': 1, '5': 1, '10': 'longitude'},
    {'1': 'image_url', '3': 6, '4': 1, '5': 9, '10': 'imageUrl'},
    {
      '1': 'campaigns',
      '3': 7,
      '4': 3,
      '5': 11,
      '6': '.common.Campaign',
      '10': 'campaigns'
    },
    {'1': 'address', '3': 8, '4': 1, '5': 9, '10': 'address'},
    {'1': 'phone', '3': 9, '4': 1, '5': 9, '10': 'phone'},
    {'1': 'total_spots', '3': 10, '4': 1, '5': 5, '10': 'totalSpots'},
    {'1': 'available_spots', '3': 11, '4': 1, '5': 5, '10': 'availableSpots'},
    {'1': 'amenities', '3': 12, '4': 3, '5': 9, '10': 'amenities'},
  ],
};

/// Descriptor for `Garage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List garageDescriptor = $convert.base64Decode(
    'CgZHYXJhZ2USDgoCaWQYASABKAlSAmlkEhIKBG5hbWUYAiABKAlSBG5hbWUSHQoKYmFzZV9wcm'
    'ljZRgDIAEoAVIJYmFzZVByaWNlEhoKCGxhdGl0dWRlGAQgASgBUghsYXRpdHVkZRIcCglsb25n'
    'aXR1ZGUYBSABKAFSCWxvbmdpdHVkZRIbCglpbWFnZV91cmwYBiABKAlSCGltYWdlVXJsEi4KCW'
    'NhbXBhaWducxgHIAMoCzIQLmNvbW1vbi5DYW1wYWlnblIJY2FtcGFpZ25zEhgKB2FkZHJlc3MY'
    'CCABKAlSB2FkZHJlc3MSFAoFcGhvbmUYCSABKAlSBXBob25lEh8KC3RvdGFsX3Nwb3RzGAogAS'
    'gFUgp0b3RhbFNwb3RzEicKD2F2YWlsYWJsZV9zcG90cxgLIAEoBVIOYXZhaWxhYmxlU3BvdHMS'
    'HAoJYW1lbml0aWVzGAwgAygJUglhbWVuaXRpZXM=');

@$core.Deprecated('Use createReservationRequestDescriptor instead')
const CreateReservationRequest$json = {
  '1': 'CreateReservationRequest',
  '2': [
    {'1': 'user_id', '3': 1, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'garage_id', '3': 2, '4': 1, '5': 9, '10': 'garageId'},
    {'1': 'start_time', '3': 3, '4': 1, '5': 3, '10': 'startTime'},
    {'1': 'end_time', '3': 4, '4': 1, '5': 3, '10': 'endTime'},
    {'1': 'vehicle_plate', '3': 5, '4': 1, '5': 9, '10': 'vehiclePlate'},
  ],
};

/// Descriptor for `CreateReservationRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createReservationRequestDescriptor = $convert.base64Decode(
    'ChhDcmVhdGVSZXNlcnZhdGlvblJlcXVlc3QSFwoHdXNlcl9pZBgBIAEoCVIGdXNlcklkEhsKCW'
    'dhcmFnZV9pZBgCIAEoCVIIZ2FyYWdlSWQSHQoKc3RhcnRfdGltZRgDIAEoA1IJc3RhcnRUaW1l'
    'EhkKCGVuZF90aW1lGAQgASgDUgdlbmRUaW1lEiMKDXZlaGljbGVfcGxhdGUYBSABKAlSDHZlaG'
    'ljbGVQbGF0ZQ==');

@$core.Deprecated('Use reservationDescriptor instead')
const Reservation$json = {
  '1': 'Reservation',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'user_id', '3': 2, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'garage_id', '3': 3, '4': 1, '5': 9, '10': 'garageId'},
    {'1': 'garage_name', '3': 4, '4': 1, '5': 9, '10': 'garageName'},
    {'1': 'start_time', '3': 5, '4': 1, '5': 3, '10': 'startTime'},
    {'1': 'end_time', '3': 6, '4': 1, '5': 3, '10': 'endTime'},
    {'1': 'vehicle_plate', '3': 7, '4': 1, '5': 9, '10': 'vehiclePlate'},
    {'1': 'total_price', '3': 8, '4': 1, '5': 1, '10': 'totalPrice'},
    {
      '1': 'status',
      '3': 9,
      '4': 1,
      '5': 14,
      '6': '.common.ReservationStatus',
      '10': 'status'
    },
    {'1': 'created_at', '3': 10, '4': 1, '5': 3, '10': 'createdAt'},
  ],
};

/// Descriptor for `Reservation`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reservationDescriptor = $convert.base64Decode(
    'CgtSZXNlcnZhdGlvbhIOCgJpZBgBIAEoCVICaWQSFwoHdXNlcl9pZBgCIAEoCVIGdXNlcklkEh'
    'sKCWdhcmFnZV9pZBgDIAEoCVIIZ2FyYWdlSWQSHwoLZ2FyYWdlX25hbWUYBCABKAlSCmdhcmFn'
    'ZU5hbWUSHQoKc3RhcnRfdGltZRgFIAEoA1IJc3RhcnRUaW1lEhkKCGVuZF90aW1lGAYgASgDUg'
    'dlbmRUaW1lEiMKDXZlaGljbGVfcGxhdGUYByABKAlSDHZlaGljbGVQbGF0ZRIfCgt0b3RhbF9w'
    'cmljZRgIIAEoAVIKdG90YWxQcmljZRIxCgZzdGF0dXMYCSABKA4yGS5jb21tb24uUmVzZXJ2YX'
    'Rpb25TdGF0dXNSBnN0YXR1cxIdCgpjcmVhdGVkX2F0GAogASgDUgljcmVhdGVkQXQ=');

@$core.Deprecated('Use listReservationsRequestDescriptor instead')
const ListReservationsRequest$json = {
  '1': 'ListReservationsRequest',
  '2': [
    {'1': 'user_id', '3': 1, '4': 1, '5': 9, '10': 'userId'},
    {
      '1': 'status_filter',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.common.ReservationStatus',
      '10': 'statusFilter'
    },
  ],
};

/// Descriptor for `ListReservationsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listReservationsRequestDescriptor = $convert.base64Decode(
    'ChdMaXN0UmVzZXJ2YXRpb25zUmVxdWVzdBIXCgd1c2VyX2lkGAEgASgJUgZ1c2VySWQSPgoNc3'
    'RhdHVzX2ZpbHRlchgCIAEoDjIZLmNvbW1vbi5SZXNlcnZhdGlvblN0YXR1c1IMc3RhdHVzRmls'
    'dGVy');

@$core.Deprecated('Use listReservationsResponseDescriptor instead')
const ListReservationsResponse$json = {
  '1': 'ListReservationsResponse',
  '2': [
    {
      '1': 'reservations',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.garage.Reservation',
      '10': 'reservations'
    },
  ],
};

/// Descriptor for `ListReservationsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listReservationsResponseDescriptor =
    $convert.base64Decode(
        'ChhMaXN0UmVzZXJ2YXRpb25zUmVzcG9uc2USNwoMcmVzZXJ2YXRpb25zGAEgAygLMhMuZ2FyYW'
        'dlLlJlc2VydmF0aW9uUgxyZXNlcnZhdGlvbnM=');

@$core.Deprecated('Use cancelReservationRequestDescriptor instead')
const CancelReservationRequest$json = {
  '1': 'CancelReservationRequest',
  '2': [
    {'1': 'reservation_id', '3': 1, '4': 1, '5': 9, '10': 'reservationId'},
    {'1': 'user_id', '3': 2, '4': 1, '5': 9, '10': 'userId'},
  ],
};

/// Descriptor for `CancelReservationRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cancelReservationRequestDescriptor =
    $convert.base64Decode(
        'ChhDYW5jZWxSZXNlcnZhdGlvblJlcXVlc3QSJQoOcmVzZXJ2YXRpb25faWQYASABKAlSDXJlc2'
        'VydmF0aW9uSWQSFwoHdXNlcl9pZBgCIAEoCVIGdXNlcklk');

@$core.Deprecated('Use cancelReservationResponseDescriptor instead')
const CancelReservationResponse$json = {
  '1': 'CancelReservationResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `CancelReservationResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cancelReservationResponseDescriptor =
    $convert.base64Decode(
        'ChlDYW5jZWxSZXNlcnZhdGlvblJlc3BvbnNlEhgKB3N1Y2Nlc3MYASABKAhSB3N1Y2Nlc3MSGA'
        'oHbWVzc2FnZRgCIAEoCVIHbWVzc2FnZQ==');
