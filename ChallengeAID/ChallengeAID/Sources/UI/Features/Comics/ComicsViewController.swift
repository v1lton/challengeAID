//
//  ComicsViewController.swift
//  ChallengeAID
//
//  Created by Wilton Ramos da Silva on 02/07/22.
//

import RxSwift
import UIKit

class ComicsViewController: UIViewController, ComicsViewControllerProtocol {
 
    // MARK: - PRIVATE PROPERTIES
    
    private let viewModel: ComicsViewModelProtocol
    private let disposeBag = DisposeBag()
    
    // MARK: - UI
    
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
        view.backgroundColor = .red
    }
    
    private func buildViewHierarchy() {
        view.addSubview(label)
    }
    
    private func constraintUI() {
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor)
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
        label.text = content[0].title
    }
    
    private func handleError(_ error: Error) {
        print(error.localizedDescription)
    }
}
