import 'package:equatable/equatable.dart';

class Settings extends Equatable {
  final String welcomeMessage;
  final String? androidVersion;
  final String? iosVersion;
  final WhatsappSettings whatsappSettings;
  final CompanyProfile companyProfile;

  Settings({
    required this.welcomeMessage,
    this.androidVersion,
    this.iosVersion,
    required this.whatsappSettings,
    required this.companyProfile,
  });

  @override

  List<Object?> get props => [welcomeMessage,androidVersion,iosVersion,whatsappSettings,companyProfile];



}
class WhatsappSettings extends Equatable{
  final bool isWorking;

  WhatsappSettings({required this.isWorking});

  factory WhatsappSettings.fromJson(Map<String, dynamic> json) {
    return WhatsappSettings(
      isWorking: json['isWorking'],
    );
  }

  @override
  List<Object?> get props => [isWorking];
}
class CompanyProfile extends Equatable{
  final String appStorURL;
  final String playStorURL;
  final String facebook;
  final String instegram;
  final String xTwitter;
  final String tiktok;
  final String email;
  final String address;
  final String phone;
  final String whatsapp;

  CompanyProfile({
    required this.appStorURL,
    required this.playStorURL,
    required this.facebook,
    required this.instegram,
    required this.xTwitter,
    required this.tiktok,
    required this.email,
    required this.address,
    required this.phone,
    required this.whatsapp,
  });

  factory CompanyProfile.fromJson(Map<String, dynamic> json) {
    return CompanyProfile(
      appStorURL: json['appStorURL'],
      playStorURL: json['playStorURL'],
      facebook: json['facebook'],
      instegram: json['instegram'],
      xTwitter: json['xTwitter'],
      tiktok: json['tiktok'],
      email: json['email'],
      address: json['address'],
      phone: json['phone'],
      whatsapp: json['whatsapp'],
    );
  }

  @override
  List<Object?> get props => [
    appStorURL,
    playStorURL,
    facebook,
    instegram,
    xTwitter,
    tiktok,
    email,
    address,
    phone,
    whatsapp,
  ];
}

