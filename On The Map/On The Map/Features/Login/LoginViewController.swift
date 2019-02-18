//
//  LoginViewController.swift
//  On The Map
//
//  Created by Filipi Brentegani on 17/02/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    // MARK: - Constants
    
    // MARK: - Enums
    
    // MARK: - Properties
    @IBOutlet private weak var emailTextField: UITextField?
    @IBOutlet private weak var passwordTextField: UITextField?
    @IBOutlet private weak var loginButton: UIButton?
    @IBOutlet private weak var loadingView: UIActivityIndicatorView? {
        didSet {
            loadingView?.isHidden = true
        }
    }
    
    private let loginBusiness = LoginBusiness()
    
    // MARK: - Initializers
    
    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Actions
    @IBAction func loginAction(_ sender: Any) {
        showLoading()
        loginBusiness.requestLogin(email: emailTextField?.text ?? "", password: passwordTextField?.text ?? "") { [weak self] response in
            self?.hideLoading()
            do {
                let loginResponse = try response()
                print("success: \(loginResponse)")
                //TODO go to next screen
            } catch {
                print("error: \(error)")
                //TODO show error
            }
        }
    }
    
    // MARK: - Public methods
    
    // MARK: - Private methods
    private func showLoading() {
        loadingView?.isHidden = false
        loginButton?.setTitle("",for: .normal)
    }
    
    private func hideLoading() {
        loadingView?.isHidden = true
        loginButton?.setTitle("Login",for: .normal)
    }
    
    // MARK: - Deinitializers
    
    // MARK: - Extensions
    
}
