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
    fileprivate var currentStatus:DutyStatus = .UNASSIGN
    fileprivate var dutyNumber: Int64? = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        intiUI()
        initTableView()
        _ = setup
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        DataService.sharedInstance.getAllReports(PullDataType.LOAD.rawValue, filter: nil, param: nil) { [weak self](success, error) in
            if let tabItems = self?.tabBarController?.tabBar.items as NSArray!{
                let tabItem = tabItems[2] as! UITabBarItem
                if let count = self?.fetchedResultsController?.fetchedObjects?.count {
                    if count > 0 {
                        tabItem.badgeValue = count.description
                    }
                }
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
        
        //add refresh controller
        self.refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refeshDataAll), for: .valueChanged)
        refreshControl?.attributedTitle = NSAttributedString(string: "下拉刷新数据")
    }
    
    func intiUI() {
        navigationController?.setStyledNavigationBar()
        navigationItem.title = "我的消息"
    }
    
    @objc func refeshDataAll(){
        DataService.sharedInstance.getAllReports(PullDataType.LOAD.rawValue, filter: nil, param: nil) { [weak self](success, error) in
            self?.refreshControl?.endRefreshing()
        }
    }
    
    @objc func accessAssets() {
        
    }
    
    lazy var setup: () = {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "DutyReport")
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
        guard let userid = appDelegate.currentUser?.username, let role = appDelegate.currentUser?.role else { return }
        if role == RoleType.staff.rawValue {
            request.predicate = NSPredicate(format: "dutyOwner == %@", userid)
        } else {
            request.predicate = NSPredicate(format: "dutyStatus IN {'0','4','6'}")
        }
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
        guard let status = duty?.dutyStatus, let role = appDelegate.currentUser?.role else { return false }
        if role == RoleType.staff.rawValue {
            if status == DutyStatus.CANTDO.rawValue || status == DutyStatus.FINISH.rawValue || status == DutyStatus.SUCCESS.rawValue {
                return false
            } else {
                return true
            }
        } else {
            if status == DutyStatus.CANTDO.rawValue || status == DutyStatus.FINISH.rawValue || status == DutyStatus.UNASSIGN.rawValue {
                return true
            } else {
                return false
            }
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
                let sb = UIStoryboard.init(name: "ReportList", bundle: nil)
                if let vc = sb.instantiateViewController(withIdentifier: "AvailableLocationsViewController") as? AvailableLocationsViewController {
                    vc.duty = report
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            }
            assign.backgroundColor = UIColor(hexString: themeBlue)
            actions?.append(assign)
        case DutyStatus.CANTDO.rawValue:
            let assign = UITableViewRowAction(style: .normal, title: "分配") { [weak self](action, indexPath) in
                let sb = UIStoryboard.init(name: "ReportList", bundle: nil)
                if let vc = sb.instantiateViewController(withIdentifier: "AvailableLocationsViewController") as? AvailableLocationsViewController {
                    vc.duty = report
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            }
            assign.backgroundColor = UIColor(hexString: themeBlue)
            actions?.append(assign)
        case DutyStatus.ASSIGNED.rawValue:
            let start = UITableViewRowAction(style: .normal, title: "开始") { (action, indexPath) in
                DataService.sharedInstance.reportProcess(report?.id.description, dutyOwner: appDelegate.currentUser?.username, dutyDescription: "开始处理疫情", dutyStatus: DutyStatus.START.rawValue, dutyMultiMedia: nil) { [weak self](success, error) in
                    if success {
                        OPLoadingHUD.show(UIImage.init(named: "success"), title: "开始处理", animated: false, delay: 2)
                        self?.refeshDataAll()
                    } else {
                        OPLoadingHUD.show(UIImage.init(named: "block"), title: "请求错误", animated: false, delay: 2)
                    }
                }
            }
            start.backgroundColor = UIColor(hexString: themeBlue)
            actions?.append(start)
            let cantdo = UITableViewRowAction(style: .normal, title: "无法做") { [weak self](action, indexPath) in
                self?.currentStatus = .CANTDO
                self?.dutyNumber = report?.id
                self?.showAccessPicker()
            }
            cantdo.backgroundColor = UIColor.init(hexString: canndoGray)
            actions?.append(cantdo)
            let block = UITableViewRowAction(style: .normal, title: "有困难") { [weak self](action, indexPath) in
                self?.currentStatus = .BLOCK
                self?.dutyNumber = report?.id
                self?.showAccessPicker()
            }
            block.backgroundColor = UIColor.init(hexString: blockRed)
            actions?.append(block)
        case DutyStatus.START.rawValue:
            let block = UITableViewRowAction(style: .normal, title: "有困难") { [weak self](action, indexPath) in
                self?.currentStatus = .BLOCK
                self?.dutyNumber = report?.id
                self?.showAccessPicker()
            }
            block.backgroundColor = UIColor.init(hexString: blockRed)
            let cantdo = UITableViewRowAction(style: .normal, title: "无法做") { [weak self](action, indexPath) in
                self?.currentStatus = .CANTDO
                self?.dutyNumber = report?.id
                self?.showAccessPicker()
            }
            cantdo.backgroundColor = UIColor.init(hexString: canndoGray)
            let finish = UITableViewRowAction(style: .normal, title: "结束") { [weak self](action, indexPath) in
                self?.currentStatus = .FINISH
                self?.dutyNumber = report?.id
                self?.showAccessPicker()
            }
            finish.backgroundColor = UIColor.init(hexString: finishGreen)
            actions?.append(finish)
            actions?.append(block)
            actions?.append(cantdo)
        case DutyStatus.BLOCK.rawValue:
            let start = UITableViewRowAction(style: .normal, title: "开始") { (action, indexPath) in
                DataService.sharedInstance.reportProcess(report?.id.description, dutyOwner: appDelegate.currentUser?.username, dutyDescription: "开始处理疫情", dutyStatus: DutyStatus.START.rawValue, dutyMultiMedia: nil) { [weak self](success, error) in
                    if success {
                        OPLoadingHUD.show(UIImage.init(named: "success"), title: "开始处理", animated: false, delay: 2)
                        self?.refeshDataAll()
                    } else {
                        OPLoadingHUD.show(UIImage.init(named: "block"), title: "请求错误", animated: false, delay: 2)
                    }
                }
            }
            start.backgroundColor = UIColor(hexString: themeBlue)
            let cantdo = UITableViewRowAction(style: .normal, title: "无法做") { [weak self](action, indexPath) in
                self?.currentStatus = .CANTDO
                self?.dutyNumber = report?.id
                self?.showAccessPicker()
            }
            cantdo.backgroundColor = UIColor.init(hexString: canndoGray)
            actions?.append(start)
            actions?.append(cantdo)
        case DutyStatus.FINISH.rawValue:
            let confirm = UITableViewRowAction(style: .normal, title: "评审") { [weak self](action, indexPath) in
                self?.currentStatus = .SUCCESS
                self?.dutyNumber = report?.id
                self?.showAccessPicker()
            }
            actions?.append(confirm)
        default:
            break
        }
        return actions
    }
    
    func showAccessPicker() {
        pickerConfig.selectedAssets = self.assets
        pickerConfig.albumIsShowHiddenAlbum = true
        assetsPickerVC = AssetsPickerViewController()
        assetsPickerVC?.pickerDelegate = self
        guard let vc = assetsPickerVC else { return }
        present(vc, animated: true, completion: nil)
    }
}

