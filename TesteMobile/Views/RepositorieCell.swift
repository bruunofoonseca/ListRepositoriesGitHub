//
//  RepositorieCell.swift
//  TesteMobile
//
//  Created by Bruno F. de Almeida on 28/06/20.
//  Copyright © 2020 Bruno F. de Almeida. All rights reserved.
//

import UIKit

class RepositorieCell: UITableViewCell {

    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var repositorieName: UILabel!
    @IBOutlet weak var repositorieDescription: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var forks: UILabel!
    @IBOutlet weak var stars: UILabel!
    @IBOutlet var indicatorView: UIActivityIndicatorView!
    @IBOutlet var indicatorImageView: UIActivityIndicatorView!

    override func prepareForReuse() {
      super.prepareForReuse()
      
      configure(with: .none)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        indicatorView.hidesWhenStopped = true
        indicatorView.color = UIColor.green

        indicatorImageView.hidesWhenStopped = true
        indicatorImageView.color = UIColor.green
    }
    
    func configure(with repositorie: Repositorie?) {
      if let repo = repositorie {
        repositorieName.text = repo.name
        repositorieDescription.text = repo.description
        userName.text = repo.authorName
        forks.text = "\(repo.forksCount) Forks"
        stars.text = "\(repo.stargazersCount) Stars"
        if let urlPhoto = URL(string: repo.avatarUrl) {
            load(url: urlPhoto)
        }

        repositorieName.alpha = 1
        repositorieDescription.alpha = 1
        userName.alpha = 1
        forks.alpha = 1
        stars.alpha = 1

        indicatorView.stopAnimating()
      } else {
        repositorieName.alpha = 0
        repositorieDescription.alpha = 0
        userName.alpha = 0
        forks.alpha = 0
        stars.alpha = 0
        indicatorView.startAnimating()
      }
    }

    func load(url: URL) {
        avatar.alpha = 0
        indicatorImageView.startAnimating()
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.avatar.image = image
                        self?.indicatorImageView.stopAnimating()
                        self?.avatar.alpha = 1
                    }
                }
            }
        }
    }
}
