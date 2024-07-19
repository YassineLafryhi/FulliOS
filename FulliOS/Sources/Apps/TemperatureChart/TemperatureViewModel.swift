//
//  TemperatureViewModel.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 19/7/2024.
//

import Foundation
import RxSwift

internal struct TemperatureData: Identifiable {
    let id = UUID()
    let time: Date
    let value: Double
}

internal class TemperatureViewModel: ObservableObject {
    @Published var temperatures: [TemperatureData] = []
    private var disposeBag = DisposeBag()
    private var webSocketTask: URLSessionWebSocketTask?

    func startObservingTemperatures() {
        guard let url = URL(string: Constants.TemperatureChartApp.wsUrl) else { return }
        let request = URLRequest(url: url)
        webSocketTask = URLSession.shared.webSocketTask(with: request)

        let observable = Observable<String>.create { observer in
            self.receiveMessage(observer: observer)
            return Disposables.create {
                self.webSocketTask?.cancel(with: .goingAway, reason: nil)
            }
        }

        observable
            .compactMap { string -> TemperatureData? in
                guard let value = Double(string) else { return nil }
                return TemperatureData(time: Date(), value: value)
            }
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] data in
                self?.temperatures.append(data)
                if self?.temperatures.count ?? 0 > 100 {
                    self?.temperatures.removeFirst()
                }
            }
            .disposed(by: disposeBag)

        webSocketTask?.resume()
    }

    private func receiveMessage(observer: AnyObserver<String>) {
        webSocketTask?.receive { [weak self] result in
            switch result {
            case let .failure(error):
                observer.onError(error)
            case let .success(.string(message)):
                observer.onNext(message)
                self?.receiveMessage(observer: observer)
            case .success:
                self?.receiveMessage(observer: observer)
            }
        }
    }
}
