//
//  NewsListViewController.swift
//  PersonalFinanceApp
//
//  Created by Kruti Trivedi on 20/06/24.
//

import UIKit

class NewsListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var newsList: [Articles] = []
    var isLoading = false
    var currentPage = 1
    let pageSize = 20
    var loadingIndicator: UIActivityIndicatorView?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        setupLoadingIndicator()
        fetchNews(page: currentPage)
    }

    func setupLoadingIndicator() {
        loadingIndicator = UIActivityIndicatorView(style: .large)
        loadingIndicator?.center = view.center
        view.addSubview(loadingIndicator!)
    }

    func fetchNews(page: Int) {
        guard !isLoading else { return }
        isLoading = true
        loadingIndicator?.startAnimating()

        NetworkingManager.shared.fetchFinancialNews { result in
            self.loadingIndicator?.stopAnimating()
            self.isLoading = false
            switch result {
            case .success(let news):
                self.newsList.append(contentsOf: news.articles ?? [])
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print("Failed to fetch news: \(error)")
                DispatchQueue.main.async {
                    self.showErrorAlert(error: error)
                }
            }
        }
    }

    func showErrorAlert(error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { _ in
            self.fetchNews(page: self.currentPage)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension NewsListViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTVC", for: indexPath) as! NewsTVC
        let news = newsList[indexPath.row]
        cell.lblTitle.text = news.title ?? ""
        cell.lblDesc.text = news.content ?? ""

        if let url = URL(string: news.urlToImage ?? "") {
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else { return }
                DispatchQueue.main.async {
                    cell.imgView.image = UIImage(data: data)?.resized(to: CGSize(width: cell.imgView.frame.width, height: cell.imgView.frame.height))
                }
            }.resume()
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedNews = newsList[indexPath.row]
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if let detailVC = mainStoryboard.instantiateViewController(withIdentifier: "NewsDetailViewController") as? NewsDetailViewController {
            detailVC.news = selectedNews
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height

        if offsetY > contentHeight - height {
            currentPage += 1
            fetchNews(page: currentPage)
        }
    }
}

extension UIImage {
    func resized(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}

