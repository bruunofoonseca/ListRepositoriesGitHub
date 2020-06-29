//
//  PullRequestCell.swift
//  TesteMobile
//
//  Created by Bruno F. de Almeida on 28/06/20.
//  Copyright © 2020 Bruno F. de Almeida. All rights reserved.
//

import UIKit

class PullRequestCell: UITableViewCell {
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var body: UILabel!
    @IBOutlet weak var data: UILabel!
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
    
    func configure(with pullRequest: PullRequest?) {
      if let pull = pullRequest {
        title.text = pull.title
        body.text = pull.body
        userName.text = pull.userName

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from:pull.data!)!
        dateFormatter.dateFormat = "dd/MM/yyyy"

        data.text = dateFormatter.string(from: date)
        if let urlPhoto = URL(string: pull.avatar!) {
            load(url: urlPhoto)
        }

        title.alpha = 1
        body.alpha = 1
        userName.alpha = 1
        data.alpha = 1

        indicatorView.stopAnimating()
      } else {
        title.alpha = 0
        body.alpha = 0
        userName.alpha = 0
        data.alpha = 0

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
