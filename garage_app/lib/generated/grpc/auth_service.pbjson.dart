// This is a generated file - do not edit.
//
// Generated from auth/auth_service.proto.

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

@$core.Deprecated('Use userRoleDescriptor instead')
const UserRole$json = {
  '1': 'UserRole',
  '2': [
    {'1': 'ROLE_UNSPECIFIED', '2': 0},
    {'1': 'ROLE_USER', '2': 1},
    {'1': 'ROLE_PARTNER_STORE', '2': 2},
    {'1': 'ROLE_PARTNER_PARKING', '2': 3},
    {'1': 'ROLE_ADMIN', '2': 4},
  ],
};

/// Descriptor for `UserRole`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List userRoleDescriptor = $convert.base64Decode(
    'CghVc2VyUm9sZRIUChBST0xFX1VOU1BFQ0lGSUVEEAASDQoJUk9MRV9VU0VSEAESFgoSUk9MRV'
    '9QQVJUTkVSX1NUT1JFEAISGAoUUk9MRV9QQVJUTkVSX1BBUktJTkcQAxIOCgpST0xFX0FETUlO'
    'EAQ=');

@$core.Deprecated('Use partnerTypeDescriptor instead')
const PartnerType$json = {
  '1': 'PartnerType',
  '2': [
    {'1': 'PARTNER_TYPE_UNSPECIFIED', '2': 0},
    {'1': 'PARKING_GARAGE', '2': 1},
    {'1': 'RETAIL_STORE', '2': 2},
  ],
};

/// Descriptor for `PartnerType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List partnerTypeDescriptor = $convert.base64Decode(
    'CgtQYXJ0bmVyVHlwZRIcChhQQVJUTkVSX1RZUEVfVU5TUEVDSUZJRUQQABISCg5QQVJLSU5HX0'
    'dBUkFHRRABEhAKDFJFVEFJTF9TVE9SRRAC');

@$core.Deprecated('Use registerUserRequestDescriptor instead')
const RegisterUserRequest$json = {
  '1': 'RegisterUserRequest',
  '2': [
    {'1': 'firebase_uid', '3': 1, '4': 1, '5': 9, '10': 'firebaseUid'},
    {'1': 'email', '3': 2, '4': 1, '5': 9, '10': 'email'},
    {'1': 'display_name', '3': 3, '4': 1, '5': 9, '10': 'displayName'},
    {'1': 'phone', '3': 4, '4': 1, '5': 9, '10': 'phone'},
  ],
};

/// Descriptor for `RegisterUserRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List registerUserRequestDescriptor = $convert.base64Decode(
    'ChNSZWdpc3RlclVzZXJSZXF1ZXN0EiEKDGZpcmViYXNlX3VpZBgBIAEoCVILZmlyZWJhc2VVaW'
    'QSFAoFZW1haWwYAiABKAlSBWVtYWlsEiEKDGRpc3BsYXlfbmFtZRgDIAEoCVILZGlzcGxheU5h'
    'bWUSFAoFcGhvbmUYBCABKAlSBXBob25l');

@$core.Deprecated('Use registerUserResponseDescriptor instead')
const RegisterUserResponse$json = {
  '1': 'RegisterUserResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
    {
      '1': 'profile',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.auth.UserProfile',
      '10': 'profile'
    },
  ],
};

/// Descriptor for `RegisterUserResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List registerUserResponseDescriptor = $convert.base64Decode(
    'ChRSZWdpc3RlclVzZXJSZXNwb25zZRIYCgdzdWNjZXNzGAEgASgIUgdzdWNjZXNzEhgKB21lc3'
    'NhZ2UYAiABKAlSB21lc3NhZ2USKwoHcHJvZmlsZRgDIAEoCzIRLmF1dGguVXNlclByb2ZpbGVS'
    'B3Byb2ZpbGU=');

