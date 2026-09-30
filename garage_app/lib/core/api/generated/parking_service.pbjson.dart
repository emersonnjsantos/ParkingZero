// This is a generated file - do not edit.
//
// Generated from parking_service.proto.

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
      '6': '.parking.Garage',
      '10': 'garages'
    },
  ],
};

/// Descriptor for `SearchResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List searchResponseDescriptor = $convert.base64Decode(
    'Cg5TZWFyY2hSZXNwb25zZRIpCgdnYXJhZ2VzGAEgAygLMg8ucGFya2luZy5HYXJhZ2VSB2dhcm'
    'FnZXM=');

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
      '6': '.parking.Campaign',
      '10': 'campaigns'
    },
  ],
};

/// Descriptor for `Garage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List garageDescriptor = $convert.base64Decode(
    'CgZHYXJhZ2USDgoCaWQYASABKAlSAmlkEhIKBG5hbWUYAiABKAlSBG5hbWUSHQoKYmFzZV9wcm'
    'ljZRgDIAEoAVIJYmFzZVByaWNlEhoKCGxhdGl0dWRlGAQgASgBUghsYXRpdHVkZRIcCglsb25n'
    'aXR1ZGUYBSABKAFSCWxvbmdpdHVkZRIbCglpbWFnZV91cmwYBiABKAlSCGltYWdlVXJsEi8KCW'
    'NhbXBhaWducxgHIAMoCzIRLnBhcmtpbmcuQ2FtcGFpZ25SCWNhbXBhaWducw==');

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
