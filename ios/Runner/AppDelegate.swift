import UIKit
import Flutter
import GoogleMaps
import Firebase
@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("AIzaSyA1KtxwtlbII8TlJ6Wa2UkbuoNAqgXTf8A")
    GeneratedPluginRegistrant.register(with: self)

    return true
//    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
