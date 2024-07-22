//
//  UnityBridge.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 22/7/2024.
//

import Foundation
import UnityFramework

internal class UnityBridge: NSObject, UnityFrameworkListener {
    static let shared = UnityBridge()

    private let dataBundleId = "com.unity3d.framework"
    public var unityFramework: UnityFramework?

    private override init() {}

    func show(in viewController: UIViewController) {
        if unityFramework == nil {
            loadUnityFramework()
        }

        if let unityFramework = unityFramework {
            showUnityWindow(in: viewController)
            unityFramework.runEmbedded(withArgc: CommandLine.argc, argv: CommandLine.unsafeArgv, appLaunchOpts: nil)
        }
    }

    private func loadUnityFramework() {
        guard let bundlePath = Bundle.main.path(forResource: "UnityFramework", ofType: "framework") else {
            print("UnityFramework.framework not found")
            return
        }

        let bundle = Bundle(path: bundlePath)
        if bundle?.isLoaded == false {
            bundle?.load()
        }

        guard let unityFramework = bundle?.principalClass?.getInstance() as? UnityFramework else {
            print("Failed to get UnityFramework instance")
            return
        }

        self.unityFramework = unityFramework
        unityFramework.setDataBundleId(dataBundleId)
        unityFramework.register(self)
    }

    private func showUnityWindow(in viewController: UIViewController) {
        guard let unityFramework = unityFramework else { return }

        let unityView = unityFramework.appController()?.rootView
        unityView?.frame = viewController.view.bounds
        unityView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        viewController.view.addSubview(unityView!)
    }
}
