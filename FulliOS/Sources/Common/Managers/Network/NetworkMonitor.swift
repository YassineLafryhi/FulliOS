//
//  NetworkMonitor.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 30/8/2024.
//

import Foundation
import Reachability

class NetworkManager {
    static let shared = NetworkManager()
    private var reachability: Reachability?
    private var noNetworkViewController: UIViewController?

    private init() {
        setupReachability()
    }

    private func setupReachability() {
        do {
            reachability = try Reachability()
            try reachability?.startNotifier()

            NotificationCenter.default.addObserver(
                self,
                selector: #selector(reachabilityChanged),
                name: .reachabilityChanged,
                object: reachability)
        } catch {
            print("Could not start reachability notifier")
        }
    }

    @objc
    private func reachabilityChanged(note: Notification) {
        guard let reachability = note.object as? Reachability else { return }

        if reachability.connection == .unavailable {
            DispatchQueue.main.async {
                self.showNoNetworkPage()
            }
        } else {
            DispatchQueue.main.async {
                self.hideNoNetworkPage()
            }
        }
    }

    private func showNoNetworkPage() {
        guard noNetworkViewController == nil else { return }

        let noNetworkVC = UIViewController()
        noNetworkVC.view.backgroundColor = .white

        let label = UILabel()
        label.text = "No network connection"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        noNetworkVC.view.addSubview(label)

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: noNetworkVC.view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: noNetworkVC.view.centerYAnchor)
        ])

        if
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let window = windowScene.windows.first {
            window.addSubview(noNetworkVC.view)
            noNetworkVC.view.frame = window.bounds
            noNetworkVC.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        }

        noNetworkViewController = noNetworkVC
    }

    private func hideNoNetworkPage() {
        noNetworkViewController?.view.removeFromSuperview()
        noNetworkViewController = nil
    }
}
