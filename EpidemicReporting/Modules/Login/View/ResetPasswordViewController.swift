//
//  ResetPasswordViewController.swift
//  EpidemicReporting
//
//  Created by eleven on 2017/12/24.
//  Copyright © 2017年 epidemicreporting.com. All rights reserved.
//

import UIKit

class ResetPasswordViewController: UIViewController {

    @IBOutlet weak var resetPassword: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initUI()
        // Do any additional setup after loading the view.
    }
    
    private func initUI() {
        let usernameImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 36, height: 36))
        usernameImage.image = UIImage(named: "password")
        resetPassword.leftView = usernameImage
        resetPassword.leftViewMode = .always
        resetPassword.attributedPlaceholder = NSAttributedString.init(string:"请输入您的新密码", attributes: [
            NSAttributedStringKey.foregroundColor:UIColor.darkGray])
        
        let passwordImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 36, height: 36))
        passwordImage.image = UIImage(named: "password")
        confirmPassword.leftView = passwordImage
        confirmPassword.leftViewMode = .always
        confirmPassword.attributedPlaceholder = NSAttributedString.init(string:"确认新密码", attributes: [
            NSAttributedStringKey.foregroundColor:UIColor.darkGray])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func resetConfirmAction(_ sender: UIButton) {
        OPLoadingHUD.show(UIImage(named: "loading"), title: "重置中", animated: true, delay: 0.0)
    }
    
    
    @IBAction func cancelResetAction(_ sender: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
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
