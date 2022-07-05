//
//  FavoritesViewController.swift
//  ChallengeAID
//
//  Created by Wilton Ramos da Silva on 04/07/22.
//

import UIKit

protocol FavoritesViewControllerDelegate: AnyObject {
    func favoritesViewController(didTapComic comic: ComicModel)
}

class FavoritesViewController: UIViewController {
    
    // MARK: - PRIVATE PROPERTIES
    
    private var viewModel: FavoritesViewModelType
    private let reuseIdentifier = "EntityTableViewCell"
    
    // MARK: - PUBLIC PROPERTIES
    
    weak var delegate: FavoritesViewControllerDelegate?
    
    // MARK: - UI
    
    private lazy var comicsTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(EntityTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 182
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    private lazy var searchBar: UISearchController = {
        let searchController = UISearchController()
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search for favorite title"
        return searchController
    }()
    
    // MARK: - LIFE CYCLE
    
    init(viewModel: FavoritesViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupView()
        buildViewHierarchy()
        constraintUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        comicsTableView.reloadData()
    }
    
    // MARK: - SETUP
    
    private func setupView() {
        title = "Favorites"
    }
    
    private func buildViewHierarchy() {
        view.addSubview(comicsTableView)
    }
    
    private func constraintUI() {
        NSLayoutConstraint.activate([
            comicsTableView.topAnchor.constraint(equalTo: view.topAnchor),
            comicsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            comicsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            comicsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
    }
    
    private func setupNavigationBar() {
        navigationItem.searchController = searchBar
        navigationItem.hidesSearchBarWhenScrolling = true
        navigationItem.title = title
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        definesPresentationContext = true
    }
}

extension FavoritesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.getComics()?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! EntityTableViewCell //TODO: fix force cast
        let comics = viewModel.getComics()
        guard let comic = comics?[indexPath.row] else { return cell }
        cell.setupCell(with: .init(title: comic.title,
                                   description: comic.description,
                                   imagePath: comic.imagePath,
                                   imageExtension: comic.imageExtension,
                                   isFavorite: comic.isFavorite))
        return cell
    }
}

extension FavoritesViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let comic = viewModel.getComic(at: indexPath.row) else { return }
        delegate?.favoritesViewController(didTapComic: comic)
    }
}

extension FavoritesViewController: UISearchControllerDelegate { }

extension FavoritesViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text,
           !text.isEmpty {
            viewModel.filterModel = FilterSearchModel(text: text)
        } else {
            viewModel.filterModel = nil
        }
        comicsTableView.reloadData()
    }
}

extension FavoritesViewController: UISearchBarDelegate { }
