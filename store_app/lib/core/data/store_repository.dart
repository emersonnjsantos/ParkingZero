import 'package:grpc/grpc.dart';
import 'package:store_app/core/api/api_client.dart';
import 'package:store_app/core/auth/auth_service.dart';
import 'package:store_app/generated/payment/payment_service.pbgrpc.dart';
import 'package:store_app/generated/dashboard/dashboard_service.pbgrpc.dart';

/// Repository that wraps gRPC service clients for the store app.
/// Handles auth token injection and error translation.
class StoreRepository {
  final ApiClient _apiClient;
  final AuthService _authService;

  late final PaymentServiceClient _paymentClient;
  late final DashboardServiceClient _dashboardClient;

  StoreRepository(this._apiClient, this._authService) {
    _paymentClient = PaymentServiceClient(_apiClient.channel);
    _dashboardClient = DashboardServiceClient(_apiClient.channel);
  }

  /// Get authenticated CallOptions with Bearer token
  Future<CallOptions> get _authOptions => _authService.getAuthCallOptions();

  // ─── Dashboard ─────────────────────────────────────────────

  /// Fetch sponsorship summary for this store's dashboard
  Future<StoreSponsorshipSummary> getStoreSummary(String storeId) async {
    final options = await _authOptions;
    return _dashboardClient.getStoreSponsorshipSummary(
      GetStoreSummaryRequest(storeId: storeId),
      options: options,
    );
  }

  // ─── Sponsorship ───────────────────────────────────────────

  /// Request a sponsorship for a customer's parking
  Future<SponsorshipResponse> requestSponsorship({
    required String storeId,
    required String reservationId,
    required double invoiceAmount,
    required String invoiceId,
    required String storeName,
    double? amountToSponsor,
  }) async {
    final options = await _authOptions;
    return _paymentClient.requestSponsorship(
      SponsorshipRequest(
        storeId: storeId,
        reservationId: reservationId,
        invoice: InvoiceInfo(
          invoiceId: invoiceId,
          amountUsd: invoiceAmount,
          storeName: storeName,
        ),
        amountToSponsor: amountToSponsor ?? 0,
      ),
      options: options,
    );
  }

  // ─── Voucher History (Ledger) ──────────────────────────────

  /// Fetch sponsorship ledger entries for a reservation
  Future<SponsorshipLedgerResponse> getSponsorshipLedger(
    String reservationId,
  ) async {
    final options = await _authOptions;
    return _paymentClient.getSponsorshipLedger(
      GetSponsorshipLedgerRequest(reservationId: reservationId),
      options: options,
    );
  }

  /// Check a specific voucher status
  Future<VoucherStatus> getVoucherStatus(String reservationId) async {
    final options = await _authOptions;
    return _paymentClient.getVoucherStatus(
      GetVoucherStatusRequest(reservationId: reservationId),
      options: options,
    );
  }
}
