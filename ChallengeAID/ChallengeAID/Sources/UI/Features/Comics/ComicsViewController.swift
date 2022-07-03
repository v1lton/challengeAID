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
    private let reuseIdentifier = "ComicsCell"
    
    // MARK: - UI
    
    private lazy var comicsTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    private let label: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Comics!"
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
        viewModel.retrieveComics()
        setupView()
        buildViewHierarchy()
        constraintUI()
        bindObservables()
    }
    
    // MARK: - SETUP
    
    private func setupView() {
        view.backgroundColor = .white
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
    
    private func handleContent(_ content: [Comic]) {
        comicsTableView.reloadData()    }
    
    private func handleError(_ error: Error) {
        print(error.localizedDescription)
    }
}

extension ComicsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.saveUserComic(from: indexPath.row)
    }
}

extension ComicsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.getComics()?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        let comics = viewModel.getComics()
        cell.textLabel?.text = comics?[indexPath.row].title
        return cell
    }
}

