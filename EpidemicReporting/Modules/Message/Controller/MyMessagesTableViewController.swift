//
//  MyReportsTableViewController.swift
//  EpidemicReporting
//
//  Created by IBM on 30/12/2017.
//  Copyright © 2017 epidemicreporting.com. All rights reserved.
//

import UIKit
import CoreData
import AssetsPickerViewController
import Photos

class MyMessagesTableViewController: CoreDataTableViewController {
    
    fileprivate var assetsPickerVC: AssetsPickerViewController?
    fileprivate var assets = [PHAsset]()
    fileprivate var pickerConfig = AssetsPickerConfig()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        intiUI()
        initTableView()
        _ = setup
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DataService.sharedInstance.getAllReports(PullDataType.LOAD.rawValue, filter: nil, param: nil) { [weak self](success, error) in
            if let tabItems = self?.tabBarController?.tabBar.items as NSArray!{
                let tabItem = tabItems[2] as! UITabBarItem
                tabItem.badgeValue = "1"
                
            }
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initTableView() {
        let footview = UIView()
        tableView.tableFooterView = footview
        
        let nib = UINib.init(nibName: "MyMessageTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "MyMessageTableViewCell")
    }
    
    func intiUI() {
        navigationController?.setStyledNavigationBar()
        navigationItem.title = "我的消息"
    }
    
    @objc func accessAssets() {
        
    }
    
    lazy var setup: () = {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "DutyReport")
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
        guard let userid = appDelegate.currentUser?.username else { return }
        request.predicate = NSPredicate(format: "dutyOwner == %@", userid)
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: appDelegate.dataStack.mainContext, sectionNameKeyPath: nil, cacheName: nil)
    }()
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyMessageTableViewCell", for: indexPath) as? MyMessageTableViewCell
        guard let dataCell = cell else { return UITableViewCell()}
        let data = self.fetchedResultsController?.object(at: indexPath) as? DutyReport
        cell?.updateDataSource(data)
        return dataCell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = self.fetchedResultsController?.object(at: indexPath) as? DutyReport
        let storyboard = UIStoryboard(name: "Report", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "DutyDetailsTableViewController") as? DutyDetailsTableViewController {
            vc.reportId = cell?.id
            navigationController?.pushViewController(vc, animated: true)
        }
          tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let duty = fetchedResultsController?.object(at: indexPath) as? DutyReport
        guard let status = duty?.dutyStatus else { return false }
        if status == DutyStatus.CANTDO.rawValue || status == DutyStatus.FINISH.rawValue || status == DutyStatus.SUCCESS.rawValue {
            return false
        } else {
            return true
        }
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let duty = fetchedResultsController?.object(at: indexPath) as? DutyReport
        return actionButtonDecider(duty)
    }
    
    func actionButtonDecider(_ report: DutyReport?) -> [UITableViewRowAction]? {
        var actions:[UITableViewRowAction]? = [UITableViewRowAction]()
        guard let status = report?.dutyStatus else { return nil }
        switch status {
        case DutyStatus.UNASSIGN.rawValue:
            let assign = UITableViewRowAction(style: .normal, title: "分配") { [weak self](action, indexPath) in
                //TODO: send the status
                DataService.sharedInstance.getStuff(handler: { (success, error) in
                    print("get stuff")
                })
            }
            assign.backgroundColor = UIColor(hexString: themeBlue)
            actions?.append(assign)
        case DutyStatus.ASSIGNED.rawValue:
            let start = UITableViewRowAction(style: .normal, title: "开始") { (action, indexPath) in
                //TODO: send the status
            }
            start.backgroundColor = UIColor(hexString: themeBlue)
            actions?.append(start)
            let cantdo = UITableViewRowAction(style: .normal, title: "不能做") { (action, indexPath) in
                //TODO: send the status
            }
            cantdo.backgroundColor = UIColor.init(hexString: canndoGray)
            actions?.append(cantdo)
            let block = UITableViewRowAction(style: .normal, title: "有问题") { (action, indexPath) in
                //TODO: send the status
            }
            block.backgroundColor = UIColor.init(hexString: blockRed)
            actions?.append(block)
        case DutyStatus.START.rawValue:
            let block = UITableViewRowAction(style: .normal, title: "有问题") { (action, indexPath) in
                //TODO: send the status
            }
            block.backgroundColor = UIColor.init(hexString: blockRed)
            let cantdo = UITableViewRowAction(style: .normal, title: "不能做") { (action, indexPath) in
                //TODO: send the status
            }
            cantdo.backgroundColor = UIColor.init(hexString: canndoGray)
            let finish = UITableViewRowAction(style: .normal, title: "结束") { (action, indexPath) in
                //TODO: send the status
            }
            finish.backgroundColor = UIColor.init(hexString: finishGreen)
            actions?.append(finish)
            actions?.append(block)
            actions?.append(cantdo)
        case DutyStatus.BLOCK.rawValue:
            let start = UITableViewRowAction(style: .normal, title: "开始") { (action, indexPath) in
                //TODO: send the status
            }
            start.backgroundColor = UIColor(hexString: themeBlue)
            let cantdo = UITableViewRowAction(style: .normal, title: "不能做") { (action, indexPath) in
                //TODO: send the status
            }
            cantdo.backgroundColor = UIColor.init(hexString: canndoGray)
            actions?.append(start)
            actions?.append(cantdo)
        default:
            break
        }
        return actions
    }
    
    func showAssetViewController (_ indexPath: IndexPath) {
        let report = self.fetchedResultsController?.object(at: indexPath) as? DutyReport
    }
}
