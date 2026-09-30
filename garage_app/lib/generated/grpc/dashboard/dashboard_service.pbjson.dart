// This is a generated file - do not edit.
//
// Generated from dashboard/dashboard_service.proto.

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

@$core.Deprecated('Use getParkingSummaryRequestDescriptor instead')
const GetParkingSummaryRequest$json = {
  '1': 'GetParkingSummaryRequest',
  '2': [
    {'1': 'garage_id', '3': 1, '4': 1, '5': 9, '10': 'garageId'},
    {'1': 'from_timestamp', '3': 2, '4': 1, '5': 3, '10': 'fromTimestamp'},
    {'1': 'to_timestamp', '3': 3, '4': 1, '5': 3, '10': 'toTimestamp'},
  ],
};

/// Descriptor for `GetParkingSummaryRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getParkingSummaryRequestDescriptor = $convert.base64Decode(
    'ChhHZXRQYXJraW5nU3VtbWFyeVJlcXVlc3QSGwoJZ2FyYWdlX2lkGAEgASgJUghnYXJhZ2VJZB'
    'IlCg5mcm9tX3RpbWVzdGFtcBgCIAEoA1INZnJvbVRpbWVzdGFtcBIhCgx0b190aW1lc3RhbXAY'
    'AyABKANSC3RvVGltZXN0YW1w');

@$core.Deprecated('Use parkingSummaryDescriptor instead')
const ParkingSummary$json = {
  '1': 'ParkingSummary',
  '2': [
    {'1': 'garage_id', '3': 1, '4': 1, '5': 9, '10': 'garageId'},
    {'1': 'total_entries', '3': 2, '4': 1, '5': 5, '10': 'totalEntries'},
    {'1': 'total_exits', '3': 3, '4': 1, '5': 5, '10': 'totalExits'},
    {
      '1': 'current_occupancy',
      '3': 4,
      '4': 1,
      '5': 5,
      '10': 'currentOccupancy'
    },
    {'1': 'total_revenue', '3': 5, '4': 1, '5': 1, '10': 'totalRevenue'},
    {'1': 'total_sponsored', '3': 6, '4': 1, '5': 1, '10': 'totalSponsored'},
    {
      '1': 'average_stay_hours',
      '3': 7,
      '4': 1,
      '5': 1,
      '10': 'averageStayHours'
    },
    {'1': 'period_start', '3': 8, '4': 1, '5': 3, '10': 'periodStart'},
    {'1': 'period_end', '3': 9, '4': 1, '5': 3, '10': 'periodEnd'},
  ],
};

/// Descriptor for `ParkingSummary`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List parkingSummaryDescriptor = $convert.base64Decode(
    'Cg5QYXJraW5nU3VtbWFyeRIbCglnYXJhZ2VfaWQYASABKAlSCGdhcmFnZUlkEiMKDXRvdGFsX2'
    'VudHJpZXMYAiABKAVSDHRvdGFsRW50cmllcxIfCgt0b3RhbF9leGl0cxgDIAEoBVIKdG90YWxF'
    'eGl0cxIrChFjdXJyZW50X29jY3VwYW5jeRgEIAEoBVIQY3VycmVudE9jY3VwYW5jeRIjCg10b3'
    'RhbF9yZXZlbnVlGAUgASgBUgx0b3RhbFJldmVudWUSJwoPdG90YWxfc3BvbnNvcmVkGAYgASgB'
    'Ug50b3RhbFNwb25zb3JlZBIsChJhdmVyYWdlX3N0YXlfaG91cnMYByABKAFSEGF2ZXJhZ2VTdG'
    'F5SG91cnMSIQoMcGVyaW9kX3N0YXJ0GAggASgDUgtwZXJpb2RTdGFydBIdCgpwZXJpb2RfZW5k'
    'GAkgASgDUglwZXJpb2RFbmQ=');

