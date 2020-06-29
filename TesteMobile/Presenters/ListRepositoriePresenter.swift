//
//  ListRepositoriePresenter.swift
//  TesteMobile
//
//  Created by Bruno F. de Almeida on 27/06/20.
//  Copyright © 2020 Bruno F. de Almeida. All rights reserved.
//

import Foundation

protocol RepositoriesPresenterDelegate: class {
  func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?)
  func onFetchFailed(with reason: String)
}

class ListRepositoriePresenter {
    private weak var delegate: RepositoriesPresenterDelegate?

    private let service = ListRepositoriesService()
    private var repositories = [Repositorie]()
    var pageCount = 1
    private var total = 0
    private var isFetchRepositories = false

    init(delegate: RepositoriesPresenterDelegate) {
        self.delegate = delegate
    }

    func loadRepositories() {
        guard !isFetchRepositories else {
            return
        }

        isFetchRepositories = true
        service.fetchRepositories(page: pageCount) { result in
            switch result {
                case let .success(repos):
                    DispatchQueue.main.async {
                        self.isFetchRepositories = false
                        // API do GitHub altera o valor total a cada requisição e estava me trazendo problemas, optei por um número fixo até achar uma solução.
//                        self.total = repos.total_count
                        self.total = 100000
                        self.repositories.append(contentsOf: repos.items!)

                        if self.pageCount > 1 {
                            let indexPathsToReload = self.calculateIndexPathsToReload(from: repos.items!)
                            self.delegate?.onFetchCompleted(with: indexPathsToReload)
                        } else {
                            self.delegate?.onFetchCompleted(with: .none)
                        }

                        self.pageCount += 1
                    }
                case let .failure(error):
                    DispatchQueue.main.async {
                      self.isFetchRepositories = false
                      self.delegate?.onFetchFailed(with: error.localizedDescription)
                    }
            }
        }
    }

    var totalCount: Int {
      return total
    }

    var currentCount: Int {
      return repositories.count
    }

    func repositorie(at index: Int) -> Repositorie {
      return repositories[index]
    }

    private func calculateIndexPathsToReload(from newRepositories: [Repositorie]) -> [IndexPath] {
      let startIndex = repositories.count - newRepositories.count
      let endIndex = startIndex + newRepositories.count
      return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
}
