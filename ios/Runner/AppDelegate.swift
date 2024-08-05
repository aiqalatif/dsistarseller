import UIKit
import Flutter
import Firebase


@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate { //, MessagingDelegate
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
        FirebaseApp.configure()


      GeneratedPluginRegistrant.register(with: self)



    if #available(iOS 10.0, *) {
      // For iOS 10 display notification (sent via APNS)
      UNUserNotificationCenter.current().delegate = self

      let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
      UNUserNotificationCenter.current().requestAuthorization(
        options: authOptions,
        completionHandler: {_, _ in })
    } else {
      let settings: UIUserNotificationSettings =
      UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
      application.registerUserNotificationSettings(settings)
    }


    application.registerForRemoteNotifications()

    Messaging.messaging().token { token, error in
      if let error = error {

      } else if let token = token {

//        self.fcmRegTokenMessage.text  = "Remote FCM registration token: \(token)"
      }
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