@$core.Deprecated('Use getRevenueReportRequestDescriptor instead')
const GetRevenueReportRequest$json = {
  '1': 'GetRevenueReportRequest',
  '2': [
    {'1': 'garage_id', '3': 1, '4': 1, '5': 9, '10': 'garageId'},
    {'1': 'period', '3': 2, '4': 1, '5': 9, '10': 'period'},
    {'1': 'from_timestamp', '3': 3, '4': 1, '5': 3, '10': 'fromTimestamp'},
    {'1': 'to_timestamp', '3': 4, '4': 1, '5': 3, '10': 'toTimestamp'},
  ],
};

/// Descriptor for `GetRevenueReportRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getRevenueReportRequestDescriptor = $convert.base64Decode(
    'ChdHZXRSZXZlbnVlUmVwb3J0UmVxdWVzdBIbCglnYXJhZ2VfaWQYASABKAlSCGdhcmFnZUlkEh'
    'YKBnBlcmlvZBgCIAEoCVIGcGVyaW9kEiUKDmZyb21fdGltZXN0YW1wGAMgASgDUg1mcm9tVGlt'
    'ZXN0YW1wEiEKDHRvX3RpbWVzdGFtcBgEIAEoA1ILdG9UaW1lc3RhbXA=');

@$core.Deprecated('Use revenueReportDescriptor instead')
const RevenueReport$json = {
  '1': 'RevenueReport',
  '2': [
    {'1': 'garage_id', '3': 1, '4': 1, '5': 9, '10': 'garageId'},
    {'1': 'total_revenue', '3': 2, '4': 1, '5': 1, '10': 'totalRevenue'},
    {'1': 'total_sponsored', '3': 3, '4': 1, '5': 1, '10': 'totalSponsored'},
    {'1': 'net_revenue', '3': 4, '4': 1, '5': 1, '10': 'netRevenue'},
    {
      '1': 'daily_breakdown',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.dashboard.DailyRevenue',
      '10': 'dailyBreakdown'
    },
    {
      '1': 'total_transactions',
      '3': 6,
      '4': 1,
      '5': 5,
      '10': 'totalTransactions'
    },
  ],
};

/// Descriptor for `RevenueReport`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List revenueReportDescriptor = $convert.base64Decode(
    'Cg1SZXZlbnVlUmVwb3J0EhsKCWdhcmFnZV9pZBgBIAEoCVIIZ2FyYWdlSWQSIwoNdG90YWxfcm'
    'V2ZW51ZRgCIAEoAVIMdG90YWxSZXZlbnVlEicKD3RvdGFsX3Nwb25zb3JlZBgDIAEoAVIOdG90'
    'YWxTcG9uc29yZWQSHwoLbmV0X3JldmVudWUYBCABKAFSCm5ldFJldmVudWUSQAoPZGFpbHlfYn'
    'JlYWtkb3duGAUgAygLMhcuZGFzaGJvYXJkLkRhaWx5UmV2ZW51ZVIOZGFpbHlCcmVha2Rvd24S'
    'LQoSdG90YWxfdHJhbnNhY3Rpb25zGAYgASgFUhF0b3RhbFRyYW5zYWN0aW9ucw==');

@$core.Deprecated('Use dailyRevenueDescriptor instead')
const DailyRevenue$json = {
  '1': 'DailyRevenue',
  '2': [
    {'1': 'date', '3': 1, '4': 1, '5': 9, '10': 'date'},
    {'1': 'revenue', '3': 2, '4': 1, '5': 1, '10': 'revenue'},
    {'1': 'sponsored', '3': 3, '4': 1, '5': 1, '10': 'sponsored'},
    {'1': 'entries', '3': 4, '4': 1, '5': 5, '10': 'entries'},
    {'1': 'exits', '3': 5, '4': 1, '5': 5, '10': 'exits'},
  ],
};

/// Descriptor for `DailyRevenue`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dailyRevenueDescriptor = $convert.base64Decode(
    'CgxEYWlseVJldmVudWUSEgoEZGF0ZRgBIAEoCVIEZGF0ZRIYCgdyZXZlbnVlGAIgASgBUgdyZX'
    'ZlbnVlEhwKCXNwb25zb3JlZBgDIAEoAVIJc3BvbnNvcmVkEhgKB2VudHJpZXMYBCABKAVSB2Vu'
    'dHJpZXMSFAoFZXhpdHMYBSABKAVSBWV4aXRz');

