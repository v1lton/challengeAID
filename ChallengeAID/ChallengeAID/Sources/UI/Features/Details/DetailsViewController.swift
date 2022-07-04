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
    
    private lazy var imageView: UIImageView = {
        let image = UIImageView(frame: .zero)
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
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
        setImage()
    }
    
    private func buildViewHierarchy() {
        view.addSubview(imageView)
    }
    
    private func constraintUI() {
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    // MARK: - PRIVATE METHODS
    
    private func setImage() {
        print("cheguei")
        guard let imageUrl = viewModel.getComic().images?.first else { return }
        let fullPath = "\(imageUrl.path ?? "")/portrait_fantastic.\(imageUrl.imageExtension ?? "")"
        print(fullPath)
        imageView.sd_setImage(with: URL(string: fullPath))
    }
}
