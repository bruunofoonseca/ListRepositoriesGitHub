//
//  ListPullRequestPresenter.swift
//  TesteMobile
//
//  Created by Bruno F. de Almeida on 28/06/20.
//  Copyright © 2020 Bruno F. de Almeida. All rights reserved.
//

import Foundation

protocol PullRequestPresenterDelegate: class {
  func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?)
  func onFetchFailed(with reason: String)
}

class ListPullRequestPresenter: NSObject {
    private weak var delegate: PullRequestPresenterDelegate?

    private let service = ListPullRequestService()
    private var pullRequests = [PullRequest]()
    private var isFetchPullRequest = false
    var user: String!
    var repositorie: String!

    init(user: String, repo: String, delegate: PullRequestPresenterDelegate) {
        self.delegate = delegate
        self.user = user
        self.repositorie = repo
    }

    init(user: String, repo: String) {
        self.user = user
        self.repositorie = repo
    }

    func loadPullRequests() {
        guard !isFetchPullRequest else {
            return
        }

        isFetchPullRequest = true
        service.fetchPullRequest(user: self.user, repo: self.repositorie) { result in
            switch result {
                case let .success(pulls):
                    DispatchQueue.main.async {
                        self.isFetchPullRequest = false
                        self.pullRequests.append(contentsOf: pulls)

                        self.delegate?.onFetchCompleted(with: .none)
                    }
                case let .failure(error):
                    DispatchQueue.main.async {
                      self.isFetchPullRequest = false
                      self.delegate?.onFetchFailed(with: error.localizedDescription)
                    }
            }
        }
    }

    var currentCount: Int {
      return pullRequests.count
    }

    func pullRequest(at index: Int) -> PullRequest {
      return pullRequests[index]
    }
}
