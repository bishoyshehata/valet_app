import 'package:valet_app/valete/domain/entities/settings.dart';

class SettingsModel extends Settings {
  SettingsModel({
    required super.welcomeMessage,
    super.androidVersion,
    super.iosVersion,
    required super.whatsappSettings,
    required super.companyProfile,
  });

  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(
      welcomeMessage: json['welcomeMessage'],
      androidVersion: json['androidVersion'],
      iosVersion: json['iosVersion'],
      whatsappSettings: WhatsappSettings.fromJson(json['whatsappSettings']),
      companyProfile: CompanyProfile.fromJson(json['companyProfile']),
    );
  }
}
