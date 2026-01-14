// This is a generated file - do not edit.
//
// Generated from parking_service.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class ReservationStatus extends $pb.ProtobufEnum {
  static const ReservationStatus RESERVATION_STATUS_UNSPECIFIED =
      ReservationStatus._(
          0, _omitEnumNames ? '' : 'RESERVATION_STATUS_UNSPECIFIED');
  static const ReservationStatus PENDING =
      ReservationStatus._(1, _omitEnumNames ? '' : 'PENDING');
  static const ReservationStatus ACTIVE =
      ReservationStatus._(2, _omitEnumNames ? '' : 'ACTIVE');
  static const ReservationStatus COMPLETED =
      ReservationStatus._(3, _omitEnumNames ? '' : 'COMPLETED');
  static const ReservationStatus CANCELLED =
      ReservationStatus._(4, _omitEnumNames ? '' : 'CANCELLED');

  static const $core.List<ReservationStatus> values = <ReservationStatus>[
    RESERVATION_STATUS_UNSPECIFIED,
    PENDING,
    ACTIVE,
    COMPLETED,
    CANCELLED,
  ];

  static final $core.List<ReservationStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static ReservationStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ReservationStatus._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
