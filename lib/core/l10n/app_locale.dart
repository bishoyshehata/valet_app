import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_locale_ar.dart';
import 'app_locale_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_locale.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @reachOurGarage.
  ///
  /// In ar, this message translates to:
  /// **'إوصل لأقرب جراج تبعنا'**
  String get reachOurGarage;

  /// No description provided for @alignTheQrCodeWithinTheFrame.
  ///
  /// In ar, this message translates to:
  /// **'ضع ال QR داخل الإطار المحدد'**
  String get alignTheQrCodeWithinTheFrame;

  /// No description provided for @login.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الدخول'**
  String get login;

  /// No description provided for @appName.
  ///
  /// In ar, this message translates to:
  /// **'Valet'**
  String get appName;

  /// No description provided for @appProposal.
  ///
  /// In ar, this message translates to:
  /// **'العثور على مكان لوقوف السيارات دون أي متاعب'**
  String get appProposal;

  /// No description provided for @enterPassword.
  ///
  /// In ar, this message translates to:
  /// **'أدخل كلمة السر'**
  String get enterPassword;

  /// No description provided for @enterPhone.
  ///
  /// In ar, this message translates to:
  /// **'أدخل رقم هاتفك'**
  String get enterPhone;

  /// No description provided for @welcome.
  ///
  /// In ar, this message translates to:
  /// **'أهلاً بك يا '**
  String get welcome;

  /// No description provided for @makeOrder.
  ///
  /// In ar, this message translates to:
  /// **'إنشاء طلب جديد'**
  String get makeOrder;

  /// No description provided for @garages.
  ///
  /// In ar, this message translates to:
  /// **'الجراجات'**
  String get garages;

  /// No description provided for @orders.
  ///
  /// In ar, this message translates to:
  /// **'الطلبات'**
  String get orders;

  /// No description provided for @profile.
  ///
  /// In ar, this message translates to:
  /// **'شخصي'**
  String get profile;

  /// No description provided for @theProfile.
  ///
  /// In ar, this message translates to:
  /// **'الملف الشخصي'**
  String get theProfile;

  /// No description provided for @theGarage.
  ///
  /// In ar, this message translates to:
  /// **'الجراج'**
  String get theGarage;

  /// No description provided for @addOrder.
  ///
  /// In ar, this message translates to:
  /// **'إضافة طلب'**
  String get addOrder;

  /// No description provided for @unDefined.
  ///
  /// In ar, this message translates to:
  /// **'غير محدد'**
  String get unDefined;

  /// No description provided for @total.
  ///
  /// In ar, this message translates to:
  /// **'الإجمالي: '**
  String get total;

  /// No description provided for @theBusy.
  ///
  /// In ar, this message translates to:
  /// **'المشغول: '**
  String get theBusy;

  /// No description provided for @theAvailable.
  ///
  /// In ar, this message translates to:
  /// **'المتاح: '**
  String get theAvailable;

  /// No description provided for @termsAndConditions.
  ///
  /// In ar, this message translates to:
  /// **'الشروط والأحكام'**
  String get termsAndConditions;

  /// No description provided for @errorLoadingTermsAndConditions.
  ///
  /// In ar, this message translates to:
  /// **'حدث خطأ أثناء تحميل الشروط والأحكام'**
  String get errorLoadingTermsAndConditions;

  /// No description provided for @errorHappened.
  ///
  /// In ar, this message translates to:
  /// **'حدث خطأ'**
  String get errorHappened;

  /// No description provided for @status.
  ///
  /// In ar, this message translates to:
  /// **'الحالة : '**
  String get status;

  /// No description provided for @save.
  ///
  /// In ar, this message translates to:
  /// **'حفظ'**
  String get save;

  /// No description provided for @deleteAccount.
  ///
  /// In ar, this message translates to:
  /// **'حذف الحساب'**
  String get deleteAccount;

  /// No description provided for @warning.
  ///
  /// In ar, this message translates to:
  /// **'تنبيه !'**
  String get warning;

  /// No description provided for @areyouSureYouWantToDeleteYourAccount.
  ///
  /// In ar, this message translates to:
  /// **'سيتم حذف الحساب تلقائيًا إذا لم يتم تسجيل الدخول من جانبك لمدة 15 يومًا متتاليًا.'**
  String get areyouSureYouWantToDeleteYourAccount;

  /// No description provided for @yes.
  ///
  /// In ar, this message translates to:
  /// **'نعم'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In ar, this message translates to:
  /// **'لا'**
  String get no;

  /// No description provided for @logOut.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الخروج'**
  String get logOut;

  /// No description provided for @areYouSureYouWantToLogOut.
  ///
  /// In ar, this message translates to:
  /// **'هل أنت متأكد من تسجيل الخروج ؟'**
  String get areYouSureYouWantToLogOut;

  /// No description provided for @statusWaiting.
  ///
  /// In ar, this message translates to:
  /// **'في الإنتظار'**
  String get statusWaiting;

  /// No description provided for @statusRequested.
  ///
  /// In ar, this message translates to:
  /// **'مطلوب'**
  String get statusRequested;

  /// No description provided for @statusOnTheWay.
  ///
  /// In ar, this message translates to:
  /// **'في الطريق'**
  String get statusOnTheWay;

  /// No description provided for @statusArrived.
  ///
  /// In ar, this message translates to:
  /// **'وصل'**
  String get statusArrived;

  /// No description provided for @statusDelivered.
  ///
  /// In ar, this message translates to:
  /// **'تم التسليم'**
  String get statusDelivered;

  /// No description provided for @ordersManagement.
  ///
  /// In ar, this message translates to:
  /// **'إدارة الطلبات'**
  String get ordersManagement;

  /// No description provided for @noOrders.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد طلبات'**
  String get noOrders;

  /// No description provided for @customerPhone.
  ///
  /// In ar, this message translates to:
  /// **'هاتف العميل : '**
  String get customerPhone;

  /// No description provided for @hiddenData.
  ///
  /// In ar, this message translates to:
  /// **'########'**
  String get hiddenData;

  /// No description provided for @garageLabel.
  ///
  /// In ar, this message translates to:
  /// **'الجراج :'**
  String get garageLabel;

  /// No description provided for @spotLabel.
  ///
  /// In ar, this message translates to:
  /// **'الباكية :'**
  String get spotLabel;

  /// No description provided for @sinceLabel.
  ///
  /// In ar, this message translates to:
  /// **'منذ :'**
  String get sinceLabel;

  /// No description provided for @pending.
  ///
  /// In ar, this message translates to:
  /// **'منتظر'**
  String get pending;

  /// No description provided for @requested.
  ///
  /// In ar, this message translates to:
  /// **'مطلوب الآن'**
  String get requested;

  /// No description provided for @onTheWay.
  ///
  /// In ar, this message translates to:
  /// **'في الطريق'**
  String get onTheWay;

  /// No description provided for @arrived.
  ///
  /// In ar, this message translates to:
  /// **'وصل'**
  String get arrived;

  /// No description provided for @unknown.
  ///
  /// In ar, this message translates to:
  /// **'غير معروف'**
  String get unknown;

  /// No description provided for @deliverTheVehicle.
  ///
  /// In ar, this message translates to:
  /// **'توصيل المركبة'**
  String get deliverTheVehicle;

  /// No description provided for @iAmOnMyWay.
  ///
  /// In ar, this message translates to:
  /// **'أنا في طريقي'**
  String get iAmOnMyWay;

  /// No description provided for @iHaveArrived.
  ///
  /// In ar, this message translates to:
  /// **'لقد وصلت'**
  String get iHaveArrived;

  /// No description provided for @delivered.
  ///
  /// In ar, this message translates to:
  /// **'تم التسليم'**
  String get delivered;

  /// No description provided for @areYouSureYouWantToCancelOrder.
  ///
  /// In ar, this message translates to:
  /// **'هل أنت متأكد من إلغاء الطلب ؟'**
  String get areYouSureYouWantToCancelOrder;

  /// No description provided for @invalidDate.
  ///
  /// In ar, this message translates to:
  /// **'تاريخ غير صالح'**
  String get invalidDate;

  /// No description provided for @contactAdminError.
  ///
  /// In ar, this message translates to:
  /// **'حدثت مشكلة تواصل مع المدير'**
  String get contactAdminError;

  /// No description provided for @connectionError.
  ///
  /// In ar, this message translates to:
  /// **'حدث خطأ في الاتصال:'**
  String get connectionError;

  /// No description provided for @createNewOrder.
  ///
  /// In ar, this message translates to:
  /// **'إنشاء طلب جديد'**
  String get createNewOrder;

  /// No description provided for @orderCreatedSuccessfullyViaWhatsApp.
  ///
  /// In ar, this message translates to:
  /// **'تم إنشاء الطلب بنجاح عبر WhatsApp'**
  String get orderCreatedSuccessfullyViaWhatsApp;

  /// No description provided for @orderCreatedSuccessfully.
  ///
  /// In ar, this message translates to:
  /// **'تم إنشاء الطلب بنجاح'**
  String get orderCreatedSuccessfully;

  /// No description provided for @failedToCreateOrderViaWhatsApp.
  ///
  /// In ar, this message translates to:
  /// **'فشل في إنشاء الطلب عبر WhatsApp: '**
  String get failedToCreateOrderViaWhatsApp;

  /// No description provided for @failedToCreateOrder.
  ///
  /// In ar, this message translates to:
  /// **'فشل في إنشاء الطلب: '**
  String get failedToCreateOrder;

  /// No description provided for @pleaseAskCustomerToScanQR.
  ///
  /// In ar, this message translates to:
  /// **'برجاء الطلب من العميل عمل مسح للـ QR.'**
  String get pleaseAskCustomerToScanQR;

  /// No description provided for @pleaseEnterCustomerNumber.
  ///
  /// In ar, this message translates to:
  /// **'برجاء إدخال رقم العميل.'**
  String get pleaseEnterCustomerNumber;

  /// No description provided for @sorryInvalidData.
  ///
  /// In ar, this message translates to:
  /// **'نأسف و لكن يوجد خطأ بالبيانات.'**
  String get sorryInvalidData;

  /// No description provided for @confirmOrder.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد الطلب'**
  String get confirmOrder;

  /// No description provided for @goToGarage.
  ///
  /// In ar, this message translates to:
  /// **'التوجه إلى جراج :'**
  String get goToGarage;

  /// No description provided for @garageFull.
  ///
  /// In ar, this message translates to:
  /// **'الجراج ممتلئ'**
  String get garageFull;

  /// No description provided for @chooseSpot.
  ///
  /// In ar, this message translates to:
  /// **'اختر باكية'**
  String get chooseSpot;

  /// No description provided for @selectVehicleType.
  ///
  /// In ar, this message translates to:
  /// **'قم بإختيار نوع المركبة'**
  String get selectVehicleType;

  /// No description provided for @addCustomerPhone.
  ///
  /// In ar, this message translates to:
  /// **'قم بإضافة هاتف العميل'**
  String get addCustomerPhone;

  /// No description provided for @scanQR.
  ///
  /// In ar, this message translates to:
  /// **'قم بمسح ال QR'**
  String get scanQR;

  /// No description provided for @captureVehicleImage.
  ///
  /// In ar, this message translates to:
  /// **'قم بإلتقاط صورة للمركبة'**
  String get captureVehicleImage;

  /// No description provided for @noCode.
  ///
  /// In ar, this message translates to:
  /// **'لا يوجد كود'**
  String get noCode;

  /// No description provided for @errorOccurred.
  ///
  /// In ar, this message translates to:
  /// **'حدث خطأ'**
  String get errorOccurred;

  /// No description provided for @deliverVehicle.
  ///
  /// In ar, this message translates to:
  /// **'توصيل المركبة'**
  String get deliverVehicle;

  /// No description provided for @confirmEdit.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد التعديل'**
  String get confirmEdit;

  /// No description provided for @enterPhoneNumber.
  ///
  /// In ar, this message translates to:
  /// **'إدخل رقم الهاتف'**
  String get enterPhoneNumber;

  /// No description provided for @password.
  ///
  /// In ar, this message translates to:
  /// **'كلمة المرور'**
  String get password;

  /// No description provided for @shortPassword.
  ///
  /// In ar, this message translates to:
  /// **'كلمة السر قصيرة'**
  String get shortPassword;

  /// No description provided for @garageDataUnavailable.
  ///
  /// In ar, this message translates to:
  /// **'بيانات الجراج غير متاحة'**
  String get garageDataUnavailable;

  /// No description provided for @hideAdditionalSpots.
  ///
  /// In ar, this message translates to:
  /// **'إخفاء الأماكن الإضافية'**
  String get hideAdditionalSpots;

  /// No description provided for @showAdditionalSpots.
  ///
  /// In ar, this message translates to:
  /// **'عرض الأماكن الإضافية'**
  String get showAdditionalSpots;

  /// No description provided for @mainGarage.
  ///
  /// In ar, this message translates to:
  /// **'الجراج الرئيسي'**
  String get mainGarage;

  /// No description provided for @noCarsInGarage.
  ///
  /// In ar, this message translates to:
  /// **'عذراً لا يوجد سيارات بهذا الجراج'**
  String get noCarsInGarage;

  /// No description provided for @reRegister.
  ///
  /// In ar, this message translates to:
  /// **'إعادة التسجيل'**
  String get reRegister;

  /// No description provided for @unexpectedErrorOccurred.
  ///
  /// In ar, this message translates to:
  /// **'حدث خطأ غير متوقع'**
  String get unexpectedErrorOccurred;

  /// No description provided for @changeLanguage.
  ///
  /// In ar, this message translates to:
  /// **'اللغة'**
  String get changeLanguage;

  /// No description provided for @active.
  ///
  /// In ar, this message translates to:
  /// **'متاح'**
  String get active;

  /// No description provided for @disActive.
  ///
  /// In ar, this message translates to:
  /// **'غير متاح'**
  String get disActive;

  /// No description provided for @busy.
  ///
  /// In ar, this message translates to:
  /// **'مشغول'**
  String get busy;

  /// No description provided for @clientNumber.
  ///
  /// In ar, this message translates to:
  /// **'رقم هاتف العميل'**
  String get clientNumber;

  /// No description provided for @usingWhatsApp.
  ///
  /// In ar, this message translates to:
  /// **'إستخدام واتساب'**
  String get usingWhatsApp;

  /// No description provided for @sorryThisCarBelongsToAnotherValet.
  ///
  /// In ar, this message translates to:
  /// **'نأسف و لكن هذه السيارة تخص فاليه أخر ٫'**
  String get sorryThisCarBelongsToAnotherValet;

  /// No description provided for @pleaseUpdatedLatestVersion.
  ///
  /// In ar, this message translates to:
  /// **'من فضلك قم بالتحديث لأخر إصدار٫'**
  String get pleaseUpdatedLatestVersion;

  /// No description provided for @goToGooglePlay.
  ///
  /// In ar, this message translates to:
  /// **'الذهاب إلى المتجر'**
  String get goToGooglePlay;

  /// No description provided for @goToAppStore.
  ///
  /// In ar, this message translates to:
  /// **'الذهاب إلى المتجر'**
  String get goToAppStore;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
