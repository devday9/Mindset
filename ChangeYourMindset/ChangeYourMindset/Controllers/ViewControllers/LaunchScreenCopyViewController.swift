//
//  LaunchScreenCopyViewController.swift
//  ChangeYourMindset
//
//  Created by Deven Day on 10/29/20.
//

import UIKit

class LaunchScreenCopyViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUser()

    }
    
    func fetchUser() {
        UserController.shared.fetchUser { (result) in
            switch result {
            case .success(let user):
                if user != nil {
                    self.presentOverviewVC()
                } else {
                     self.presentSignUpVC()
                }
            case .failure(let error):
                print(error.errorDescription)
                 self.presentSignUpVC()
            }
        }
    }
    
    func presentOverviewVC() {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Overview", bundle: nil)
            guard let viewController = storyboard.instantiateInitialViewController() else { return }
            viewController.modalPresentationStyle = .fullScreen
            self.present(viewController, animated: true)
        }
    }
    
    func presentSignUpVC() {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "SignUp", bundle: nil)
            guard let viewController = storyboard.instantiateInitialViewController() else { return }
            viewController.modalPresentationStyle = .fullScreen
            self.present(viewController, animated: true)
        }
    }
}//END OF CLASS
