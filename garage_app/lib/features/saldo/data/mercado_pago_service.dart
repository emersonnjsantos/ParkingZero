import 'package:dio/dio.dart';

/// Serviço de integração com o Mercado Pago (Front-End Flutter)
/// Projetado para inicialização direta com credenciais reais de teste
/// e comunicação transparente com o Backend de Pagamentos.
class MercadoPagoService {
  final Dio _dio = Dio();

  // Credenciais de Teste Ativas
  static const String publicKey = "TEST-02e6d206-8cc9-4061-bf9f-4f145ea3ec9b";
  
  // URL base do Backend de Pagamentos (Porta 8085)
  // Nota: Usa 10.0.2.2 para emuladores Android ou localhost para iOS/Web
  static const String backendUrl = "http://10.0.2.2:8085/api/payments";

  /// 1. Geração do Token de Cartão via REST API do Mercado Pago
  /// Envia com segurança os dados do cartão de crédito para obter um token de uso único.
  Future<String> generateCardToken({
    required String cardNumber,
    required String cardholderName,
    required String expirationMonth,
    required String expirationYear,
    required String securityCode,
  }) async {
    // Normalizar número do cartão tirando todos os espaços
    final cleanCardNumber = cardNumber.replaceAll(RegExp(r'\s+'), '');
    final cleanMonth = int.tryParse(expirationMonth.trim()) ?? 12;
    // Garantir formato de ano completo (ex: 26 -> 2026)
    var cleanYear = int.tryParse(expirationYear.trim()) ?? 2026;
    if (cleanYear < 100) {
      cleanYear += 2000;
    }

    try {
      final response = await _dio.post(
        "https://api.mercadopago.com/v1/card_tokens",
        queryParameters: {
          "public_key": publicKey,
        },
        data: {
          "card_number": cleanCardNumber,
          "expiration_month": cleanMonth,
          "expiration_year": cleanYear,
          "security_code": securityCode.trim(),
          "cardholder": {
            "name": cardholderName.trim(),
            "identification": {
              "type": "CPF",
              "number": "12345678909", // CPF de teste padrão
            }
          }
        },
        options: Options(
          headers: {
            "Content-Type": "application/json",
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final token = response.data["id"] as String;
        return token;
      } else {
        throw Exception("Erro ao tokenizar cartão: ${response.statusMessage}");
      }
    } on DioException catch (e) {
      final errorMsg = e.response?.data?["message"] ?? e.message;
      throw Exception("Falha de comunicação com Mercado Pago: $errorMsg");
    }
  }

  /// 2. Envio de Transação com Cartão para o Backend
  Future<Map<String, dynamic>> processCardPayment({
    required String token,
    required double amount,
    required String payerEmail,
  }) async {
    try {
      final response = await _dio.post(
        "$backendUrl/card",
        data: {
          "token": token,
          "transaction_amount": amount,
          "installments": 1,
          "payment_method_id": "master", // Mastercard de teste
          "payer": {
            "email": payerEmail.trim(),
          }
        },
      );

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        throw Exception("Backend retornou erro: ${response.statusMessage}");
      }
    } on DioException catch (e) {
      final errorMsg = e.response?.data?["error"] ?? e.message;
      throw Exception("Erro no processamento do cartão: $errorMsg");
    }
  }

  /// 3. Envio de Solicitação de Pagamento via PIX para o Backend
  /// Retorna os dados do Pix Copia e Cola ("qr_code") e a imagem Base64 ("qr_code_base64")
  Future<Map<String, dynamic>> processPixPayment({
    required double amount,
    required String description,
    required String payerEmail,
    required String payerFirstName,
    required String payerLastName,
    required String payerCpf,
  }) async {
    try {
      final response = await _dio.post(
        "$backendUrl/pix",
        data: {
          "transaction_amount": amount,
          "description": description,
          "payer": {
            "email": payerEmail.trim(),
            "first_name": payerFirstName.trim(),
            "last_name": payerLastName.trim(),
            "identification": {
              "type": "CPF",
              "number": payerCpf.replaceAll(RegExp(r'[^\d]'), ''),
            }
          }
        },
      );

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        throw Exception("Backend retornou erro: ${response.statusMessage}");
      }
    } on DioException catch (e) {
      final errorMsg = e.response?.data?["error"] ?? e.message;
      throw Exception("Erro no processamento do Pix: $errorMsg");
    }
  }
}
