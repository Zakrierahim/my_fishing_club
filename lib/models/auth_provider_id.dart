/// Sign-in providers the app can link. WhatsApp is phone verification, not OAuth.
enum AuthProviderId { google, facebook, tiktok, whatsapp }

extension AuthProviderIdLabel on AuthProviderId {
  String get label => switch (this) {
    AuthProviderId.google => 'Google',
    AuthProviderId.facebook => 'Facebook',
    AuthProviderId.tiktok => 'TikTok',
    AuthProviderId.whatsapp => 'WhatsApp',
  };
}
