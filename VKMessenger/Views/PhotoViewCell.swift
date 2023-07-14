//
//  PhotoViewCell.swift
//  WebViewApp
//
//  Created by Vsevolod Lashin on 10.07.2023.
//

import UIKit
import Kingfisher

final class PhotoViewCell: UICollectionViewCell {
    lazy var photoImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(photoImageView)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with photo: String) {
        photoImageView.kf.setImage(with: URL(string: photo))
    }
    
    private func setConstraints() {
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [
                photoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                photoImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                photoImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
                photoImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            ]
        )
    }
}
