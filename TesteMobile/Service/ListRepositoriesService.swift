//
//  ListRepositoriesService.swift
//  TesteMobile
//
//  Created by Bruno F. de Almeida on 25/06/20.
//  Copyright © 2020 Bruno F. de Almeida. All rights reserved.
//

import Foundation

enum RepositorieError: Error {
    case decodeError
    case error(String)
}

class ListRepositoriesService {
    func fetchRepositories(page: Int, completion: @escaping (Result<Start, RepositorieError>) -> Void) {
        let urlString = "https://api.github.com/search/repositories"

        var urlComponents = URLComponents(string:
            urlString)!
        urlComponents.queryItems = [
          URLQueryItem(name: "q", value: "language:Java"),
          URLQueryItem(name: "sort", value: "stars"),
          URLQueryItem(name: "page", value: String(page))
        ]

        var request = URLRequest(url: urlComponents.url!)
        let session = URLSession.shared

        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Powered by Swift!", forHTTPHeaderField: "X-Powered-By")
        request.httpMethod = "GET"

        let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
            do {
                if error != nil {
                    completion(.failure(.error(error!.localizedDescription)))
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    completion(.failure(.error(error!.localizedDescription)))
                    return
                }

                guard let mime = response?.mimeType, mime == "application/json" else {
                    print("Wrong MIME type!")
                    return
                }

                let decoder = JSONDecoder()
                let decoded = try decoder.decode(Start.self, from: data!)

                DispatchQueue.main.async {
                    completion(.success(decoded))
                }
            } catch let error {
                debugPrint("[Service] -----> \(error)")
                completion(.failure(.error(error.localizedDescription)))
            }
        })

        task.resume()
    }
}
