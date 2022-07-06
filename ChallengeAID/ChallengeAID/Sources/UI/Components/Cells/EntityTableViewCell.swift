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
    
    private lazy var containerStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .top
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var picture: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        return imageView
    }()
    
    private lazy var titleAndDescriptionStackView: UIStackView = {
        let stack = UIStackView(frame: .zero)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 8
        return stack
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
        selectionStyle = .none
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
        let fullPath = "\(model.imagePath ?? "")/portrait_fantastic.\(model.imageExtension ?? "")" //TODO: Improve it
        self.picture.sd_setImage(with: URL(string: fullPath),
                                 placeholderImage: UIImage(named: "portrait_placeholder")) //TODO: fix it
    }
    
    // MARK: - SETUP
    
    private func setupComponents() {
        containerStackView.backgroundColor = .systemBackground
    }
    
    private func addViewHierarchy() {
        addSubview(containerStackView)
        containerStackView.addArrangedSubview(picture)
        containerStackView.addArrangedSubview(titleAndDescriptionStackView)
        titleAndDescriptionStackView.addArrangedSubview(title)
        titleAndDescriptionStackView.addArrangedSubview(details)
    }
    
    private func constraintUI() {
        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            containerStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            containerStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            containerStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
        ])
    }
}