@$core.Deprecated('Use getStoreSummaryRequestDescriptor instead')
const GetStoreSummaryRequest$json = {
  '1': 'GetStoreSummaryRequest',
  '2': [
    {'1': 'store_id', '3': 1, '4': 1, '5': 9, '10': 'storeId'},
    {'1': 'from_timestamp', '3': 2, '4': 1, '5': 3, '10': 'fromTimestamp'},
    {'1': 'to_timestamp', '3': 3, '4': 1, '5': 3, '10': 'toTimestamp'},
  ],
};

/// Descriptor for `GetStoreSummaryRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getStoreSummaryRequestDescriptor = $convert.base64Decode(
    'ChZHZXRTdG9yZVN1bW1hcnlSZXF1ZXN0EhkKCHN0b3JlX2lkGAEgASgJUgdzdG9yZUlkEiUKDm'
    'Zyb21fdGltZXN0YW1wGAIgASgDUg1mcm9tVGltZXN0YW1wEiEKDHRvX3RpbWVzdGFtcBgDIAEo'
    'A1ILdG9UaW1lc3RhbXA=');

@$core.Deprecated('Use storeSponsorshipSummaryDescriptor instead')
const StoreSponsorshipSummary$json = {
  '1': 'StoreSponsorshipSummary',
  '2': [
    {'1': 'store_id', '3': 1, '4': 1, '5': 9, '10': 'storeId'},
    {'1': 'store_name', '3': 2, '4': 1, '5': 9, '10': 'storeName'},
    {'1': 'total_spent', '3': 3, '4': 1, '5': 1, '10': 'totalSpent'},
    {
      '1': 'total_sponsorships',
      '3': 4,
      '4': 1,
      '5': 5,
      '10': 'totalSponsorships'
    },
    {'1': 'unique_customers', '3': 5, '4': 1, '5': 5, '10': 'uniqueCustomers'},
    {'1': 'average_invoice', '3': 6, '4': 1, '5': 1, '10': 'averageInvoice'},
    {
      '1': 'monthly',
      '3': 7,
      '4': 3,
      '5': 11,
      '6': '.dashboard.MonthlySponsorshipStats',
      '10': 'monthly'
    },
  ],
};

/// Descriptor for `StoreSponsorshipSummary`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List storeSponsorshipSummaryDescriptor = $convert.base64Decode(
    'ChdTdG9yZVNwb25zb3JzaGlwU3VtbWFyeRIZCghzdG9yZV9pZBgBIAEoCVIHc3RvcmVJZBIdCg'
    'pzdG9yZV9uYW1lGAIgASgJUglzdG9yZU5hbWUSHwoLdG90YWxfc3BlbnQYAyABKAFSCnRvdGFs'
    'U3BlbnQSLQoSdG90YWxfc3BvbnNvcnNoaXBzGAQgASgFUhF0b3RhbFNwb25zb3JzaGlwcxIpCh'
    'B1bmlxdWVfY3VzdG9tZXJzGAUgASgFUg91bmlxdWVDdXN0b21lcnMSJwoPYXZlcmFnZV9pbnZv'
    'aWNlGAYgASgBUg5hdmVyYWdlSW52b2ljZRI8Cgdtb250aGx5GAcgAygLMiIuZGFzaGJvYXJkLk'
    '1vbnRobHlTcG9uc29yc2hpcFN0YXRzUgdtb250aGx5');

@$core.Deprecated('Use monthlySponsorshipStatsDescriptor instead')
const MonthlySponsorshipStats$json = {
  '1': 'MonthlySponsorshipStats',
  '2': [
    {'1': 'month', '3': 1, '4': 1, '5': 9, '10': 'month'},
    {'1': 'amount_spent', '3': 2, '4': 1, '5': 1, '10': 'amountSpent'},
    {
      '1': 'sponsorship_count',
      '3': 3,
      '4': 1,
      '5': 5,
      '10': 'sponsorshipCount'
    },
    {'1': 'customer_count', '3': 4, '4': 1, '5': 5, '10': 'customerCount'},
  ],
};

