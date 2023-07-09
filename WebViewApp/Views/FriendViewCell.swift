//
//  FriendViewCell.swift
//  WebViewApp
//
//  Created by Vsevolod Lashin on 10.07.2023.
//

import UIKit
import Kingfisher

final class FriendViewCell: UITableViewCell {
    private lazy var friendImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private lazy var fullNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        
        return label
    }()
    
    private lazy var cityLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
        
        return label
    }()
    
    private lazy var onlineStatusLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews(friendImageView, fullNameLabel, cityLabel, onlineStatusLabel)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with item: Item) {
        fullNameLabel.text = "\(item.firstName) \(item.lastName)"
        cityLabel.text = item.city?.title
        if item.online == 1 {
            onlineStatusLabel.textColor = .systemGreen
            onlineStatusLabel.text = "Online"
        } else {
            onlineStatusLabel.textColor = .systemRed
            onlineStatusLabel.text = "Offline"
        }
        friendImageView.kf.setImage(with: URL(string: item.photoOneHundred))
    }
    
    private func setConstraints() {
        friendImageView.translatesAutoresizingMaskIntoConstraints = false
        fullNameLabel.translatesAutoresizingMaskIntoConstraints = false
        cityLabel.translatesAutoresizingMaskIntoConstraints = false
        onlineStatusLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate(
            [
                friendImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
                friendImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
                friendImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                friendImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.3),
                
                fullNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
                fullNameLabel.leadingAnchor.constraint(equalTo: friendImageView.trailingAnchor, constant: 8),
                fullNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                
                cityLabel.topAnchor.constraint(equalTo: fullNameLabel.bottomAnchor, constant: 8),
                cityLabel.leadingAnchor.constraint(equalTo: friendImageView.trailingAnchor, constant: 8),
                cityLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                
                onlineStatusLabel.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 8),
                onlineStatusLabel.leadingAnchor.constraint(equalTo: friendImageView.trailingAnchor, constant: 8),
                onlineStatusLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
                
            ]
        )
    }
    
    private func setupSubviews(_ subviews: UIView...) {
        subviews.forEach { subview in
            contentView.addSubview(subview)
        }
    }
}
