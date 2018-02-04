//
//  ProfileViewController.swift
//  EpidemicReporting
//
//  Created by IBM on 30/01/2018.
//  Copyright © 2018 epidemicreporting.com. All rights reserved.
//

import UIKit

class ProfileViewController: UITableViewController {

    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var role: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setStyledNavigationBar()
        initUI()
        // Do any additional setup after loading the view.
    }
    
    func initUI() {
        let rightFilterItemblank = UIBarButtonItem.createBarButtonItemWithText("", CGRect(x: 0, y: 0, width: 0, height: 24), self, #selector(closeVC), UIColor.white, 2)
        guard let profileImage = UIImage(named: "close_x") else { return }
        let rightProfileItem = UIBarButtonItem.createBarButtonItemWithImage(profileImage, CGRect(x: 0, y: 0, width: 24, height: 24), self, #selector(closeVC))
        navigationItem.rightBarButtonItems = [rightFilterItemblank,rightProfileItem]
        
        let view = UIView()
        tableView.tableFooterView = view
        
        name.text = appDelegate.currentUser?.name
        if appDelegate.currentUser?.role == RoleType.admin.rawValue {
            role.text = "角色：管理员"
        } else {
            role.text = "角色：疫情上报人员"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @objc func closeVC() {
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

extension ProfileViewController {
    
     override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true, completion: nil)
        let loginVC = UIStoryboard(name: "LoginStoryboard", bundle: nil).instantiateInitialViewController() as? LoginViewController
        appDelegate.window?.rootViewController = loginVC
    }
}
