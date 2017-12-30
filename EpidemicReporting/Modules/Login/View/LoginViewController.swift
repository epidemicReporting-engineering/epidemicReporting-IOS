//
//  LoginViewController.swift
//  EpidemicReporting
//
//  Created by eleven on 2017/12/24.
//  Copyright © 2017年 epidemicreporting.com. All rights reserved.
//

import UIKit
import CoreData

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initUI()
    }
    
    private func initUI() {
        let usernameImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        usernameImage.image = UIImage(named: "username")
        username.leftView = usernameImage
        username.leftViewMode = .always
        username.attributedPlaceholder = NSAttributedString.init(string:"请输入您的账户", attributes: [
            NSAttributedStringKey.foregroundColor:UIColor.darkGray])
        
        let passwordImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 36, height: 36))
        passwordImage.image = UIImage(named: "password")
        password.leftView = passwordImage
        password.leftViewMode = .always
        password.attributedPlaceholder = NSAttributedString.init(string:"请输入您的密码", attributes: [
            NSAttributedStringKey.foregroundColor:UIColor.darkGray])
        
        UIApplication.shared.statusBarStyle = .default
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginAction(_ sender: UIButton) {
        //mock up
        username.text = "user001"
        password.text = "123456"
        
        OPLoadingHUD.show(UIImage(named: "loading"), title: "登录中", animated: true, delay: 0.0)
        guard let user = username.text, let password = password.text else { return }
        DataService.sharedInstance.userLogin(user, pwd: password) { [weak self](success, error) in
            if error != nil {
                
            } else {
                self?.loginSuccess()
            }
            OPLoadingHUD.hide()
        }
    }
    
    @IBAction func resetPasswordAction(_ sender: UIButton) {
        if let resetPasswordVC = UIStoryboard.init(name: "LoginStoryboard", bundle: nil).instantiateViewController(withIdentifier: "resetPasswordVC") as? ResetPasswordViewController {
            present(resetPasswordVC, animated: true, completion: nil)
        }
        
    }
    
    func loginSuccess() {
        guard let user = username.text else { return }
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        request.sortDescriptors = [NSSortDescriptor(key: "username", ascending: true)]
        request.predicate = NSPredicate(format: "username == %@", user)
        let users = ((try! appDelegate.dataStack.mainContext.fetch(request)) as? [User])
        guard let coreuser = users?.first else { return }
        appDelegate.currentUser = coreuser
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "LoginSuccess"), object: nil)
//        guard let username = loginUsername.text else { return }
//        UserDefaults.standard.setValue(username, forKey: "last_logined_user")
        dismiss(animated: true, completion: nil)
    }
    
    
//    private func checkUsernamePassword() -> Bool {
//        var errorCount = 0
//        closeKeyboard()
//        if pageStatus == .signIn {
//            if loginUsername.text == "" || loginUsername.text == nil {
//                hitMessage = "Please input your email address or phone number"
//                errorCount += 1
//            }
//            if loginPassword.text == "" || loginPassword.text == nil {
//                hitMessage = "Please input your password"
//                errorCount += 1
//            }
//            if errorCount == 2 {
//                hitMessage = "Please input your email address and password"
//                return false
//            }
//
//            guard let username = loginUsername.text else { return false }
//            if (username.EmailIsValidated() || username.PhoneNumberIsValidated()) && errorCount == 0 {
//                return true
//            } else {
//                hitMessage = "Please input valid phone number or password"
//                return false
//            }
//        } else {
//            if pageStatus == .signUp {
//                if mobilePhoneTextField.text == "" || mobilePhoneTextField.text == nil {
//                    hitMessage = "Please input your email address or phone number"
//                    errorCount += 1
//                }
//                if securityCodeTextField.text == "" || securityCodeTextField.text == nil {
//                    hitMessage = "Please input your security code"
//                    errorCount += 1
//                }
//                if passwordTextField.text == "" || passwordTextField.text == nil {
//                    hitMessage = "Please input your password"
//                    errorCount += 1
//                }
//                if errorCount == 3 {
//                    hitMessage = "Please input your user name, email address and password"
//                    return false
//                }
//                guard let username = mobilePhoneTextField.text else { return false }
//                if (username.EmailIsValidated() || username.PhoneNumberIsValidated()) && errorCount == 0 {
//                    return true
//                } else {
//                    hitMessage = "Please input valid phone number or password"
//                    return false
//                }
//            }
//        }
//        return false
//    }
    
    func closeKeyboard() {
        if username.isFirstResponder {
            username.resignFirstResponder()
        }
        
        if password.isFirstResponder {
            password.resignFirstResponder()
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
