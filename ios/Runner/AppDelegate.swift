import Flutter
import UIKit
import UserNotifications

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  private var permissionResult: FlutterResult?
  
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)

        let controller = window?.rootViewController as! FlutterViewController
        let channel = FlutterMethodChannel(name: "plan_manager/permissions",
                                           binaryMessenger: controller.binaryMessenger)

        channel.setMethodCallHandler { [weak self] (call, result) in
            switch call.method {
            case "checkNotificationPermission":
                self?.checkNotificationPermission(result: result)
            case "requestNotificationPermission":
                self?.requestNotificationPermission(result: result)
            default:
                result(FlutterMethodNotImplemented)
            }
        }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

      private func checkNotificationPermission(result: @escaping FlutterResult) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            let authorized = settings.authorizationStatus == .authorized
            DispatchQueue.main.async {
                result(authorized)
            }
        }
    }

    private func requestNotificationPermission(result: @escaping FlutterResult) {
        permissionResult = result
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.permissionResult?(FlutterError(code: "PERMISSION_ERROR",
                                                         message: error.localizedDescription,
                                                         details: nil))
                } else {
                    self.permissionResult?(granted)
                }
                self.permissionResult = nil
            }
        }
    }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
  }
}
