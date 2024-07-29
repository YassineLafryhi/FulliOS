platform :ios, '17.0'
inhibit_all_warnings!

target 'FulliOS' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for FulliOS
  pod 'SwiftLint'
  pod 'SwiftFormat/CLI'
  pod 'R.swift'
  pod 'SwiftGen'
  pod 'Periphery'
  pod 'SwiftySpell'
  pod 'IBLinter'
  pod 'Sourcery'

  pod 'Kingfisher'
  pod 'Alamofire'
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

  target 'FulliOSTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'FulliOSUITests' do
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
