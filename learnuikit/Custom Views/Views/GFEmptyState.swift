//
//  GFEmptyState.swift
//  learnuikit
//
//  Created by chuanpham on 22/08/2024.
//

import UIKit

class GFEmptyStateView: UIView {
    
    let msgLabel = GFTitleLabel(textAlignment: .center, fontSize: 28)
    let logoImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        config()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(message: String) {
        super.init(frame: .zero)
        msgLabel.text = message
        config()
    }
    
    private func config() {
        addSubview(msgLabel)
        addSubview(logoImageView)
        
        msgLabel.numberOfLines = 3
        msgLabel.textColor = .secondaryLabel
        
        logoImageView.image = UIImage(named: "empty-state-logo")
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            msgLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -150),
            msgLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 40),
            msgLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -40),
            msgLabel.heightAnchor.constraint(equalToConstant: 200),
            
            logoImageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1.3),
            logoImageView.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1.3),
            logoImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 170),
            logoImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 40)
        ])
    }
}
