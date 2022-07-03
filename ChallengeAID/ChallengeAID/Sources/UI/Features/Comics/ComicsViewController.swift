//
//  ComicsViewController.swift
//  ChallengeAID
//
//  Created by Wilton Ramos da Silva on 02/07/22.
//

import Combine
import UIKit

class ComicsViewController: UIViewController, ComicsViewControllerProtocol {
 
    // MARK: - PRIVATE PROPERTIES
    
    private let viewModel: ComicsViewModelProtocol
    
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
}
