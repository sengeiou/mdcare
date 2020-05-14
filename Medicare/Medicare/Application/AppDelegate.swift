//
//  AppDelegate.swift
//  Medicare
//
//  Created by sanghv on 4/10/19.
//

import UIKit
import IQKeyboardManagerSwift
import Firebase
import DropDown
// import OneSignal
import UXCam
import NCMB
import UserNotifications
import Kingfisher

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var openFromPush = false

    private var backgroundTask: UIBackgroundTaskIdentifier = UIBackgroundTaskIdentifier.invalid

    private var configuration = Configuration.shared

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // Check app open from push notification
        if launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification] != nil {
            openFromPush = true
        }

        // Override point for customization after application launch.
        configFirebase()
        configKingfisherManager()
        // configOneSignal(launchOptions: launchOptions)
        configGlobalContext()

        customizeUIAppearance()

        UXCam.optIntoSchematicRecordings()
        UXCam.start(withKey: "5r2l97xyvexskvn")

        NCMB.initialize(applicationKey: Configuration.shared.environment.pushApplicationKey,
                        clientKey: Configuration.shared.environment.pushClientKey)
        registerForPushNotifications()

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {

    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        reinstateBackgroundTask()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        endBackgroundTask()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        application.applicationIconBadgeNumber = 0
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

extension AppDelegate {

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
//        let token = tokenParts.joined()
        prefs?.updateDeviceToken(token: deviceToken)
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler:
        @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler:
        @escaping () -> Void) {
        openNotificationList()
    }
}

extension AppDelegate {

    private func registerForPushNotifications() {
        let userNotification = UNUserNotificationCenter.current()
        userNotification.delegate = self
        userNotification.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            print("Permission granted: \(granted)")
            if error == nil {
                DispatchQueue.main.async {
                  UIApplication.shared.registerForRemoteNotifications()
                }
            }
          }
    }

    private func configFirebase() {
        if let options = FirebaseOptions(contentsOfFile: configuration.environment.googleServicePath) {
            FirebaseApp.configure(options: options)
        } else {
            FirebaseApp.configure()
        }
    }

    /*
    private func configOneSignal(launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        //START OneSignal initialization code
        let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false]

        // Replace 'YOUR_APP_ID' with your OneSignal App ID.
        OneSignal.initWithLaunchOptions(launchOptions,
                                        appId: configuration.environment.oneSignalAppId,
                                        handleNotificationAction: nil,
                                        settings: onesignalInitSettings)

        OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification

        // Recommend moving the below line to prompt for push after informing the user about
        //   how your app will use them.
        OneSignal.promptForPushNotifications(userResponse: { accepted in
            print("User accepted notifications: \(accepted)")
        })
        //END OneSignal initializataion code
    }
    */

    private func configGlobalContext() {
        // Subscribe app loading
        _ = GlobalContext.appLoadOb.subscribe(onNext: { _ in

        })
    }

    private func configKingfisherManager() {
        let modifier = AnyModifier { request in
            var r = request
            r.setValue(basicAuthorization, forHTTPHeaderField: "Authorization")

            return r
        }

        KingfisherManager.shared.defaultOptions = [.requestModifier(modifier)]
    }
}

// MARK: - Customize UI appearance

extension AppDelegate {

    private func customizeUIAppearance() {
        #if compiler(>=5.1)
        if #available(iOS 13.0, *) {
            // Always adopt a light interface style.
            window?.overrideUserInterfaceStyle = .light
        }
        #endif

        window?.backgroundColor = ColorName.cF9F9F9.color

        // IQKeyboardManager config
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.disabledToolbarClasses = []
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.disabledTouchResignedClasses = []
        IQKeyboardManager.shared.shouldShowToolbarPlaceholder = false
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reloadLocalizedViews),
                                               name: NSNotification.Name(LCLLanguageChangeNotification),
                                               object: nil)
        reloadLocalizedViews()

        UINavigationBar.appearance().isTranslucent = true
//        UINavigationBar.appearance().setBackgroundImage(UIImage(color: ColorName.cF9F9F9.color), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.medium(size: 18),
            NSAttributedString.Key.foregroundColor: ColorName.c333333.color
        ]

        UITabBar.appearance().isTranslucent = true
        UITabBar.appearance().backgroundImage = UIImage(color: ColorName.c333333.color)

        UITableViewCell.appearance().backgroundColor = .clear

        _ = MZFormSheetPresentationController.appearance().then {
            $0.shouldCenterVertically = true
            $0.shouldDismissOnBackgroundViewTap = false
        }

        DropDown.startListeningToKeyboard()

        SVProgressHUD.setDefaultMaskType(.clear)
        SVProgressHUD.setForegroundColor(ColorName.c333333.color)
        SVProgressHUD.setBackgroundColor(.clear)
        SVProgressHUD.setMaximumDismissTimeInterval(NumberConstant.hudMaximumDismissTimeInterval)
        // observeNetworkOfflineState()

        if let didSetLanguageManually = prefs?.didSetLanguageManually, !didSetLanguageManually {
            Localize.setCurrentLanguage(LanguageCode.vi.rawValue)
        }

        updateAlwaysOnOption()
    }

    func updateAlwaysOnOption() {
        UIApplication.shared.isIdleTimerDisabled = FileManagerHelper.shared.getConfig().isAlwaysOn
    }

    @objc private func reloadLocalizedViews() {
        IQKeyboardManager.shared.toolbarDoneBarButtonItemText = R.string.localization.buttonDoneTitle.localized()
    }

    /*
    func observeNetworkOfflineState() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleNetworkOffline(_:)), name: NSNotification.Name(StringConstant.networkOfflineNotification), object: nil)
    }

    @objc func handleNetworkOffline(_ notification: Notification) {
        showError(withStatus: R.string.localization.networkErrorLostInternet.localized())
    }
    */
}

// MARK: - Register background task

extension AppDelegate {

    private func reinstateBackgroundTask() {
        if backgroundTask == UIBackgroundTaskIdentifier.invalid {
            registerBackgroundTask()
        }
    }

    private func registerBackgroundTask() {
        backgroundTask = UIApplication.shared.beginBackgroundTask(expirationHandler: {
            [unowned self] in
            self.endBackgroundTask()
        })
        assert(backgroundTask != UIBackgroundTaskIdentifier.invalid)
    }

    private func endBackgroundTask() {
        UIApplication.shared.endBackgroundTask(backgroundTask)
        backgroundTask = UIBackgroundTaskIdentifier.invalid
    }
}

extension AppDelegate {

    private func openNotificationList() {
        let rootViewController = UIApplication.shared.keyWindow?.rootViewController
        if let tabBarController = rootViewController as? TabBarController {
            tabBarController.openNotificationList()
        }
    }
}
