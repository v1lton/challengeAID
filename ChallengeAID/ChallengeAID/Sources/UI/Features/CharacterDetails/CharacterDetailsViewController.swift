//
//  CharacterDetailsViewController.swift
//  ChallengeAID
//
//  Created by Wilton Ramos da Silva on 05/07/22.
//

import UIKit

class CharacterDetailsViewController: UIViewController {
    
    // MARK: - PRIVATE PROPERTIES
    
    private let viewModel: CharacterDetailsViewModelType
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var containerStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
    
    private lazy var imageView: UIImageView = {
        let image = UIImageView(frame: .zero)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "landscape_placeholder")
        return image
    }()
    
    private lazy var detailsTitle: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byTruncatingMiddle
        label.numberOfLines = 0
        label.textColor = .none
        label.font = UIFont.boldSystemFont(ofSize: 24)
        return label
    }()
    
    private lazy var detailsDescription: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .none
        return label
    }()
    
    private lazy var comicsLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textColor = .none
        label.text = "Comics"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        return label
    }()
    
    private lazy var comicsStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    // MARK: - LIFE CYCLE
    
    init(viewModel: CharacterDetailsViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupComponents()
        buildViewHierarchy()
        constraintUI()
    }
    
    // MARK: - SETUP
    
    private func setupView() {
        view.backgroundColor = .systemBackground
    }
    
    private func setupComponents() {
        let character = viewModel.getCharacter()
        setImage(for: character)
        detailsTitle.text = character.name
        detailsDescription.text = character.description
        setupStackView(for: character)
    }
    
    private func buildViewHierarchy() {
        view.addSubview(scrollView)
        scrollView.addSubview(containerStackView)
        scrollView.addSubview(imageView)
        containerStackView.addArrangedSubview(detailsTitle)
        containerStackView.addArrangedSubview(detailsDescription)
        if viewModel.characterHasComics() {
            containerStackView.addArrangedSubview(comicsLabel)
            containerStackView.addArrangedSubview(comicsStackView)
        }
    }
    
    private func constraintUI() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            imageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 261),
            
            containerStackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            containerStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            containerStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            containerStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
    }
    
    // MARK: - PRIVATE FUNCTIONS
    
    private func setImage(for character: CharacterModel) {
        if let imageUrl = URL(string: character.getImageUrl()) {
            imageView.sd_setImage(with: imageUrl)
        }
    }
    
    private func setupStackView(for character: CharacterModel) {
        if let comics = character.comics,
           !comics.isEmpty {
            for comic in comics {
                let label = setupStackViewLabel(with: comic)
                comicsStackView.addArrangedSubview(label)
                comicsStackView.addArrangedSubview(setupSeparatorView())
            }
        }
    }
    
    private func setupStackViewLabel(with text: String) -> UILabel {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .none
        label.text = text
        return label
    }
    
    private func setupSeparatorView() -> UIView {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        view.backgroundColor = .systemGray4
        return view
    }
}
