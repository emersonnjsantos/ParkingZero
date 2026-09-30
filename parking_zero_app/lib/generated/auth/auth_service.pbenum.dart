// This is a generated file - do not edit.
//
// Generated from auth/auth_service.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class UserRole extends $pb.ProtobufEnum {
  static const UserRole ROLE_UNSPECIFIED =
      UserRole._(0, _omitEnumNames ? '' : 'ROLE_UNSPECIFIED');
  static const UserRole ROLE_USER =
      UserRole._(1, _omitEnumNames ? '' : 'ROLE_USER');
  static const UserRole ROLE_PARTNER_STORE =
      UserRole._(2, _omitEnumNames ? '' : 'ROLE_PARTNER_STORE');
  static const UserRole ROLE_PARTNER_PARKING =
      UserRole._(3, _omitEnumNames ? '' : 'ROLE_PARTNER_PARKING');
  static const UserRole ROLE_ADMIN =
      UserRole._(4, _omitEnumNames ? '' : 'ROLE_ADMIN');

  static const $core.List<UserRole> values = <UserRole>[
    ROLE_UNSPECIFIED,
    ROLE_USER,
    ROLE_PARTNER_STORE,
    ROLE_PARTNER_PARKING,
    ROLE_ADMIN,
  ];

  static final $core.List<UserRole?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static UserRole? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const UserRole._(super.value, super.name);
}

class PartnerType extends $pb.ProtobufEnum {
  static const PartnerType PARTNER_TYPE_UNSPECIFIED =
      PartnerType._(0, _omitEnumNames ? '' : 'PARTNER_TYPE_UNSPECIFIED');
  static const PartnerType PARKING_GARAGE =
      PartnerType._(1, _omitEnumNames ? '' : 'PARKING_GARAGE');
  static const PartnerType RETAIL_STORE =
      PartnerType._(2, _omitEnumNames ? '' : 'RETAIL_STORE');

  static const $core.List<PartnerType> values = <PartnerType>[
    PARTNER_TYPE_UNSPECIFIED,
    PARKING_GARAGE,
    RETAIL_STORE,
  ];

  static final $core.List<PartnerType?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static PartnerType? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const PartnerType._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