@$core.Deprecated('Use registerPartnerRequestDescriptor instead')
const RegisterPartnerRequest$json = {
  '1': 'RegisterPartnerRequest',
  '2': [
    {'1': 'firebase_uid', '3': 1, '4': 1, '5': 9, '10': 'firebaseUid'},
    {'1': 'email', '3': 2, '4': 1, '5': 9, '10': 'email'},
    {'1': 'business_name', '3': 3, '4': 1, '5': 9, '10': 'businessName'},
    {'1': 'cnpj', '3': 4, '4': 1, '5': 9, '10': 'cnpj'},
    {'1': 'phone', '3': 5, '4': 1, '5': 9, '10': 'phone'},
    {'1': 'address', '3': 6, '4': 1, '5': 9, '10': 'address'},
    {
      '1': 'partner_type',
      '3': 7,
      '4': 1,
      '5': 14,
      '6': '.auth.PartnerType',
      '10': 'partnerType'
    },
    {'1': 'latitude', '3': 8, '4': 1, '5': 1, '10': 'latitude'},
    {'1': 'longitude', '3': 9, '4': 1, '5': 1, '10': 'longitude'},
  ],
};

/// Descriptor for `RegisterPartnerRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List registerPartnerRequestDescriptor = $convert.base64Decode(
    'ChZSZWdpc3RlclBhcnRuZXJSZXF1ZXN0EiEKDGZpcmViYXNlX3VpZBgBIAEoCVILZmlyZWJhc2'
    'VVaWQSFAoFZW1haWwYAiABKAlSBWVtYWlsEiMKDWJ1c2luZXNzX25hbWUYAyABKAlSDGJ1c2lu'
    'ZXNzTmFtZRISCgRjbnBqGAQgASgJUgRjbnBqEhQKBXBob25lGAUgASgJUgVwaG9uZRIYCgdhZG'
    'RyZXNzGAYgASgJUgdhZGRyZXNzEjQKDHBhcnRuZXJfdHlwZRgHIAEoDjIRLmF1dGguUGFydG5l'
    'clR5cGVSC3BhcnRuZXJUeXBlEhoKCGxhdGl0dWRlGAggASgBUghsYXRpdHVkZRIcCglsb25naX'
    'R1ZGUYCSABKAFSCWxvbmdpdHVkZQ==');

@$core.Deprecated('Use registerPartnerResponseDescriptor instead')
const RegisterPartnerResponse$json = {
  '1': 'RegisterPartnerResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
    {'1': 'partner_id', '3': 3, '4': 1, '5': 9, '10': 'partnerId'},
    {
      '1': 'profile',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.auth.UserProfile',
      '10': 'profile'
    },
  ],
};

/// Descriptor for `RegisterPartnerResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List registerPartnerResponseDescriptor = $convert.base64Decode(
    'ChdSZWdpc3RlclBhcnRuZXJSZXNwb25zZRIYCgdzdWNjZXNzGAEgASgIUgdzdWNjZXNzEhgKB2'
    '1lc3NhZ2UYAiABKAlSB21lc3NhZ2USHQoKcGFydG5lcl9pZBgDIAEoCVIJcGFydG5lcklkEisK'
    'B3Byb2ZpbGUYBCABKAsyES5hdXRoLlVzZXJQcm9maWxlUgdwcm9maWxl');

@$core.Deprecated('Use getProfileRequestDescriptor instead')
const GetProfileRequest$json = {
  '1': 'GetProfileRequest',
  '2': [
    {'1': 'user_id', '3': 1, '4': 1, '5': 9, '10': 'userId'},
  ],
};

/// Descriptor for `GetProfileRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getProfileRequestDescriptor = $convert.base64Decode(
    'ChFHZXRQcm9maWxlUmVxdWVzdBIXCgd1c2VyX2lkGAEgASgJUgZ1c2VySWQ=');

@$core.Deprecated('Use updateProfileRequestDescriptor instead')
const UpdateProfileRequest$json = {
  '1': 'UpdateProfileRequest',
  '2': [
    {'1': 'user_id', '3': 1, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'display_name', '3': 2, '4': 1, '5': 9, '10': 'displayName'},
    {'1': 'phone', '3': 3, '4': 1, '5': 9, '10': 'phone'},
    {'1': 'avatar_url', '3': 4, '4': 1, '5': 9, '10': 'avatarUrl'},
  ],
};

