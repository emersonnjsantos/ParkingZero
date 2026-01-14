import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parkingzero/core/constants/app_constants.dart';
import 'package:parkingzero/core/services/parking_grpc_client.dart';
import 'package:parkingzero/generated/parking_service.pbgrpc.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  bool _isLoading = false;
  bool _useRealData = true; // Toggle entre dados reais e mockados
  List<Garage> _garages = [];

  late ParkingGrpcClient _grpcClient;

  // Ponte da Amizade - Foz do Iguaçu
  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(-25.509583, -54.601111),
    zoom: 15.0,
  );

  @override
  void initState() {
    super.initState();
    _grpcClient = ParkingGrpcClient();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchGarages();
    });
  }

  @override
  void dispose() {
    _grpcClient.close();
    super.dispose();
  }

  Future<void> _searchGarages() async {
    setState(() => _isLoading = true);

    try {
      if (_useRealData) {
        // Chamada gRPC real ao backend
        final garages = await _grpcClient.searchGarages(
          latitude: -25.509583,
          longitude: -54.601111,
          radiusMeters: 5000,
        );
        _garages = garages;
        _createMarkersFromGarages(garages);
      } else {
        // Dados mockados para fallback
        await Future.delayed(const Duration(milliseconds: 500));
        _createMockMarkers();
      }
    } catch (e) {
      print('Erro ao buscar garagens: $e');
      // Fallback para dados mockados em caso de erro
      _createMockMarkers();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Usando dados de demonstração'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }

    setState(() => _isLoading = false);

    // Ajustar câmera para mostrar todos os markers
    if (_mapController != null && _markers.isNotEmpty) {
      final bounds = _calculateBounds(_markers);
      _mapController!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
    }
  }

  void _createMarkersFromGarages(List<Garage> garages) {
    final markers = <Marker>{};

    for (final garage in garages) {
      markers.add(
        Marker(
          markerId: MarkerId(garage.id),
          position: LatLng(garage.latitude, garage.longitude),
          infoWindow: InfoWindow(
            title: garage.name,
            snippet:
                'R\$ ${garage.basePrice.toStringAsFixed(0)}/h • ${garage.availableSpots} vagas',
            onTap: () => _showGarageDetailsReal(garage),
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            garage.availableSpots > 20
                ? BitmapDescriptor.hueGreen
                : garage.availableSpots > 5
                ? BitmapDescriptor.hueOrange
                : BitmapDescriptor.hueRed,
          ),
        ),
      );
    }

    setState(() => _markers = markers);
  }

  void _createMockMarkers() {
    final mockData = [
      {
        'id': '1',
        'name': 'Estacionamento Shopping JL',
        'price': 50.0,
        'partner': 'Loja X',
        'lat': -25.5088,
        'lng': -54.6025,
        'spots': 42,
      },
      {
        'id': '2',
        'name': 'Garage Ponte da Amizade',
        'price': 40.0,
        'partner': 'Perfumaria Y',
        'lat': -25.5078,
        'lng': -54.6038,
        'spots': 15,
      },
      {
        'id': '3',
        'name': 'Parking Ciudad del Este',
        'price': 35.0,
        'partner': 'Casa China Z',
        'lat': -25.5095,
        'lng': -54.6055,
        'spots': 73,
      },
      {
        'id': '4',
        'name': 'EstacionaFácil Centro',
        'price': 45.0,
        'partner': 'Importados W',
        'lat': -25.5102,
        'lng': -54.6012,
        'spots': 8,
      },
      {
        'id': '5',
        'name': 'Park & Shop Duty Free',
        'price': 55.0,
        'partner': 'Duty Free',
        'lat': -25.5070,
        'lng': -54.6045,
        'spots': 25,
      },
    ];

    final markers = <Marker>{};
    for (final g in mockData) {
      markers.add(
        Marker(
          markerId: MarkerId(g['id'] as String),
          position: LatLng(g['lat'] as double, g['lng'] as double),
          infoWindow: InfoWindow(
            title: g['name'] as String,
            snippet:
                'R\$ ${(g['price'] as double).toStringAsFixed(0)}/h • ${g['spots']} vagas',
            onTap: () => _showGarageDetailsMock(g),
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            (g['spots'] as int) > 20
                ? BitmapDescriptor.hueGreen
                : (g['spots'] as int) > 5
                ? BitmapDescriptor.hueOrange
                : BitmapDescriptor.hueRed,
          ),
        ),
      );
    }
    setState(() => _markers = markers);
  }

  LatLngBounds _calculateBounds(Set<Marker> markers) {
    double minLat = 90, maxLat = -90, minLng = 180, maxLng = -180;
    for (final marker in markers) {
      final lat = marker.position.latitude;
      final lng = marker.position.longitude;
      if (lat < minLat) minLat = lat;
      if (lat > maxLat) maxLat = lat;
      if (lng < minLng) minLng = lng;
      if (lng > maxLng) maxLng = lng;
    }
    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

  void _showGarageDetailsReal(Garage garage) {
    final partner = garage.campaigns.isNotEmpty
        ? garage.campaigns.first.partnerName
        : 'Sem parceiro';
    _showBottomSheet(
      name: garage.name,
      price: garage.basePrice,
      spots: garage.availableSpots,
      partner: partner,
      garageId: garage.id,
    );
  }

  void _showGarageDetailsMock(Map<String, dynamic> garage) {
    _showBottomSheet(
      name: garage['name'] as String,
      price: garage['price'] as double,
      spots: garage['spots'] as int,
      partner: garage['partner'] as String,
      garageId: garage['id'] as String,
    );
  }

  void _showBottomSheet({
    required String name,
    required double price,
    required int spots,
    required String partner,
    required String garageId,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withAlpha(25),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.local_parking,
                    color: AppColors.primary,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Parceiro: $partner',
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                _InfoChip(
                  icon: Icons.attach_money,
                  label: 'R\$ ${price.toStringAsFixed(0)}/hora',
                  color: Colors.green,
                ),
                const SizedBox(width: 12),
                _InfoChip(
                  icon: Icons.directions_car,
                  label: '$spots vagas',
                  color: spots > 20 ? Colors.green : Colors.orange,
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Reservar em $name')));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Reservar Vaga',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _initialPosition,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            markers: _markers,
            onMapCreated: (controller) => _mapController = controller,
          ),
          // Header
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(25),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Expanded(
                      child: Text(
                        'Ponte da Amizade',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.filter_list),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Botão de busca
          Positioned(
            bottom: 100,
            left: 16,
            right: 80,
            child: ElevatedButton.icon(
              onPressed: _isLoading ? null : _searchGarages,
              icon: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.search),
              label: Text(_isLoading ? 'Buscando...' : 'Buscar Garagens'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
          // Legenda
          Positioned(
            bottom: 100,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(color: Colors.black.withAlpha(25), blurRadius: 8),
                ],
              ),
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _LegendItem(color: Colors.green, label: '20+'),
                  _LegendItem(color: Colors.orange, label: '5-20'),
                  _LegendItem(color: Colors.red, label: '<5'),
                ],
              ),
            ),
          ),
          // Botão minha localização
          Positioned(
            bottom: 170,
            right: 16,
            child: FloatingActionButton.small(
              onPressed: () => _mapController?.animateCamera(
                CameraUpdate.newCameraPosition(_initialPosition),
              ),
              backgroundColor: Colors.white,
              child: const Icon(Icons.my_location, color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _InfoChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(color: color, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(fontSize: 10)),
        ],
      ),
    );
  }
}
