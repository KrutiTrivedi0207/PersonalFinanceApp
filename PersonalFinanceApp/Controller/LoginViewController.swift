//
//  LoginViewController.swift
//  PersonalFinanceApp
//
//  Created by Kruti Trivedi on 20/06/24.
//

import UIKit
import GoogleSignIn

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupGoogleSignInButton()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func setupGoogleSignInButton() {
        let signInButton = GIDSignInButton()
        signInButton.center = view.center
        signInButton.addTarget(self, action: #selector(self.GoogleSignInTapping(_:)), for: .touchUpInside)
        view.addSubview(signInButton)
    }
    
    @objc func GoogleSignInTapping(_ sender: GIDSignInButton) {
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { signInResult, error in
            if let error = error {
                print("Error signing in: \(error.localizedDescription)")
                return
            }
            
            guard let profile = signInResult?.user.profile else { return }
            let name = profile.name
            let email = profile.email
            
            UserDefaults.standard.setValue(name, forKey: "userName")
            UserDefaults.standard.setValue(email, forKey: "userEmail")

            AppDelegate().sharedInstance().goto(isLogin: true)
        }
    }


}
