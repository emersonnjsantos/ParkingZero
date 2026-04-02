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

class VehicleStatus extends $pb.ProtobufEnum {
  static const VehicleStatus VEHICLE_STATUS_UNSPECIFIED =
      VehicleStatus._(0, _omitEnumNames ? '' : 'VEHICLE_STATUS_UNSPECIFIED');
  static const VehicleStatus PARKED =
      VehicleStatus._(1, _omitEnumNames ? '' : 'PARKED');
  static const VehicleStatus EXITED =
      VehicleStatus._(2, _omitEnumNames ? '' : 'EXITED');

  static const $core.List<VehicleStatus> values = <VehicleStatus>[
    VEHICLE_STATUS_UNSPECIFIED,
    PARKED,
    EXITED,
  ];

  static final $core.List<VehicleStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static VehicleStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const VehicleStatus._(super.value, super.name);
}

class TicketStatus extends $pb.ProtobufEnum {
  static const TicketStatus TICKET_STATUS_UNSPECIFIED =
      TicketStatus._(0, _omitEnumNames ? '' : 'TICKET_STATUS_UNSPECIFIED');
  static const TicketStatus TICKET_CREATED =
      TicketStatus._(1, _omitEnumNames ? '' : 'TICKET_CREATED');
  static const TicketStatus TICKET_PARTIALLY_SPONSORED =
      TicketStatus._(2, _omitEnumNames ? '' : 'TICKET_PARTIALLY_SPONSORED');
  static const TicketStatus TICKET_SPONSORED =
      TicketStatus._(3, _omitEnumNames ? '' : 'TICKET_SPONSORED');
  static const TicketStatus TICKET_COMPLETED =
      TicketStatus._(4, _omitEnumNames ? '' : 'TICKET_COMPLETED');

  static const $core.List<TicketStatus> values = <TicketStatus>[
    TICKET_STATUS_UNSPECIFIED,
    TICKET_CREATED,
    TICKET_PARTIALLY_SPONSORED,
    TICKET_SPONSORED,
    TICKET_COMPLETED,
  ];

  static final $core.List<TicketStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static TicketStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const TicketStatus._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
