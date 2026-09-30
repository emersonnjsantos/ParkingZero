import 'package:flutter/material.dart';
import 'package:parking_app/core/theme/app_theme.dart';

class VehicleControlScreen extends StatefulWidget {
  const VehicleControlScreen({super.key});

  @override
  State<VehicleControlScreen> createState() => _VehicleControlScreenState();
}

class _VehicleControlScreenState extends State<VehicleControlScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _plateController = TextEditingController();
  bool _isProcessing = false;

  // Mock active vehicles
  final _activeVehicles = [
    _Vehicle(
      plate: 'ABC-1234',
      entryTime: '08:32',
      spot: 'A-12',
      duration: '6h 02min',
    ),
    _Vehicle(
      plate: 'XYZ-5678',
      entryTime: '10:15',
      spot: 'B-08',
      duration: '4h 19min',
    ),
    _Vehicle(
      plate: 'DEF-9012',
      entryTime: '11:48',
      spot: 'C-03',
      duration: '2h 46min',
    ),
    _Vehicle(
      plate: 'GHI-3456',
      entryTime: '13:22',
      spot: 'A-07',
      duration: '1h 12min',
    ),
    _Vehicle(
      plate: 'JKL-7890',
      entryTime: '14:02',
      spot: 'B-15',
      duration: '0h 32min',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _plateController.dispose();
    super.dispose();
  }

  void _handleEntry() {
    if (_plateController.text.isEmpty) return;
    setState(() => _isProcessing = true);

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() => _isProcessing = false);
        _showResult(
          icon: Icons.login_rounded,
          color: ParkingTheme.success,
          title: 'Entrada registrada!',
          subtitle:
              'Placa: ${_plateController.text.toUpperCase()}\nVaga: A-${DateTime.now().second}',
        );
        _plateController.clear();
      }
    });
  }

  void _handleExit(String plate) {
    setState(() => _isProcessing = true);

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() => _isProcessing = false);
        _showResult(
          icon: Icons.logout_rounded,
          color: ParkingTheme.accent,
          title: 'Saída registrada!',
          subtitle: 'Placa: $plate\nValor: R\$ 25,00',
        );
      }
    });
  }

  void _showResult({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: ParkingTheme.surfaceCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 36, color: color),
            ),
            const SizedBox(height: 20),
            Text(title, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: ParkingTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
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
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(
                children: [
                  Text(
                    'Controle de Veículos',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Tabs
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: ParkingTheme.surfaceCard,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: ParkingTheme.border, width: 0.5),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: ParkingTheme.accent,
                  borderRadius: BorderRadius.circular(10),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: ParkingTheme.primaryDeep,
                unselectedLabelColor: ParkingTheme.textSecondary,
                dividerHeight: 0,
                tabs: const [
                  Tab(text: 'Registrar Entrada'),
                  Tab(text: 'Veículos Ativos'),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Tab content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // === Tab 1: Registrar Entrada ===
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        // Quick entry card
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            gradient: ParkingTheme.headerGradient,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            children: [
                              const Icon(
                                Icons.directions_car_rounded,
                                size: 48,
                                color: ParkingTheme.accent,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Registrar entrada de veículo',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 20),
                              TextField(
                                controller: _plateController,
                                textCapitalization:
                                    TextCapitalization.characters,
                                style: Theme.of(context).textTheme.headlineSmall
                                    ?.copyWith(
                                      letterSpacing: 2,
                                      fontWeight: FontWeight.w700,
                                    ),
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  hintText: 'ABC-1234',
                                  hintStyle: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                        color: ParkingTheme.textMuted,
                                        letterSpacing: 2,
                                      ),
                                  filled: true,
                                  fillColor: ParkingTheme.primaryDeep
                                      .withValues(alpha: 0.5),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: const BorderSide(
                                      color: ParkingTheme.border,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: const BorderSide(
                                      color: ParkingTheme.border,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: const BorderSide(
                                      color: ParkingTheme.accent,
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                width: double.infinity,
                                height: 52,
                                child: ElevatedButton.icon(
                                  onPressed: _isProcessing
                                      ? null
                                      : _handleEntry,
                                  icon: _isProcessing
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: ParkingTheme.primaryDeep,
                                          ),
                                        )
                                      : const Icon(Icons.login_rounded),
                                  label: Text(
                                    _isProcessing
                                        ? 'Registrando...'
                                        : 'Registrar Entrada',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Quick stats
                        Row(
                          children: [
                            _QuickStat(
                              label: 'Vagas livres',
                              value: '18',
                              color: ParkingTheme.success,
                            ),
                            const SizedBox(width: 12),
                            _QuickStat(
                              label: 'Ocupadas',
                              value: '32',
                              color: ParkingTheme.warning,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // === Tab 2: Veículos Ativos ===
                  ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: _activeVehicles.length,
                    itemBuilder: (context, index) {
                      final v = _activeVehicles[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: ParkingTheme.surfaceCard,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: ParkingTheme.border,
                            width: 0.5,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: ParkingTheme.info.withValues(
                                  alpha: 0.12,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.directions_car_rounded,
                                color: ParkingTheme.info,
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    v.plate,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(
                                          color: ParkingTheme.textPrimary,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 1,
                                        ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Vaga ${v.spot} • Entrada ${v.entryTime} • ${v.duration}',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                            OutlinedButton(
                              onPressed: () => _handleExit(v.plate),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                side: const BorderSide(
                                  color: ParkingTheme.accent,
                                ),
                              ),
                              child: const Text(
                                'Saída',
                                style: TextStyle(fontSize: 13),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _QuickStat({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: ParkingTheme.surfaceCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: ParkingTheme.border, width: 0.5),
        ),
        child: Row(
          children: [
            Container(
              width: 8,
              height: 36,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(label, style: Theme.of(context).textTheme.labelMedium),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Vehicle {
  final String plate;
  final String entryTime;
  final String spot;
  final String duration;

  _Vehicle({
    required this.plate,
    required this.entryTime,
    required this.spot,
    required this.duration,
  });
}
