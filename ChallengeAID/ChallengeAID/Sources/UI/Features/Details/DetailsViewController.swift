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
    private let reuseIdentifier = "TableViewCell"
    
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
    
    private lazy var charactersTableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        return tableView
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
        view.backgroundColor = .systemBackground
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
        scrollView.addSubview(charactersTableView)
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
            bodyStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            charactersTableView.topAnchor.constraint(equalTo: bodyStackView.bottomAnchor, constant: 16),
            charactersTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            charactersTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            charactersTableView.heightAnchor.constraint(equalToConstant: CGFloat(viewModel.getTableViewCount() * 50)),
            charactersTableView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
    }
    
    // MARK: - PRIVATE METHODS
    
    private func setImage() {
        guard let imagePath = viewModel.getComic().imagePath,
              let imageExtension = viewModel.getComic().imageExtension else { return }
        let fullPath = "\(imagePath)/landscape_incredible.\(imageExtension)" //TODO: Improve it
        imageView.sd_setImage(with: URL(string: fullPath))
    }
    
    @objc private func switchChanged(_ sender: UISwitch) {
        sender.isOn ? viewModel.favoriteComic() : viewModel.unfavoriteComic()
    }
}

extension DetailsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Characters"
        } else {
            return "Creators"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return viewModel.getCharacters()?.count ?? 0
        } else {
            return viewModel.getComic().creators?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        
        if indexPath.section == 0 {
            let characters = viewModel.getCharacters()
            guard let character = characters?[indexPath.row] else { return cell }
            cell.textLabel?.text = character.name
            cell.detailTextLabel?.text = character.role
        } else {
            let creators = viewModel.getCreators()
            guard let creator = creators?[indexPath.row] else { return cell }
            cell.textLabel?.text = creator.name
            cell.detailTextLabel?.text = creator.role
        }
        
        return cell
    }
}

extension DetailsViewController: UITableViewDelegate {
    
}
