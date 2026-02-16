import 'package:grpc/grpc.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  late ClientChannel channel;

  factory ApiClient() => _instance;

  ApiClient._internal() {
    const baseUrl = '10.0.2.2';
    const port = 8080;

    channel = ClientChannel(
      baseUrl,
      port: port,
      options: const ChannelOptions(credentials: ChannelCredentials.insecure()),
    );
  }

  Future<void> shutdown() async {
    await channel.shutdown();
  }
}
