//
//  DetailsViewController.swift
//  ChallengeAID
//
//  Created by Wilton Ramos da Silva on 03/07/22.
//

import UIKit
import SDWebImage

protocol DetailsViewControllerProtocol { }

class DetailsViewController: UIViewController {
    
    // MARK: - PRIVATE PROPERTIES
    
    private let viewModel: DetailsViewModelProtocol
    
    // MARK: - UI
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var imageView: UIImageView = {
        let image = UIImageView(frame: .zero)
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var bodyStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
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
    
    private lazy var detailsSwitch: UISwitch = {
        let detailsSwitch = UISwitch()
        detailsSwitch.translatesAutoresizingMaskIntoConstraints = false
        detailsSwitch.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
        return detailsSwitch
    }()
    
    private lazy var detailsDescription: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .none
        return label
    }()
    
    // MARK: - LIFE CYCLE
    
    init(viewModel: DetailsViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupComponents()
        buildViewHierarchy()
        constraintUI()
    }
    
    // MARK: - SETUP
    
    private func setupComponents() {
        view.backgroundColor = .white
        setImage()
        
        let model = viewModel.getComic()
        detailsTitle.text = model.title
        detailsDescription.text = model.description
        detailsSwitch.isOn = model.isFavorite
    }
    
    private func buildViewHierarchy() {
        view.addSubview(scrollView)
        scrollView.addSubview(bodyStackView)
        scrollView.addSubview(imageView)
        bodyStackView.addArrangedSubview(detailsTitle)
        bodyStackView.addArrangedSubview(detailsDescription)
        bodyStackView.addArrangedSubview(detailsSwitch)
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
            
            bodyStackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            bodyStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            bodyStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            bodyStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
    }
    
    // MARK: - PRIVATE METHODS
    
    private func setImage() {
        print("cheguei")
        guard let imagePath = viewModel.getComic().imagePath,
              let imageExtension = viewModel.getComic().imageExtension else { return }
        let fullPath = "\(imagePath)/landscape_incredible.\(imageExtension)"
        print(fullPath)
        imageView.sd_setImage(with: URL(string: fullPath))
    }
    
    @objc private func switchChanged(_ sender: UISwitch) {
        sender.isOn ? viewModel.favoriteComic() : viewModel.unfavoriteComic()
    }
}