extension MyMessagesTableViewController: AssetsPickerViewControllerDelegate {
    
    func assetsPickerCannotAccessPhotoLibrary(controller: AssetsPickerViewController) {
        
    }
    
    func assetsPickerDidCancel(controller: AssetsPickerViewController) {
        
    }
    
    func assetsPicker(controller: AssetsPickerViewController, selected assets: [PHAsset]) {
        // do your job with selected assets
        self.assets = assets
        let sendStoryboard = UIStoryboard.init(name: "Report", bundle: nil)
        if let nav = sendStoryboard.instantiateViewController(withIdentifier: "sendReportNav") as? UINavigationController, let reportVc  = nav.childViewControllers.first as? AssetsViewController {
            reportVc.type = currentStatus
            reportVc.assets = self.assets
            reportVc.dutyID = self.dutyNumber
            present(nav, animated: true, completion: nil)
        }
    }
    func assetsPicker(controller: AssetsPickerViewController, shouldSelect asset: PHAsset, at indexPath: IndexPath) -> Bool {
        return true
    }
    
    func assetsPicker(controller: AssetsPickerViewController, didSelect asset: PHAsset, at indexPath: IndexPath) {
        
    }
    
    func assetsPicker(controller: AssetsPickerViewController, shouldDeselect asset: PHAsset, at indexPath: IndexPath) -> Bool {
        return true
    }
    func assetsPicker(controller: AssetsPickerViewController, didDeselect asset: PHAsset, at indexPath: IndexPath) {
        
    }
}

