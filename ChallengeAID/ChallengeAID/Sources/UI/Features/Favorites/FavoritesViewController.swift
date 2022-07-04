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
    
    private let viewModel: FavoritesViewModelType
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
        buildViewHierarchy()
        constraintUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
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
