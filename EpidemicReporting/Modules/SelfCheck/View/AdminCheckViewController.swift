//
//  AdminCheckViewController.swift
//  EpidemicReporting
//
//  Created by IBM on 03/02/2018.
//  Copyright © 2018 epidemicreporting.com. All rights reserved.
//

import UIKit
import CoreData
import SwiftyJSON

class AdminCheckViewController: CoreDataTableViewController {
    
    @IBOutlet weak var totalNum: UILabel!
    
    fileprivate var data = [JSON]() {
        didSet {
            totalNum.text =  "今日已经有\(data.count)人签到"
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.setStyledNavigationBar()
        navigationItem.title = "管理员"
        initUI()
        totalNum.text =  "今日已经有 - 人签到"

        DataService.sharedInstance.getDayChekInNumberJSON { [weak self] (success, json, error)  in
            guard let json = json, let jsonData = json["data"].array else { return }
            var result = [JSON]()
            for data in jsonData {
                if let _ = data["latitude"].string {
                    result.append(data)
                }
            }
            self?.data = result
        }
    }
    
    func initUI() {
        let rightFilterItemblank = UIBarButtonItem.createBarButtonItemWithText("", CGRect(x: 0, y: 0, width: 4, height: 24), self, #selector(profilePress), UIColor.white, 4)
        guard let profileImage = UIImage(named: "profile") else { return }
        let rightProfileItem = UIBarButtonItem.createBarButtonItemWithImage(profileImage, CGRect(x: 0, y: 0, width: 24, height: 24), self, #selector(profilePress))
        navigationItem.rightBarButtonItems = [rightFilterItemblank,rightProfileItem]
        
        let foot = UIView()
        tableView.tableFooterView = foot
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func profilePress() {
        let stroryboard = UIStoryboard.init(name: "Profile", bundle: nil)
        if let profileNav = stroryboard.instantiateInitialViewController() as? UINavigationController {
            present(profileNav, animated: true, completion: nil)
        }
    }
}

extension AdminCheckViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "checkCell") as? CheckTableViewCell
        let userData = data[indexPath.row]
        guard let checkCell = cell else { return UITableViewCell() }
        var date: NSDate?
        if let time = userData["date"].double {
            date = NSDate.init(timeIntervalSince1970: time)
        }
        checkCell.updateDataSource(userData["name"].string, checkTime: date, checkLocation: userData["location"].string)
        
        return checkCell
    }
}
