//
//  CandidateStore.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 21/8/2024.
//

import Combine
import Foundation

internal class CandidateStore: ObservableObject {
    @Published var candidates: [Candidate] = []
    @Published var selectedCandidate: Candidate?
    @Published var isLoading = false
    @Published var error: String?

    private let service: CandidateService
    private var cancellables = Set<AnyCancellable>()

    init(service: CandidateService = CandidateService()) {
        self.service = service
    }

    func fetchAllCandidates() {
        isLoading = true
        service.fetchAllCandidates { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case let .success(candidates):
                    self?.candidates = candidates
                case let .failure(error):
                    self?.error = error.localizedDescription
                }
            }
        }
    }

    func fetchCandidate(id: UUID) {
        isLoading = true
        service.fetchCandidate(id: id) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case let .success(candidate):
                    self?.selectedCandidate = candidate
                case let .failure(error):
                    self?.error = error.localizedDescription
                }
            }
        }
    }

    func createCandidate(candidate: Candidate) {
        service.createCandidate(candidate) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.fetchAllCandidates()
                case let .failure(error):
                    self?.error = error.localizedDescription
                }
            }
        }
    }

    func updateCandidate(candidate: Candidate) {
        service.updateCandidate(candidate) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.fetchAllCandidates()
                case let .failure(error):
                    self?.error = error.localizedDescription
                }
            }
        }
    }

    func deleteCandidate(id: UUID) {
        service.deleteCandidate(id: id) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.fetchAllCandidates()
                case let .failure(error):
                    self?.error = error.localizedDescription
                }
            }
        }
    }
}
