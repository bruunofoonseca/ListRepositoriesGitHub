//
//  ListRepositorieViewController.swift
//  TesteMobile
//
//  Created by Bruno F. de Almeida on 27/06/20.
//  Copyright © 2020 Bruno F. de Almeida. All rights reserved.
//

import UIKit

class ListRepositorieViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching {

    var presenter: ListRepositoriePresenter!

    @IBOutlet var tableView: UITableView!
    @IBOutlet var indicatorView: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter = ListRepositoriePresenter(delegate: self)

        title = "Lista de Repositórios"

        indicatorView.color = UIColor.green
        indicatorView.startAnimating()

        tableView.isHidden = true
        tableView.separatorColor = UIColor.darkGray
        tableView.dataSource = self
        tableView.prefetchDataSource = self

        loadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.totalCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RepositorieCell

        if isLoadingCell(for: indexPath) {
            cell.configure(with: .none)
        } else {
            cell.configure(with: presenter.repositorie(at: indexPath.row))
        }

        return cell
    }

    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingCell) {
            loadData()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let repo = presenter.repositorie(at: indexPath.row)

        let pullRequestPresenter = ListPullRequestPresenter(user: repo.authorName, repo: repo.name)

        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "ListPullRequestsViewController") as! ListPullRequestsViewController
        vc.presenter = pullRequestPresenter

        navigationController?.pushViewController(vc, animated: true)
    }

    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= presenter.currentCount
    }

    func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
        let indexPathsForVisibleRows = tableView.indexPathsForVisibleRows ?? []
        let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
        return Array(indexPathsIntersection)
    }

    func loadData() {
        presenter.loadRepositories()
    }
}

extension ListRepositorieViewController: RepositoriesPresenterDelegate {
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?) {

        guard let newIndexPathsToReload = newIndexPathsToReload else {
          indicatorView.stopAnimating()
          tableView.isHidden = false
          tableView.reloadData()
          return
        }

        let indexPathsToReload = visibleIndexPathsToReload(intersecting: newIndexPathsToReload)
        tableView.reloadRows(at: indexPathsToReload, with: .automatic)
    }
  
    func onFetchFailed(with reason: String) {
        indicatorView.stopAnimating()

        print(reason)

        let alert = UIAlertController(title: "Ops, ocorreu um erro", message: reason, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)

        return
    }
}