/// Descriptor for `UpdateProfileRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateProfileRequestDescriptor = $convert.base64Decode(
    'ChRVcGRhdGVQcm9maWxlUmVxdWVzdBIXCgd1c2VyX2lkGAEgASgJUgZ1c2VySWQSIQoMZGlzcG'
    'xheV9uYW1lGAIgASgJUgtkaXNwbGF5TmFtZRIUCgVwaG9uZRgDIAEoCVIFcGhvbmUSHQoKYXZh'
    'dGFyX3VybBgEIAEoCVIJYXZhdGFyVXJs');

@$core.Deprecated('Use userProfileDescriptor instead')
const UserProfile$json = {
  '1': 'UserProfile',
  '2': [
    {'1': 'user_id', '3': 1, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'email', '3': 2, '4': 1, '5': 9, '10': 'email'},
    {'1': 'display_name', '3': 3, '4': 1, '5': 9, '10': 'displayName'},
    {'1': 'phone', '3': 4, '4': 1, '5': 9, '10': 'phone'},
    {'1': 'avatar_url', '3': 5, '4': 1, '5': 9, '10': 'avatarUrl'},
    {'1': 'role', '3': 6, '4': 1, '5': 14, '6': '.auth.UserRole', '10': 'role'},
    {'1': 'partner_id', '3': 7, '4': 1, '5': 9, '10': 'partnerId'},
    {'1': 'partner_name', '3': 8, '4': 1, '5': 9, '10': 'partnerName'},
    {'1': 'created_at', '3': 9, '4': 1, '5': 3, '10': 'createdAt'},
    {'1': 'last_login', '3': 10, '4': 1, '5': 3, '10': 'lastLogin'},
  ],
};

/// Descriptor for `UserProfile`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userProfileDescriptor = $convert.base64Decode(
    'CgtVc2VyUHJvZmlsZRIXCgd1c2VyX2lkGAEgASgJUgZ1c2VySWQSFAoFZW1haWwYAiABKAlSBW'
    'VtYWlsEiEKDGRpc3BsYXlfbmFtZRgDIAEoCVILZGlzcGxheU5hbWUSFAoFcGhvbmUYBCABKAlS'
    'BXBob25lEh0KCmF2YXRhcl91cmwYBSABKAlSCWF2YXRhclVybBIiCgRyb2xlGAYgASgOMg4uYX'
    'V0aC5Vc2VyUm9sZVIEcm9sZRIdCgpwYXJ0bmVyX2lkGAcgASgJUglwYXJ0bmVySWQSIQoMcGFy'
    'dG5lcl9uYW1lGAggASgJUgtwYXJ0bmVyTmFtZRIdCgpjcmVhdGVkX2F0GAkgASgDUgljcmVhdG'
    'VkQXQSHQoKbGFzdF9sb2dpbhgKIAEoA1IJbGFzdExvZ2lu');

@$core.Deprecated('Use listPartnerStaffRequestDescriptor instead')
const ListPartnerStaffRequest$json = {
  '1': 'ListPartnerStaffRequest',
  '2': [
    {'1': 'partner_id', '3': 1, '4': 1, '5': 9, '10': 'partnerId'},
  ],
};

/// Descriptor for `ListPartnerStaffRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listPartnerStaffRequestDescriptor =
    $convert.base64Decode(
        'ChdMaXN0UGFydG5lclN0YWZmUmVxdWVzdBIdCgpwYXJ0bmVyX2lkGAEgASgJUglwYXJ0bmVySW'
        'Q=');

@$core.Deprecated('Use listPartnerStaffResponseDescriptor instead')
const ListPartnerStaffResponse$json = {
  '1': 'ListPartnerStaffResponse',
  '2': [
    {
      '1': 'staff',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.auth.UserProfile',
      '10': 'staff'
    },
  ],
};

