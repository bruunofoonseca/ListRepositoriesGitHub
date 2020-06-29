//
//  ListPullRequestsViewController.swift
//  TesteMobile
//
//  Created by Bruno F. de Almeida on 28/06/20.
//  Copyright © 2020 Bruno F. de Almeida. All rights reserved.
//

import UIKit

class ListPullRequestsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var presenter: ListPullRequestPresenter!

    @IBOutlet var tableView: UITableView!
    @IBOutlet var indicatorView: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter = ListPullRequestPresenter(user: presenter.user, repo: presenter.repositorie, delegate: self)

        title = presenter.repositorie

        indicatorView.color = UIColor.green
        indicatorView.startAnimating()

        tableView.isHidden = true
        tableView.separatorColor = UIColor.darkGray
        tableView.dataSource = self

        presenter.loadPullRequests()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if presenter.currentCount == 0 {
            tableView.setEmptyView(title: "Não há pull requests para este repositório!", message: "")
        } else {
            tableView.restore()
        }

        return presenter.currentCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pullCell", for: indexPath) as! PullRequestCell

        if isLoadingCell(for: indexPath) {
            cell.configure(with: .none)
        } else {
            cell.configure(with: presenter.pullRequest(at: indexPath.row))
        }

        return cell
    }

    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= presenter.currentCount
    }
}

extension ListPullRequestsViewController: PullRequestPresenterDelegate {
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?) {
        indicatorView.stopAnimating()
        tableView.isHidden = false
        tableView.reloadData()
        return
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

extension UITableView {
    func setEmptyView(title: String, message: String) {
        let emptyView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))
        let titleLabel = UILabel()
        let messageLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
        messageLabel.textColor = UIColor.lightGray
        messageLabel.font = UIFont(name: "HelveticaNeue-Regular", size: 17)
        emptyView.addSubview(titleLabel)
        emptyView.addSubview(messageLabel)
        titleLabel.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        messageLabel.leftAnchor.constraint(equalTo: emptyView.leftAnchor, constant: 20).isActive = true
        messageLabel.rightAnchor.constraint(equalTo: emptyView.rightAnchor, constant: -20).isActive = true
        titleLabel.text = title
        messageLabel.text = message
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center

        self.backgroundView = emptyView
        self.separatorStyle = .none
    }

    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}
