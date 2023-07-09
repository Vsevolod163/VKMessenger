//
//  GroupViewCell.swift
//  WebViewApp
//
//  Created by Vsevolod Lashin on 10.07.2023.
//

import UIKit
import Kingfisher

final class GroupViewCell: UITableViewCell {
    private lazy var groupImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 10
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private lazy var groupNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .white
        
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .white
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews(groupImageView, groupNameLabel, descriptionLabel)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with group: Group) {
        groupNameLabel.text = group.name
        descriptionLabel.text = group.description
        groupImageView.kf.setImage(with: URL(string: group.photoOneHundred))
    }
    
    private func setConstraints() {
        groupImageView.translatesAutoresizingMaskIntoConstraints = false
        groupNameLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate(
            [
                groupImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
                groupImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
                groupImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                groupImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.3),
                
                groupNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
                groupNameLabel.leadingAnchor.constraint(equalTo: groupImageView.trailingAnchor, constant: 8),
                groupNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                
                descriptionLabel.topAnchor.constraint(equalTo: groupNameLabel.bottomAnchor, constant: 8),
                descriptionLabel.leadingAnchor.constraint(equalTo: groupImageView.trailingAnchor, constant: 8),
                descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
            ]
        )
    }
    
    private func setupSubviews(_ subviews: UIView...) {
        subviews.forEach { subview in
            contentView.addSubview(subview)
        }
    }
}