/// Descriptor for `ListPartnerStaffResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listPartnerStaffResponseDescriptor =
    $convert.base64Decode(
        'ChhMaXN0UGFydG5lclN0YWZmUmVzcG9uc2USJwoFc3RhZmYYASADKAsyES5hdXRoLlVzZXJQcm'
        '9maWxlUgVzdGFmZg==');

@$core.Deprecated('Use addPartnerStaffRequestDescriptor instead')
const AddPartnerStaffRequest$json = {
  '1': 'AddPartnerStaffRequest',
  '2': [
    {'1': 'partner_id', '3': 1, '4': 1, '5': 9, '10': 'partnerId'},
    {'1': 'staff_email', '3': 2, '4': 1, '5': 9, '10': 'staffEmail'},
    {'1': 'staff_name', '3': 3, '4': 1, '5': 9, '10': 'staffName'},
    {'1': 'role', '3': 4, '4': 1, '5': 14, '6': '.auth.UserRole', '10': 'role'},
  ],
};

/// Descriptor for `AddPartnerStaffRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addPartnerStaffRequestDescriptor = $convert.base64Decode(
    'ChZBZGRQYXJ0bmVyU3RhZmZSZXF1ZXN0Eh0KCnBhcnRuZXJfaWQYASABKAlSCXBhcnRuZXJJZB'
    'IfCgtzdGFmZl9lbWFpbBgCIAEoCVIKc3RhZmZFbWFpbBIdCgpzdGFmZl9uYW1lGAMgASgJUglz'
    'dGFmZk5hbWUSIgoEcm9sZRgEIAEoDjIOLmF1dGguVXNlclJvbGVSBHJvbGU=');

@$core.Deprecated('Use addPartnerStaffResponseDescriptor instead')
const AddPartnerStaffResponse$json = {
  '1': 'AddPartnerStaffResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
    {'1': 'staff_id', '3': 3, '4': 1, '5': 9, '10': 'staffId'},
  ],
};

/// Descriptor for `AddPartnerStaffResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addPartnerStaffResponseDescriptor =
    $convert.base64Decode(
        'ChdBZGRQYXJ0bmVyU3RhZmZSZXNwb25zZRIYCgdzdWNjZXNzGAEgASgIUgdzdWNjZXNzEhgKB2'
        '1lc3NhZ2UYAiABKAlSB21lc3NhZ2USGQoIc3RhZmZfaWQYAyABKAlSB3N0YWZmSWQ=');

@$core.Deprecated('Use removePartnerStaffRequestDescriptor instead')
const RemovePartnerStaffRequest$json = {
  '1': 'RemovePartnerStaffRequest',
  '2': [
    {'1': 'partner_id', '3': 1, '4': 1, '5': 9, '10': 'partnerId'},
    {'1': 'staff_id', '3': 2, '4': 1, '5': 9, '10': 'staffId'},
  ],
};

/// Descriptor for `RemovePartnerStaffRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List removePartnerStaffRequestDescriptor =
    $convert.base64Decode(
        'ChlSZW1vdmVQYXJ0bmVyU3RhZmZSZXF1ZXN0Eh0KCnBhcnRuZXJfaWQYASABKAlSCXBhcnRuZX'
        'JJZBIZCghzdGFmZl9pZBgCIAEoCVIHc3RhZmZJZA==');

@$core.Deprecated('Use removePartnerStaffResponseDescriptor instead')
const RemovePartnerStaffResponse$json = {
  '1': 'RemovePartnerStaffResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `RemovePartnerStaffResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List removePartnerStaffResponseDescriptor =
    $convert.base64Decode(
        'ChpSZW1vdmVQYXJ0bmVyU3RhZmZSZXNwb25zZRIYCgdzdWNjZXNzGAEgASgIUgdzdWNjZXNzEh'
        'gKB21lc3NhZ2UYAiABKAlSB21lc3NhZ2U=');
