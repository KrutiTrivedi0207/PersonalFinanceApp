//
//  NetworkingManager.swift
//  PersonalFinanceApp
//
//  Created by Kruti Trivedi on 20/06/24.
//

import Foundation
import Alamofire

class NetworkingManager {
    static let shared = NetworkingManager()
    
    let key = "b35dbefc4e914404bb6579bdf8022df7"

    private init() {}

    func fetchFinancialNews(completion: @escaping (Result<FinancialNews, Error>) -> Void) {
        let url = "https://newsapi.org/v2/everything?q=stocks&sortBy=publishedAt&apiKey=\(key)"

        AF.request(url).responseDecodable(of: FinancialNews.self) { response in
            switch response.result {
            case .success(let news):
                completion(.success(news))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

struct FinancialNews: Decodable {
    let status: String?
    let totalResults: Int?
    let articles: [Articles]?
}

struct Articles: Decodable {
    let title: String?
    let content: String?
    let urlToImage: String?
}

