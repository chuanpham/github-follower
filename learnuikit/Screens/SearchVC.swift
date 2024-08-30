//
//  SearchVC.swift
//  learnuikit
//
//  Created by chuanpham on 16/08/2024.
//

import UIKit

class SearchVC: UIViewController {
    
    let logoImgView = UIImageView()
    let usernameTextField = GFTextField()
    let bottomButton = GFButton(backgroundColor: .systemGreen, title: "Get Followers")
    
    var isUsernameEntered: Bool {
        return !usernameTextField.text!.isEmpty
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configLogoImgView()
        configTextField()
        configBottomButton()
        dismissKeyboard()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func dismissKeyboard() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    @objc func pushFollowerListVC() {
        guard isUsernameEntered else {
                presentGFAlertOnMainThread(title: "Empty Username!", message: "Please enter a username", buttonTitle: "OK")
                return
        }
        let followerListVC = FollowerListVC()
        followerListVC.username = usernameTextField.text
        followerListVC.title = usernameTextField.text
        navigationController?.pushViewController(followerListVC, animated: true)
    }
    
    func configLogoImgView() {
        view.addSubview(logoImgView)
        logoImgView.translatesAutoresizingMaskIntoConstraints = false
        logoImgView.image = UIImage(named: "gh-logo")!
        
        NSLayoutConstraint.activate([
            logoImgView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            logoImgView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImgView.heightAnchor.constraint(equalToConstant: 200),
            logoImgView.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    func configTextField() {
        view.addSubview(usernameTextField)
        usernameTextField.delegate = self
        NSLayoutConstraint.activate([
            usernameTextField.topAnchor.constraint(equalTo: logoImgView.bottomAnchor, constant: 48),
            usernameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            usernameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            usernameTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
        
    }
    
    func configBottomButton() {
        view.addSubview(bottomButton)
        bottomButton.addTarget(self, action: #selector(pushFollowerListVC), for: .touchUpInside)
        NSLayoutConstraint.activate([
            bottomButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            bottomButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            bottomButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            bottomButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

}

extension SearchVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        pushFollowerListVC()
        return true
    }
}
