//
//  EntityTableViewCell.swift
//  ChallengeAID
//
//  Created by Wilton Ramos da Silva on 03/07/22.
//

import UIKit

class EntityTableViewCell: UITableViewCell {
    
    // MARK: - PUBLIC PROPERTIES
    
    public static var reuseIdentifier = "EntityTableViewCell"
    
    // MARK: - UI
    
    private lazy var containerView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var picture: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var title: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byTruncatingMiddle
        label.numberOfLines = 1
        label.textColor = .none
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    private lazy var details: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 5
        label.textColor = .none
        return label
    }()
    
    // MARK: - INITIALIZERS
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupComponents()
        addViewHierarchy()
        constraintUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - PUBLIC METHODS
    
    func setupCell(with model: EntityCellModel) {
        self.title.text = model.title
        self.details.text = model.description
        let fullPath = "\(model.imagePath ?? "")/portrait_fantastic.\(model.imageExtension ?? "")"
        self.picture.sd_setImage(with: URL(string: fullPath)) //TODO: fix it
    }
    
    // MARK: - SETUP
    
    private func setupComponents() {
        containerView.backgroundColor = .systemBackground
    }
    
    private func addViewHierarchy() {
        addSubview(containerView)
        containerView.addSubview(title)
        containerView.addSubview(picture)
        containerView.addSubview(details)
    }
    
    private func constraintUI() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            
            picture.topAnchor.constraint(equalTo: containerView.topAnchor),
            picture.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            picture.heightAnchor.constraint(equalToConstant: 150),
            picture.widthAnchor.constraint(equalToConstant: 100),
            
            title.topAnchor.constraint(equalTo: containerView.topAnchor),
            title.leadingAnchor.constraint(equalTo: picture.trailingAnchor, constant: 8),
            title.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            title.heightAnchor.constraint(equalToConstant: 20),
            
            details.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 8),
            details.leadingAnchor.constraint(equalTo: picture.trailingAnchor, constant: 8),
            details.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])
    }
}
