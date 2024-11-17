platform :ios, '17.0'
inhibit_all_warnings!

target 'FulliOS' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for FulliOS
  
  # Pods needed for development
  pod 'SwiftLint'
  pod 'SwiftFormat/CLI'
  pod 'R.swift'
  pod 'SwiftGen'
  pod 'Periphery'
  pod 'SwiftySpell'
  pod 'IBLinter'
  pod 'Sourcery'

  # Core libraries
  pod 'Kingfisher'
  pod 'SDWebImage'
  pod 'Alamofire'
  pod 'ReachabilitySwift'
  pod 'SwiftSoup'
  pod 'OpenCV'
  pod 'GoogleMLKit/LanguageID'
  pod 'GoogleMLKit/Translate'
  pod 'Fakery'
  pod 'RealmSwift'
  pod 'Starscream'
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'Toaster'
  pod 'DeviceKit'
  pod 'ExytePopupView'
  pod 'ResearchKit'
  pod 'TensorFlowLiteSwift'
  pod 'lottie-ios'
  pod 'GCDWebServer'
  pod 'Apollo'
  pod 'PostgresClientKit'
  pod 'Moya'
  pod 'Embassy'
  #pod 'MapboxMaps'
  pod 'ReactorKit'
  pod 'AudioKit'
  pod 'TrustKit'
  pod 'IOSSecuritySuite'
  pod 'Swinject'
  pod 'ExytePopupView'
  
  # Pods needed for debugging
  pod 'FLEX', :configurations => ['Debug']
  pod 'CrashEye'

  target 'FulliOSTests' do
    inherit! :search_paths
    # Pods needed for testing
    pod 'RxBlocking'
    pod 'RxTest'
    pod 'Quick'
    pod 'Nimble'
    pod 'KIF', :configurations => ['Debug']
  end

  target 'FulliOSUITests' do
    inherit! :search_paths
    # Pods for testing
  end

  post_install do |installer|

       installer.generated_projects.each do |project|
             project.targets.each do |target|
                 target.build_configurations.each do |config|
                     config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '17.0'
                  end
             end
      end

       installer.pods_project.targets.each do |target|
           target.build_configurations.each do |config|
               config.build_settings['GCC_WARN_INHIBIT_ALL_WARNINGS'] = "YES"
           end
       end
   end

end
