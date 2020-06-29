//
//  ListPullRequestService.swift
//  TesteMobile
//
//  Created by Bruno F. de Almeida on 28/06/20.
//  Copyright © 2020 Bruno F. de Almeida. All rights reserved.
//

import Foundation

enum PullRequestError: Error {
    case decodeError
    case error(String)
}

class ListPullRequestService {
    func fetchPullRequest(user: String, repo: String, completion: @escaping (Result<[PullRequest], PullRequestError>) -> Void) {
        let urlString = "https://api.github.com/repos/\(user)/\(repo)/pulls"

        var request = URLRequest(url: URL(string: urlString)!)
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
                let decoded = try decoder.decode([PullRequest].self, from: data!)

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
