//
//  AlbumListInteractor.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 3/8/2024.
//

import Alamofire
import Foundation

internal class AlbumsListInteractor: AlbumsListInteractorProtocol {
    func fetchAlbums(completion: @escaping (Result<[Album], Error>) -> Void) {
        AF.request("https://jsonplaceholder.typicode.com/albums")
            .responseDecodable(of: [Album].self) { response in
                switch response.result {
                case let .success(albums):
                    completion(.success(albums))
                case let .failure(error):
                    completion(.failure(error))
                }
            }
    }
}
