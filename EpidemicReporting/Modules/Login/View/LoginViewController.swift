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
    @IBOutlet weak var alertImage: UIImageView!
    @IBOutlet weak var hintMessage: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initUI()
    }
    
    private func initUI() {
        showHintMessage(false)
        
        let usernameImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        usernameImage.image = UIImage(named: "username")
        username.leftView = usernameImage
        username.leftViewMode = .always
        username.attributedPlaceholder = NSAttributedString.init(string:"请输入您的账户", attributes: [
            NSAttributedStringKey.foregroundColor:UIColor.darkGray])
        username.delegate = self
        
        let passwordImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 36, height: 36))
        passwordImage.image = UIImage(named: "password")
        password.leftView = passwordImage
        password.leftViewMode = .always
        password.attributedPlaceholder = NSAttributedString.init(string:"请输入您的密码", attributes: [
            NSAttributedStringKey.foregroundColor:UIColor.darkGray])
        password.delegate = self
        
        UIApplication.shared.statusBarStyle = .default
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginAction(_ sender: UIButton) {
        
        username.text = "admin001"
        password.text = "123456"

        if (checkUsernamePassword()) {
            showHintMessage(false)
            OPLoadingHUD.show(UIImage(named: "loading"), title: "登录中", animated: true, delay: 0.0)
            guard let user = username.text, let password = password.text else { return }
            DataService.sharedInstance.userLogin(user, pwd: password) { [weak self](success, error) in
                if !success {
                    //TODO: network error
                    self?.hintMessage.text = "用户名或者密码错误"
                    self?.showHintMessage(true)
                } else {
                    self?.loginSuccess()
                }
                OPLoadingHUD.hide()
            }
        } else {
            showHintMessage(true)
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
    
    
    private func checkUsernamePassword() -> Bool {
        var errorCount = 0
        closeKeyboard()
        if username.text == "" || username.text == nil {
            hintMessage.text = "请输入您的用户名"
            errorCount += 1
        }
        if password.text == "" || password.text == nil {
            hintMessage.text = "请输入您的密码"
            errorCount += 1
        }
        if errorCount == 2 {
            hintMessage.text = "请输入您的用户名和密码"
            return false
        }
        
        if errorCount == 0 {
            return true
        }
        return false
    }
    
    func closeKeyboard() {
        if username.isFirstResponder {
            username.resignFirstResponder()
        }
        
        if password.isFirstResponder {
            password.resignFirstResponder()
        }
    }
    
    func showHintMessage(_ isShow: Bool) {
        if isShow {
            alertImage.isHidden = false
            hintMessage.isHidden = false
        } else {
            alertImage.isHidden = true
            hintMessage.isHidden = true
        }
    }
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        showHintMessage(false)
    }
}
