//
//  APICaller.swift
//  AnimeQuotes
//
//  Created by Rafaell Andrade on 21/06/21.
//

import Foundation

final class APICaller {
    static let shared = APICaller()
    
    struct Constants {
        static let randomQuotesURL = URL(string: "https://animechan.vercel.app/api/quotes")
        static let searchURLString = "https://animechan.vercel.app/api/quotes/anime?title="
    }
    
    private func fetchData(with url: URL, completion: @escaping (Result<[Quote], Error>) -> Void) {
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print(error)
                completion(.failure(error))
            }
            else if let data = data {
                do {
                    let result = try JSONDecoder().decode([Quote].self, from: data)
                    completion(.success(result))
                }
                catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
    public func getRandomQuotes(completion: @escaping (Result<[Quote], Error>) -> Void) {
        guard let url =  Constants.randomQuotesURL else { return }
        fetchData(with: url, completion: completion)
    }
    
    public func search(with query: String, completion: @escaping (Result<[Quote], Error>) -> Void) {
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        let urlString = Constants.searchURLString + query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        guard let url = URL(string: urlString) else { return }
        fetchData(with: url, completion: completion)
    }
}
