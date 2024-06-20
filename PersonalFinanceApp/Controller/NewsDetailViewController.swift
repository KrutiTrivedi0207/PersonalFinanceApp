//
//  NewsDetailViewController.swift
//  PersonalFinanceApp
//
//  Created by Kruti Trivedi on 20/06/24.
//

import UIKit

class NewsDetailViewController: UIViewController {

    var news: Articles?

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var newsImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        if let news = news {
            titleLabel.text = news.title ?? ""
            descriptionLabel.text = news.content ?? ""
            if let url = URL(string: news.urlToImage ?? "") {
                URLSession.shared.dataTask(with: url) { data, response, error in
                    guard let data = data, error == nil else { return }
                    DispatchQueue.main.async {
                        self.newsImageView.image = UIImage(data: data)?.resized(to: CGSize(width: self.newsImageView.frame.width, height: self.newsImageView.frame.height))
                    }
                }.resume()
            }
        }
    }
}

