import Flutter
import UIKit
import Firebase
import FirebaseMessaging

@main
@objc class AppDelegate: FlutterAppDelegate, MessagingDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // تهيئة Firebase
    FirebaseApp.configure()

    // تعيين مندوب Messaging
    Messaging.messaging().delegate = self

    // طلب إذن الإشعارات
    if #available(iOS 10.0, *) {
      // تعيين مندوب UNUserNotificationCenter
      UNUserNotificationCenter.current().delegate = self

      let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
      UNUserNotificationCenter.current().requestAuthorization(
        options: authOptions,
        completionHandler: { _, _ in }
      )
    } else {
      let settings: UIUserNotificationSettings =
        UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
      application.registerUserNotificationSettings(settings)
    }

    application.registerForRemoteNotifications()

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // تنفيذ طريقة عرض الإشعارات في المقدمة
  override func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
  ) {
    let userInfo = notification.request.content.userInfo

    // طباعة معلومات الإشعار للتصحيح
    print("Received notification in foreground: \(userInfo)")

    // عرض الإشعار في المقدمة
    if #available(iOS 14.0, *) {
      completionHandler([[.banner, .sound, .badge]])
    } else {
      completionHandler([[.alert, .sound, .badge]])
    }
  }

  // تنفيذ طريقة استلام رمز FCM
  func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
    print("Firebase registration token: \(String(describing: fcmToken))")

    // يمكنك هنا إرسال الرمز إلى خادمك إذا لزم الأمر
  }
}
