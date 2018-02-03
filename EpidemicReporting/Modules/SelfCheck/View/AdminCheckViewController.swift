//
//  AdminCheckViewController.swift
//  EpidemicReporting
//
//  Created by IBM on 03/02/2018.
//  Copyright © 2018 epidemicreporting.com. All rights reserved.
//

import UIKit
import CoreData

class AdminCheckViewController: CoreDataTableViewController {
    
    @IBOutlet weak var totalNum: UILabel!
    
    lazy var setup: () = {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Check")
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
        request.predicate = NSPredicate(format: "createTime != nil")
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: appDelegate.dataStack.mainContext, sectionNameKeyPath: nil, cacheName: nil)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.setStyledNavigationBar()
        navigationItem.title = "管理员签到管理"
        initUI()
        let _ = setup
        // Do any additional setup after loading the view.
        
        DataService.sharedInstance.getMyCheckIn { [weak self](success, error) in
            guard let number = self?.fetchedResultsController?.fetchedObjects?.count.description else { return }
            self?.totalNum.text =  "今日签到人数：" + number
            self?.tableView.reloadData()
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "checkCell") as? CheckTableViewCell
        guard let checkCell = cell else { return UITableViewCell() }
        if let data = fetchedResultsController?.fetchedObjects?[indexPath.item] as? Check {
            cell?.updateDataSource(data.username, checkTime: data.createTime, checkLocation: data.location)
        }
        
        return checkCell
    }
}
