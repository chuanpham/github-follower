//
//  GFTextField.swift
//  learnuikit
//
//  Created by chuanpham on 16/08/2024.
//

import UIKit

class GFTextField: UITextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
        config()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func config() {
        layer.cornerRadius = 10
        translatesAutoresizingMaskIntoConstraints = false
        layer.borderWidth = 2
        layer.borderColor = UIColor.systemGray4.cgColor
        textColor = .label
        tintColor = .label
        textAlignment = .center
        font = UIFont.preferredFont(forTextStyle: .title2)
        adjustsFontSizeToFitWidth = true
        minimumFontSize = 12
        backgroundColor = .tertiarySystemBackground
        autocorrectionType = .no
        placeholder = "Input a username"
        returnKeyType = .go
    }
}
