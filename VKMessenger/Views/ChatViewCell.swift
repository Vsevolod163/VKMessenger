//
//  ChatViewCell.swift
//  VKMessenger
//
//  Created by Vsevolod Lashin on 16.07.2023.
//

import UIKit

final class ChatViewCell: UITableViewCell {

    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.textColor = .black
        label.numberOfLines = 0

        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews(messageLabel)
        setConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with message: String) {
        messageLabel.textColor = Interface.textColor
        messageLabel.text = message
    }

    private func setConstraints() {
        messageLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate(
            [
                messageLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
                messageLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
                messageLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                messageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)

            ]
        )
    }

    private func setupSubviews(_ subviews: UIView...) {
        subviews.forEach { subview in
            contentView.addSubview(subview)
        }
    }
}
