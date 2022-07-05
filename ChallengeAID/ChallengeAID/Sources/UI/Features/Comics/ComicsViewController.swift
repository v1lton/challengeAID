//
//  ComicsViewController.swift
//  ChallengeAID
//
//  Created by Wilton Ramos da Silva on 02/07/22.
//

import CoreData
import RxSwift
import UIKit

class ComicsViewController: UIViewController, ComicsViewControllerProtocol {
    
    // MARK: - PRIVATE PROPERTIES
    
    private var viewModel: ComicsViewModelProtocol
    private let disposeBag = DisposeBag()
    private let reuseIdentifier = "EntityTableViewCell"
    
    // MARK: - PUBLIC PROPERTIES
    
    weak var delegate: ComicsViewControllerDelegate?
    
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
        searchController.searchBar.placeholder = "Search for comic title"
        return searchController
    }()
    
    private lazy var spinner: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.isHidden = true
        return indicator
    }()
    
    private lazy var feedbackLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = .systemGray
        label.numberOfLines = 0
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    // MARK: - LIFE CYCLE
    
    init(viewModel: ComicsViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.retrieveComics(asPagination: false)
        setupView()
        setupNavigationBar()
        buildViewHierarchy()
        constraintUI()
        bindObservables()
    }
    
    // MARK: - SETUP
    
    private func setupView() {
        view.backgroundColor = .systemBackground
        title = "Comics"
    }
    
    private func buildViewHierarchy() {
        view.addSubview(comicsTableView)
        view.addSubview(spinner)
        view.addSubview(feedbackLabel)
    }
    
    private func constraintUI() {
        NSLayoutConstraint.activate([
            spinner.topAnchor.constraint(equalTo: view.topAnchor),
            spinner.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            spinner.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            spinner.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            comicsTableView.topAnchor.constraint(equalTo: view.topAnchor),
            comicsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            comicsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            comicsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            feedbackLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            feedbackLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            feedbackLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            feedbackLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }
    
    private func bindObservables() {
        viewModel.viewState
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] state in
                self?.handleViewState(state)
            })
            .disposed(by: disposeBag)
    }
    
    private func setupNavigationBar() {
        navigationItem.searchController = searchBar
        navigationItem.hidesSearchBarWhenScrolling = true
        navigationItem.title = title
        definesPresentationContext = true
    }
    
    // MARK: - HANDLERS
    
    private func handleViewState(_ viewState: ComicsViewState) {
        switch viewState {
        case .loading(let asPagination):
            handleLoading(asPagination: asPagination)
        case .success(let asPagination):
            handleContent(asPagination: asPagination)
        case .error(let error):
            handleError(error)
        }
    }
    
    private func handleLoading(asPagination: Bool) {
        asPagination ? startPaginationLoadingAnimation() : startScreenLoadingAnimation()
    }
    
    private func handleContent(asPagination: Bool) {
        asPagination ? stopPaginationLoadingAnimation() : stopScreenLoadingAnimation()
        comicsTableView.reloadData()
    }
    
    private func handleError(_ error: Error) {
        stopScreenLoadingAnimation()
        stopPaginationLoadingAnimation()
        showFeebackErrorLabel(error)
    }
    
    // MARK: - PRIVATE FUNCTIONS
    
    private func createSpinnerFooter() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100))
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        spinner.startAnimating()
        return footerView
    }
    
    private func startPaginationLoadingAnimation() {
        comicsTableView.tableFooterView = createSpinnerFooter()
    }
    
    private func stopPaginationLoadingAnimation() {
        comicsTableView.tableFooterView = nil
    }
    
    private func startScreenLoadingAnimation() {
        comicsTableView.isHidden = true
        spinner.isHidden = false
        spinner.startAnimating()
    }
    
    private func stopScreenLoadingAnimation() {
        spinner.stopAnimating()
        spinner.isHidden = true
        comicsTableView.isHidden = false
    }
    
    private func showFeebackErrorLabel(_ error: Error) {
        comicsTableView.isHidden = true
        navigationItem.searchController?.searchBar.isHidden = true
        feedbackLabel.text = "We had problems fetching data. Error: \(error.localizedDescription)"
        feedbackLabel.isHidden = false
    }
}

extension ComicsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let comic = viewModel.getComic(at: indexPath.row) else { return }
        delegate?.comicsViewController(didTapComic: comic)
    }
}

extension ComicsViewController: UITableViewDataSource {
    
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let comicsCount = viewModel.getComics()?.count else { return }
        if indexPath.row == comicsCount - 3 {
            guard !viewModel.isPaginating else { return }
            viewModel.retrieveComics(asPagination: true)
        }
    }
}

extension ComicsViewController: UISearchControllerDelegate { }

extension ComicsViewController: UISearchResultsUpdating {
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

extension ComicsViewController: UISearchBarDelegate { }
