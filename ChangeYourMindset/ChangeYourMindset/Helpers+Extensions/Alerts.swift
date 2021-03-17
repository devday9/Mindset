//
//  Alerts.swift
//  ChangeYourMindset
//
//  Created by Deven Day on 1/12/21.
//

import UIKit

//MARK: - SignUpLoginViewController
extension SignUpLoginViewController {
    
    func alertUserLoginError() {
        let loginError = UIAlertController(title: "Error Logging In", message: "Please enter all information to log in.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        
        loginError.addAction(okAction)
        present(loginError, animated: true)
    }
    
    func alertIncorrectPasswordOrEmail() {
        let loginError = UIAlertController(title: "Error Logging In", message: "Email or password is incorrect.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        
        loginError.addAction(okAction)
        present(loginError, animated: true)
    }
    
    struct SignUpAlertStrings {
        static let passwordMatchKey = "Passwords must match."
        static let passwordCharacterCountKey = "Password must be at least 6 characters."
    }
    
    func alertUserSignUpError() {
        let signUpError = UIAlertController(title: "Error Signing Up", message: SignUpAlertMessage,
                                            preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        
        signUpError.addAction(okAction)
        present(signUpError, animated: true)
    }
}//END OF EXTENSION

//MARK: - OverviewVC
extension OverviewViewController {
    
    func deleteProgress() {
        let actionSheet = UIAlertController(title: "HOLD UP!!!", message: "Are you sure you want to DELETE your progress?", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Delete Progress", style: .destructive,
                                            handler: { [weak self] _ in
                                                guard let strongSelf = self else { return }
                                                
//                                                ChallengeController.shared.clearAllData(<#T##days: Day##Day#>) { (result) in
//                                                    switch result {
//                                                    case .success():
//                                                        let storyboard = UIStoryboard(name: "Overview", bundle: nil)
//                                                    case .failure(_):
//                                                        let actionSheet = UIAlertController(title: "ERROR", message: "Not able to reset progress at this time", preferredStyle: .alert)
//                                                        let okayAction = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
//                                                    }
//                                                }
                                                
                                            }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(actionSheet, animated: true)
    }
    
    
}//END OF EXTENSION


