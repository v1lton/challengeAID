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
    
    private let viewModel: ComicsViewModelProtocol
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
        viewModel.retrieveComics(pagination: false)
        setupView()
        buildViewHierarchy()
        constraintUI()
        bindObservables()
    }
    
    // MARK: - SETUP
    
    private func setupView() {
        title = "Comics"
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
    
    private func bindObservables() {
        viewModel.viewState
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] state in
                self?.handleViewState(state)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - HANDLERS
    
    private func handleViewState(_ viewState: ComicsViewState) {
        switch viewState {
        case .loading:
            handleLoading()
        case .content(let content):
            handleContent(content)
        case .error(let error):
            handleError(error)
        }
    }
    
    private func handleLoading() { }
    
    private func handleContent(_ content: [ComicModel]) {
        comicsTableView.tableFooterView = nil
        comicsTableView.reloadData()
    }
    
    private func handleError(_ error: Error) {
        print(error.localizedDescription)
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
            viewModel.retrieveComics(pagination: true)
            self.comicsTableView.tableFooterView = createSpinnerFooter()
        }
    }
}
