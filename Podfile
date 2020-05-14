# Uncomment this line to define a global platform for your project
platform :ios, '10.0'
use_frameworks!

# ignore all warnings from all pods
inhibit_all_warnings!

workspace 'Medicare'
project 'Medicare/Medicare.xcodeproj'

def import_pods
    # Common component in Swift
    pod 'TSCollection/AlertManager', :git => 'https://gitlab.com/sanghv1/TSCollection.git', :branch => 'swift5.0'
    pod 'TSCollection/ApiManager', :git => 'https://gitlab.com/sanghv1/TSCollection.git', :branch => 'swift5.0'
    pod 'TSCollection/Extension', :git => 'https://gitlab.com/sanghv1/TSCollection.git', :branch => 'swift5.0'
    pod 'TSCollection/Formatter', :git => 'https://gitlab.com/sanghv1/TSCollection.git', :branch => 'swift5.0'
    pod 'TSCollection/ImageManager', :git => 'https://gitlab.com/sanghv1/TSCollection.git', :branch => 'swift5.0'
    pod 'TSCollection/SubviewClass', :git => 'https://gitlab.com/sanghv1/TSCollection.git', :branch => 'swift5.0'
    pod 'TSCollection/Service', :git => 'https://gitlab.com/sanghv1/TSCollection.git', :branch => 'swift5.0'

    # Better version of ActionSheetPicker with support iOS7 and other improvements.
    pod 'ActionSheetPicker-3.0', '~> 2.0'

    # Easiest way to create an attributed UITextView (with support for multiple links and html).
    pod 'AttributedTextView', '~> 1.0'

    # Charts is a powerful & easy to use chart library for iOS, tvOS and OSX (and Android)
    # pod 'Charts' , '~> 3.0'

    # Tasteful Checkbox for iOS. (Check box)
    pod 'BEMCheckBox'

    # Best and lightest-weight crash reporting for mobile, desktop and tvOS.
    pod 'Crashlytics'

    # Dates and time made easy in Swift
    pod 'DateToolsSwift', '~> 4.0'

    # A Material Design drop down
    pod 'DropDown', '~> 2.0'

    # A drop-in UITableView/UICollectionView superclass category for showing empty datasets whenever the view has no content to display.
    pod 'DZNEmptyDataSet', '~> 1.0'

    # An easy way to customize tabBarController and tabBarItem.
    pod 'ESTabBarController-swift', '~> 2.0'

    # Fabric by Google, Inc.
    pod 'Fabric'

    # Firebase
    pod 'Firebase/Analytics'

    # FSPagerView is an elegant Screen Slide Library for making Banner、Product Show、Welcome/Guide Pages、Screen/ViewController Sliders.
    pod 'FSPagerView', '~> 0.8'

    # Codeless drop-in universal library allows to prevent issues of keyboard sliding up and cover UITextField/UITextView.
    pod 'IQKeyboardManagerSwift', '~> 6.0'

    # Swift-friendly localization and i18n syntax with in-app language switching.
    pod 'Localize-Swift', '~> 3.0'

    # MZFormSheetPresentationController provides an alternative to the native iOS UIModalPresentationFormSheet
    pod 'MZFormSheetPresentationController', '~> 2.0'

    # OneSignal push notification library for mobile apps.
    # pod 'OneSignal'

    # This component implements pure pull-to-refresh logic and you can use it for developing your own pull-to-refresh animations https://yalantis.com
    pod 'PullToRefresher', '~> 3.0'

    # Get strong typed, autocompleted resources like images, fonts and segues in Swift projects
    pod 'R.swift', '~> 5.0'

    # An elegant way to show users that something is happening and also prepare them to which contents he is waiting
    pod 'SkeletonView', '~> 1.0'

    # Swift SignalR Client for Asp.Net Core SignalR server
    # pod 'SwiftSignalRClient', '~> 0.0'

    # A clean and lightweight progress HUD for your iOS and tvOS app.
    pod 'SVProgressHUD', '~> 2.0'

    # HEX color handling as an extension for UIColor. Written in Swift.
    pod 'SwiftHEXColors', '~> 1.0'

    # A tool to enforce Swift style and conventions. https://realm.io
    pod 'SwiftLint'

    # A highly customizable circular progress bar for iOS written in Swift
    pod 'UICircularProgressRing', '~> 6.0'

    # Android PagerTabStrip for iOS and much more.
    pod 'XLPagerTabStrip', '~> 9.0'

    # XCDYouTubeKit is a YouTube video player for iOS, tvOS and macOS.
    pod 'XCDYouTubeKit', '~> 2.12'

    # UXCam generates a schematic representation of the app on iOS. This is done in order to visualize in-app behavior, without recording the app's screen
    pod 'UXCam'

    pod 'NCMB', :git => 'https://github.com/NIFCLOUD-mbaas/ncmb_swift.git'
end

target 'Medicare' do
    import_pods
end

post_install do |installer|

    # add swift version

    targets4_2 = [

    ]

    targets5_0 = [
        'Kingfisher',
        'Result'
    ]

    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            if targets4_2.include? target.name
                config.build_settings['SWIFT_VERSION'] = '4.2'
            elsif targets5_0.include? target.name
                config.build_settings['SWIFT_VERSION'] = '5.0'
            else
                # config.build_settings['SWIFT_VERSION'] = '5.0'
            end
        end
    end

end
