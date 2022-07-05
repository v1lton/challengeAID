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
    
    private var isEmpty: Bool = true {
        didSet {
            handleEmptyView()
        }
    }
    
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
    
    private lazy var emptyFavoritesLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = .systemGray
        label.numberOfLines = 2
        label.textAlignment = .center
        label.text = "Oh! You don't have favorites comics"
        return label
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
        setupView()
        setupNavigationBar()
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
        view.backgroundColor = .systemBackground
    }
    
    private func buildViewHierarchy() {
        view.addSubview(comicsTableView)
        view.addSubview(emptyFavoritesLabel)
    }
    
    private func constraintUI() {
        NSLayoutConstraint.activate([
            emptyFavoritesLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyFavoritesLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyFavoritesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            emptyFavoritesLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
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
        definesPresentationContext = true
    }
    
    private func handleEmptyView() {
        emptyFavoritesLabel.isHidden = !isEmpty
        comicsTableView.isHidden = isEmpty
        navigationItem.searchController?.searchBar.isHidden = isEmpty
        view.layoutIfNeeded()
    }
}

extension FavoritesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let comicsCount = viewModel.getComics()?.count,
           comicsCount > 0 {
            isEmpty = false
            return comicsCount
        }
        isEmpty = true
        return 0
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
