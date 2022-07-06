//
//  DetailsViewController.swift
//  ChallengeAID
//
//  Created by Wilton Ramos da Silva on 03/07/22.
//


import RxSwift
import SDWebImage
import UIKit

protocol ComicDetailsViewControllerDelegate: AnyObject {
    func comicsDetailsViewController(didTapCharacter character: CharacterModel)
}

class ComicDetailsViewController: UIViewController {
    
    // MARK: - PRIVATE PROPERTIES
    
    private let viewModel: ComicDetailsViewModelType
    private let disposeBag = DisposeBag()
    private let reuseCustomIdentifier = "EntityTableViewCell"
    private let reuseDefaultIdentifier = "DefaultTableViewCell"
    
    // MARK: - PUBLIC PROPERTIES
    
    weak var delegate: ComicDetailsViewControllerDelegate?
    
    // MARK: - UI
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var imageView: UIImageView = {
        let image = UIImageView(frame: .zero)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "landscape_placeholder")
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
    
    private lazy var favoriteStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var favoriteLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .none
        label.numberOfLines = 1
        label.text = "Favorite"
        label.textAlignment = .right
        return label
    }()
    
    private lazy var favoriteDetailsSwitch: UISwitch = {
        let detailsSwitch = UISwitch()
        detailsSwitch.translatesAutoresizingMaskIntoConstraints = false
        detailsSwitch.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
        detailsSwitch.onTintColor = .systemRed
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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseDefaultIdentifier)
        tableView.register(EntityTableViewCell.self, forCellReuseIdentifier: reuseCustomIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 182
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isScrollEnabled = false
        return tableView
    }()
    
    private lazy var spinner: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.isHidden = true
        return indicator
    }()
    
    // MARK: - LIFE CYCLE
    
    init(viewModel: ComicDetailsViewModelType) {
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
        bindObservables()
        viewModel.retrieveCharacters()
    }
    
    // MARK: - SETUP
    
    private func setupView() {
        view.backgroundColor = .systemBackground
        title = viewModel.getComic().title
    }
    
    private func setupComponents() {
        let model = viewModel.getComic()
        setImage(for: model.getImageUrl())
        detailsTitle.text = model.title
        detailsDescription.text = model.description
        favoriteDetailsSwitch.isOn = model.isFavorite
    }
    
    private func buildViewHierarchy() {
        view.addSubview(scrollView)
        view.addSubview(spinner)
        
        scrollView.addSubview(bodyStackView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(charactersTableView)
        
        bodyStackView.addArrangedSubview(detailsTitle)
        bodyStackView.addArrangedSubview(detailsDescription)
        bodyStackView.addArrangedSubview(favoriteStackView)
        
        favoriteStackView.addArrangedSubview(favoriteLabel)
        favoriteStackView.addArrangedSubview(favoriteDetailsSwitch)
    }
    
    private func constraintUI() {
        NSLayoutConstraint.activate([
            spinner.topAnchor.constraint(equalTo: view.topAnchor),
            spinner.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            spinner.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            spinner.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
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
            charactersTableView.heightAnchor.constraint(equalToConstant: viewModel.getTableViewHeight()),
            charactersTableView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
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
    
    private func handleViewState(_ viewState: ComicDetailsViewState) {
        switch viewState {
        case .loading:
            handleLoading()
        case .success:
            handleContent()
        case .error(let error):
            handleError(error)
        }
    }
    
    private func handleLoading() {
        startScreenLoadingAnimation()
    }
    
    private func handleContent() {
        stopScreenLoadingAnimation()
        charactersTableView.reloadData()
    }
    
    private func startScreenLoadingAnimation() {
        spinner.isHidden = false
        scrollView.isHidden = true
        spinner.startAnimating()
    }
    
    private func stopScreenLoadingAnimation() {
        spinner.stopAnimating()
        spinner.isHidden = true
        scrollView.isHidden = false
        charactersTableView.reloadData()
    }
    
    private func handleError(_ error: Error) {
        charactersTableView.isHidden = true
    }
    
    // MARK: - PRIVATE METHODS
    
    private func setImage(for url: String) {
        guard let url = URL(string: url) else {
            return
        }
        imageView.sd_setImage(with: url)
    }
    
    @objc private func switchChanged(_ sender: UISwitch) {
        sender.isOn ? viewModel.favoriteComic() : viewModel.unfavoriteComic()
    }
    
    private func setupCharacterTableViewCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseCustomIdentifier, for: indexPath) as? EntityTableViewCell else {
            return UITableViewCell()
        }
        let characters = viewModel.getCharacters()
        guard let character = characters?[indexPath.row] else { return cell }
        cell.setupCell(with: .init(title: character.name,
                                   description: character.description,
                                   imagePath: character.imagePath,
                                   imageExtension: character.imageExtension,
                                   isFavorite: false))
        return cell
    }
    
    private func setupCreatorTableViewCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseDefaultIdentifier, for: indexPath)
        let creators = viewModel.getCreators()
        guard let creator = creators?[indexPath.row] else { return cell }
        cell.textLabel?.text = creator.name
        cell.detailTextLabel?.text = creator.role
        return cell
    }
}

extension ComicDetailsViewController: UITableViewDataSource {
    
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
        if indexPath.section == 0 {
            return setupCharacterTableViewCell(tableView, cellForRowAt: indexPath)
        } else {
            return setupCreatorTableViewCell(tableView, cellForRowAt: indexPath)
        }
    }
}

extension ComicDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            guard let character = viewModel.getCharacter(at: indexPath.row) else { return }
            delegate?.comicsDetailsViewController(didTapCharacter: character)
        }
    }
}