/// Descriptor for `MonthlySponsorshipStats`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List monthlySponsorshipStatsDescriptor = $convert.base64Decode(
    'ChdNb250aGx5U3BvbnNvcnNoaXBTdGF0cxIUCgVtb250aBgBIAEoCVIFbW9udGgSIQoMYW1vdW'
    '50X3NwZW50GAIgASgBUgthbW91bnRTcGVudBIrChFzcG9uc29yc2hpcF9jb3VudBgDIAEoBVIQ'
    'c3BvbnNvcnNoaXBDb3VudBIlCg5jdXN0b21lcl9jb3VudBgEIAEoBVINY3VzdG9tZXJDb3VudA'
    '==');

@$core.Deprecated('Use getOccupancyRequestDescriptor instead')
const GetOccupancyRequest$json = {
  '1': 'GetOccupancyRequest',
  '2': [
    {'1': 'garage_id', '3': 1, '4': 1, '5': 9, '10': 'garageId'},
  ],
};

/// Descriptor for `GetOccupancyRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getOccupancyRequestDescriptor =
    $convert.base64Decode(
        'ChNHZXRPY2N1cGFuY3lSZXF1ZXN0EhsKCWdhcmFnZV9pZBgBIAEoCVIIZ2FyYWdlSWQ=');

@$core.Deprecated('Use occupancyStatsDescriptor instead')
const OccupancyStats$json = {
  '1': 'OccupancyStats',
  '2': [
    {'1': 'garage_id', '3': 1, '4': 1, '5': 9, '10': 'garageId'},
    {'1': 'total_spots', '3': 2, '4': 1, '5': 5, '10': 'totalSpots'},
    {'1': 'occupied_spots', '3': 3, '4': 1, '5': 5, '10': 'occupiedSpots'},
    {'1': 'available_spots', '3': 4, '4': 1, '5': 5, '10': 'availableSpots'},
    {'1': 'occupancy_rate', '3': 5, '4': 1, '5': 1, '10': 'occupancyRate'},
    {
      '1': 'hourly_trend',
      '3': 6,
      '4': 3,
      '5': 11,
      '6': '.dashboard.HourlyOccupancy',
      '10': 'hourlyTrend'
    },
  ],
};

/// Descriptor for `OccupancyStats`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List occupancyStatsDescriptor = $convert.base64Decode(
    'Cg5PY2N1cGFuY3lTdGF0cxIbCglnYXJhZ2VfaWQYASABKAlSCGdhcmFnZUlkEh8KC3RvdGFsX3'
    'Nwb3RzGAIgASgFUgp0b3RhbFNwb3RzEiUKDm9jY3VwaWVkX3Nwb3RzGAMgASgFUg1vY2N1cGll'
    'ZFNwb3RzEicKD2F2YWlsYWJsZV9zcG90cxgEIAEoBVIOYXZhaWxhYmxlU3BvdHMSJQoOb2NjdX'
    'BhbmN5X3JhdGUYBSABKAFSDW9jY3VwYW5jeVJhdGUSPQoMaG91cmx5X3RyZW5kGAYgAygLMhou'
    'ZGFzaGJvYXJkLkhvdXJseU9jY3VwYW5jeVILaG91cmx5VHJlbmQ=');

@$core.Deprecated('Use hourlyOccupancyDescriptor instead')
const HourlyOccupancy$json = {
  '1': 'HourlyOccupancy',
  '2': [
    {'1': 'hour', '3': 1, '4': 1, '5': 5, '10': 'hour'},
    {
      '1': 'average_occupancy',
      '3': 2,
      '4': 1,
      '5': 1,
      '10': 'averageOccupancy'
    },
  ],
};

/// Descriptor for `HourlyOccupancy`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List hourlyOccupancyDescriptor = $convert.base64Decode(
    'Cg9Ib3VybHlPY2N1cGFuY3kSEgoEaG91chgBIAEoBVIEaG91chIrChFhdmVyYWdlX29jY3VwYW'
    '5jeRgCIAEoAVIQYXZlcmFnZU9jY3VwYW5jeQ==');

