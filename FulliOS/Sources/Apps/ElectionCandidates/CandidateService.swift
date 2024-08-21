//
//  CandidateService.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 21/8/2024.
//

import Alamofire
import Foundation
import Moya

internal enum CandidateAPI {
    case getAll
    case getOne(id: UUID)
    case create(candidate: Candidate)
    case update(candidate: Candidate)
    case delete(id: UUID)
}

extension CandidateAPI: TargetType {
    var baseURL: URL { URL(string: "http://192.168.1.86:7070/api/v1/candidates")! }

    var path: String {
        switch self {
        case .getAll:
            return ""
        case let .getOne(id: id):
            return "/\(id)"
        case let .create(candidate: candidate):
            return ""
        case let .update(candidate: candidate):
            return "/\(candidate.id)"
        case let .delete(id: id):
            return "/\(id)"
        }
    }

    var method: Moya.Method {
        switch self {
        case .getAll, .getOne:
            return .get
        case .create:
            return .post
        case .update:
            return .put
        case .delete:
            return .delete
        }
    }

    var task: Task {
        switch self {
        case .getAll, .getOne, .delete:
            return .requestPlain
        case let .create(candidate), let .update(candidate):
            return .requestJSONEncodable(candidate)
        }
    }

    var headers: [String: String]? {
        ["Content-Type": "application/json"]
    }
}

internal class CandidateService {
    private let provider = MoyaProvider<CandidateAPI>()

    func fetchAllCandidates(completion: @escaping (Result<[Candidate], Error>) -> Void) {
        provider.request(.getAll) { result in
            switch result {
            case let .success(response):
                do {
                    let candidates = try JSONDecoder().decode([Candidate].self, from: response.data)
                    completion(.success(candidates))
                } catch {
                    completion(.failure(error))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    func fetchCandidate(id: UUID, completion: @escaping (Result<Candidate, Error>) -> Void) {
        provider.request(.getOne(id: id)) { result in
            switch result {
            case let .success(response):
                do {
                    let candidate = try JSONDecoder().decode(Candidate.self, from: response.data)
                    completion(.success(candidate))
                } catch {
                    completion(.failure(error))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    func createCandidate(_ candidate: Candidate, completion: @escaping (Result<Void, Error>) -> Void) {
        provider.request(.create(candidate: candidate)) { result in
            switch result {
            case .success:
                completion(.success(()))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    func updateCandidate(_ candidate: Candidate, completion: @escaping (Result<Void, Error>) -> Void) {
        provider.request(.update(candidate: candidate)) { result in
            switch result {
            case .success:
                completion(.success(()))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    func deleteCandidate(id: UUID, completion: @escaping (Result<Void, Error>) -> Void) {
        provider.request(.delete(id: id)) { result in
            switch result {
            case .success:
                completion(.success(()))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
