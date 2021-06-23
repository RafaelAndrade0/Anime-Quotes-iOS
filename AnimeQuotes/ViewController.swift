//
//  ViewController.swift
//  AnimeQuotes
//
//  Created by Rafaell Andrade on 21/06/21.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(QuotesTableViewCell.self, forCellReuseIdentifier: QuotesTableViewCell.identifier)
        return table
    }()
    
    private let searchVC = UISearchController(searchResultsController: nil)
    
    private var viewModels = [QuotesTableViewCellModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Anime Quotes"
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        createSearchBar()
        fetchRandomQuotes()
    }
    
    override func viewDidLayoutSubviews() {
        tableView.frame = view.bounds
    }
    
    func fetchRandomQuotes() {
        self.showSpinner()
        APICaller.shared.getRandomQuotes() { [weak self] result in
            switch result {
            case .success(let quotes):
                self?.viewModels = quotes.compactMap({ result in
                    QuotesTableViewCellModel(quote: result.quote, character: result.character)
                })
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                    self?.removeSpinner()
                }
                break
            case .failure(let error):
                print(error)
                self?.removeSpinner()
                break
            }
        }
    }
    
    func createSearchBar() {
        navigationItem.searchController = searchVC
        searchVC.searchBar.delegate = self
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else { return }
        self.showSpinner()
        APICaller.shared.search(with: text) { [weak self] result in
            switch result {
            case .success(let quotes):
                self?.viewModels = quotes.compactMap({ result in
                    QuotesTableViewCellModel(quote: result.quote, character: result.character)
                })
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                    self?.searchVC.dismiss(animated: true)
                    self?.removeSpinner()
                }
                break
            case .failure(let error):
                print(error)
                self?.removeSpinner()
                break
            }
        }
    }
    
    // Table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: QuotesTableViewCell.identifier, for: indexPath)
                as? QuotesTableViewCell else {
            fatalError()
        }
        cell.configure(with: viewModels[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

