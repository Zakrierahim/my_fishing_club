import 'auth_provider_id.dart';

/// A provider identity confirmed by the authentication service.
///
/// [connected] is true only when the service confirmed the link and returned
/// the provider subject. A local flag is not enough.
class LinkedAccount {
  const LinkedAccount({
    required this.provider,
    required this.confirmedByService,
    this.providerSubject,
  });

  const LinkedAccount.disconnected(this.provider)
    : confirmedByService = false,
      providerSubject = null;

  final AuthProviderId provider;
  final bool confirmedByService;
  final String? providerSubject;

  bool get connected {
    final subject = providerSubject?.trim();
    return confirmedByService && subject != null && subject.isNotEmpty;
  }
}
