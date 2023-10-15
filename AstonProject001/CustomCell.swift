//
//  CustomCell.swift
//  AstonProject001
//
//  Created by Георгий Евсеев on 25.09.23.
//

import UIKit

final class CustomCell: UITableViewCell {
    
    static var identifier: String {
        return String(describing: self)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    let userNameLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(codr:) has not been impltmtnted")
    }

    
    func configureView(_ itemModel: Player) {
        userNameLabel.text = "\(itemModel.name) - \(itemModel.score)"

    }
}

private extension CustomCell {
    
    
    func setup() {
        setupViews()
        addViews()
        makeConstraints()
    }
    
    func addViews() {
        contentView.addSubview(userNameLabel)
    }
    
    func makeConstraints() {
    userNameLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
    userNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
    userNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
    userNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
    userNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
    ])
    }
    
    func setupViews() {
        userNameLabel.numberOfLines = 0
    }
}
