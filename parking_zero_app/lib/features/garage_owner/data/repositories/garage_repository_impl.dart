import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:parking_common/services/parking_grpc_client.dart';
import 'package:parking_app/features/garage_owner/domain/entities/garage.dart';
import 'package:parking_app/features/garage_owner/domain/repositories/garage_repository.dart';

class GarageRepositoryImpl implements GarageRepository {
  final ParkingGrpcClient _grpcClient;
  final FirebaseStorage _storage;

  GarageRepositoryImpl({
    required ParkingGrpcClient grpcClient,
    FirebaseStorage? storage,
  })  : _grpcClient = grpcClient,
        _storage = storage ?? FirebaseStorage.instance;

  /// Upload a list of image files and return their download URLs.
  Future<List<String>> _uploadImages(List<File> files) async {
    final List<String> urls = [];
    for (final file in files) {
      final ref = _storage.ref().child(
          'garage_images/${DateTime.now().millisecondsSinceEpoch}_${file.uri.pathSegments.last}');
      final uploadTask = await ref.putFile(file);
      final url = await uploadTask.ref.getDownloadURL();
      urls.add(url);
    }
    return urls;
  }

  @override
  Future<void> createGarage({
    required String name,
    required double latitude,
    required double longitude,
    required int totalSpots,
    required List<String> imagePaths,
  }) async {
    // Upload images to Firebase Storage
    final files = imagePaths.map((p) => File(p)).toList();
    final imageUrls = await _uploadImages(files);
    final imageUrl = imageUrls.isNotEmpty ? imageUrls.first : '';

    // NOTE: The generated proto does not include a CreateGarage RPC.
    // For now we use getGarage as a placeholder; replace once the
    // backend adds a CreateGarage endpoint.
    // TODO: Replace with actual createGarage RPC when available.
    debugPrint(
        'createGarage placeholder: name=$name, lat=$latitude, lng=$longitude, '
        'spots=$totalSpots, imageUrl=$imageUrl');
  }

  @override
  Future<Garage> getGarage(String garageId) async {
    final pbGarage = await _grpcClient.getGarage(garageId);
    return Garage(
      id: pbGarage.id,
      name: pbGarage.name,
      latitude: pbGarage.latitude,
      longitude: pbGarage.longitude,
      imageUrl: pbGarage.imageUrl,
      totalSpots: pbGarage.totalSpots,
      availableSpots: pbGarage.availableSpots,
    );
  }

  @override
  Future<void> startReservation({
    required String garageId,
    required String userId,
  }) async {
    await _grpcClient.startReservationByIds(
      garageId: garageId,
      userId: userId,
    );
  }

  @override
  Future<void> endReservation({
    required String reservationId,
    required String userId,
  }) async {
    await _grpcClient.endReservation(
      reservationId: reservationId,
      userId: userId,
    );
  }
}

// Helper for debug print (avoids importing foundation in data layer)
void debugPrint(String message) {
  // ignore: avoid_print
  print(message);
}
