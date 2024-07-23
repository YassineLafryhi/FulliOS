//
//  UnityBridge.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 22/7/2024.
//

import Foundation
import UnityFramework

internal class UnityBridge: UIResponder, UIApplicationDelegate {
    static let shared = UnityBridge()

    var unityFramework: UnityFramework?
    var hostMainWindow: UIWindow?

    func initializeUnity() {
        hostMainWindow = UIApplication.shared.windows.first
    }

    func loadUnityFramework() -> UnityFramework? {
        var bundlePath: String? = Bundle.main.bundlePath
        bundlePath?.append("/Frameworks/UnityFramework.framework")

        guard let path = bundlePath, let bundle = Bundle(path: path) else {
            return nil
        }

        if !bundle.isLoaded {
            bundle.load()
        }

        guard let principalClass = bundle.principalClass as? UnityFramework.Type else {
            return nil
        }

        let unityFramework = principalClass.getInstance()

        if unityFramework?.appController() == nil {
            var executeHeader = _mh_execute_header
            unityFramework?.setExecuteHeader(&executeHeader)
        }

        return unityFramework
    }

    func showUnity() {
        if let unityFramework = loadUnityFramework() {
            self.unityFramework = unityFramework
            unityFramework.setDataBundleId("com.unity3d.framework")
            unityFramework.register(self)
            unityFramework.runEmbedded(withArgc: CommandLine.argc, argv: CommandLine.unsafeArgv, appLaunchOpts: nil)

            if let rootVC = hostMainWindow?.rootViewController {
                if let unityVC = unityFramework.appController()?.rootViewController {
                    rootVC.present(unityVC, animated: true, completion: nil)
                }
            }
        }
    }
}

extension UnityBridge: UnityFrameworkListener {
    func unityDidUnload(_: Notification) {
        // TODO: Handle Unity did unload
    }

    func unityDidQuit(_: Notification) {
        // TODO: Handle Unity did quit
    }
}
