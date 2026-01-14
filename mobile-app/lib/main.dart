import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parkingzero/app.dart';
import 'package:parkingzero/core/utils/injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Configura o app para preencher toda a tela (edge-to-edge)
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Color(0x00000000), // Real transparent
      systemNavigationBarDividerColor: Color(0x00000000),
      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarColor: Color(0x00000000),
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  // Inicialização de dependências
  await di.initDependencies();

  runApp(const ParkingZeroApp());
}