@$core.Deprecated('Use listBIEventsRequestDescriptor instead')
const ListBIEventsRequest$json = {
  '1': 'ListBIEventsRequest',
  '2': [
    {'1': 'event_type', '3': 1, '4': 1, '5': 9, '10': 'eventType'},
    {'1': 'from_timestamp', '3': 2, '4': 1, '5': 3, '10': 'fromTimestamp'},
    {'1': 'to_timestamp', '3': 3, '4': 1, '5': 3, '10': 'toTimestamp'},
    {'1': 'limit', '3': 4, '4': 1, '5': 5, '10': 'limit'},
  ],
};

/// Descriptor for `ListBIEventsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listBIEventsRequestDescriptor = $convert.base64Decode(
    'ChNMaXN0QklFdmVudHNSZXF1ZXN0Eh0KCmV2ZW50X3R5cGUYASABKAlSCWV2ZW50VHlwZRIlCg'
    '5mcm9tX3RpbWVzdGFtcBgCIAEoA1INZnJvbVRpbWVzdGFtcBIhCgx0b190aW1lc3RhbXAYAyAB'
    'KANSC3RvVGltZXN0YW1wEhQKBWxpbWl0GAQgASgFUgVsaW1pdA==');

@$core.Deprecated('Use listBIEventsResponseDescriptor instead')
const ListBIEventsResponse$json = {
  '1': 'ListBIEventsResponse',
  '2': [
    {
      '1': 'events',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.dashboard.BIEvent',
      '10': 'events'
    },
    {'1': 'total_count', '3': 2, '4': 1, '5': 5, '10': 'totalCount'},
  ],
};

/// Descriptor for `ListBIEventsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listBIEventsResponseDescriptor = $convert.base64Decode(
    'ChRMaXN0QklFdmVudHNSZXNwb25zZRIqCgZldmVudHMYASADKAsyEi5kYXNoYm9hcmQuQklFdm'
    'VudFIGZXZlbnRzEh8KC3RvdGFsX2NvdW50GAIgASgFUgp0b3RhbENvdW50');

@$core.Deprecated('Use bIEventDescriptor instead')
const BIEvent$json = {
  '1': 'BIEvent',
  '2': [
    {'1': 'event_id', '3': 1, '4': 1, '5': 9, '10': 'eventId'},
    {'1': 'event_type', '3': 2, '4': 1, '5': 9, '10': 'eventType'},
    {'1': 'entity_id', '3': 3, '4': 1, '5': 9, '10': 'entityId'},
    {'1': 'timestamp', '3': 4, '4': 1, '5': 3, '10': 'timestamp'},
    {
      '1': 'metadata',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.dashboard.BIEvent.MetadataEntry',
      '10': 'metadata'
    },
  ],
  '3': [BIEvent_MetadataEntry$json],
};

@$core.Deprecated('Use bIEventDescriptor instead')
const BIEvent_MetadataEntry$json = {
  '1': 'MetadataEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `BIEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bIEventDescriptor = $convert.base64Decode(
    'CgdCSUV2ZW50EhkKCGV2ZW50X2lkGAEgASgJUgdldmVudElkEh0KCmV2ZW50X3R5cGUYAiABKA'
    'lSCWV2ZW50VHlwZRIbCgllbnRpdHlfaWQYAyABKAlSCGVudGl0eUlkEhwKCXRpbWVzdGFtcBgE'
    'IAEoA1IJdGltZXN0YW1wEjwKCG1ldGFkYXRhGAUgAygLMiAuZGFzaGJvYXJkLkJJRXZlbnQuTW'
    'V0YWRhdGFFbnRyeVIIbWV0YWRhdGEaOwoNTWV0YWRhdGFFbnRyeRIQCgNrZXkYASABKAlSA2tl'
    'eRIUCgV2YWx1ZRgCIAEoCVIFdmFsdWU6AjgB');
