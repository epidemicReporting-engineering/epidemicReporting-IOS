//
//  MyReportsTableViewController.swift
//  EpidemicReporting
//
//  Created by eleven on 2017/12/26.
//  Copyright © 2017年 epidemicreporting.com. All rights reserved.
//

import UIKit
import CoreData
import AssetsPickerViewController
import Photos
import TinyLog
import SwiftyJSON

protocol FilterTableViewControllerDelegate : NSObjectProtocol {
    
    func refeshFilter(_ status: DutyStatus?)
}

class AdminReportsTableViewController: CoreDataTableViewController {
    
    fileprivate var filterVc: FilterTableViewController?
    fileprivate var allData = [JSON]()
    fileprivate var data = [JSON]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        initTableView()
    }
    
    fileprivate func initUI() {
        navigationController?.setStyledNavigationBar()
        navigationItem.title = "疫情汇总"
        
        let rightFilterItemblank = UIBarButtonItem.createBarButtonItemWithText("", CGRect(x: 0, y: 0, width: 8, height: 24), self, #selector(filterType), UIColor.white, 12)

        guard let filterImage = UIImage(named: "filter") else { return }
        let rightFilterItem = UIBarButtonItem.createBarButtonItemWithImage(filterImage, CGRect(x: 0, y: 0, width: 24, height: 24), self, #selector(filterType))
        navigationItem.rightBarButtonItems = [rightFilterItemblank,rightFilterItem]
        
        //add refresh controller
        self.refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refeshDataAll), for: .valueChanged)
        refreshControl?.attributedTitle = NSAttributedString(string: "下拉刷新数据")
    }
    
    func initTableView() {
        let footView = UIView()
        tableView.tableFooterView = footView
        
        let nib = UINib(nibName: "ReportTableViewCell",bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ReportTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        refeshDataAll()
//        _ = setup
    }
    
//    lazy var setup: () = {
//        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "DutyReport")
//        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
//        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: appDelegate.dataStack.mainContext, sectionNameKeyPath: nil, cacheName: nil)
//    }()

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func filterType(_ sender: Any) {
        let reportstoryboard: UIStoryboard = UIStoryboard(name: "ReportList", bundle: nil)
        filterVc = reportstoryboard.instantiateViewController(withIdentifier: "filterTableVC") as? FilterTableViewController
        filterVc?.delegate = self
        filterVc?.modalPresentationStyle = .popover
        filterVc?.preferredContentSize = CGSize(width: 150, height: 290)
        
        if let popover = filterVc?.popoverPresentationController, let vc = filterVc {
            popover.sourceView = sender as? UIView
            popover.sourceRect = CGRect(x: ((sender as? UIView)?.bounds.width)! / 2, y: ((sender as? UIView)?.bounds.height)!, width: 1, height: 1)
            //popover.sourceRect = sender.bounds
            popover.delegate = self
            popover.permittedArrowDirections = .up
            present(vc, animated: true, completion:nil)
        }
    }
    
    @objc func refeshDataAll() {
        navigationItem.title = "疫情汇总"
        DataService.sharedInstance.getAllStatusReportsJSON() { [weak self] (success, json, error)  in
            self?.refreshControl?.endRefreshing()
            guard let jsonData = json?["data"]["list"].array else { return }
            self?.allData = jsonData
            self?.refeshData(DutyStatus.ALL)
        }
    }
}

extension AdminReportsTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReportTableViewCell", for: indexPath) as! ReportTableViewCell
        let thisData = data[indexPath.row]
//        guard let report = fetchedResultsController?.object(at: indexPath) as? DutyReport else { return cell }
//        cell.updateDataSource(report)
        cell.updateDataSource(thisData)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let cell = self.fetchedResultsController?.object(at: indexPath) as? DutyReport
        let cell = data[indexPath.row]
        let storyboard = UIStoryboard(name: "Report", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "DutyDetailsTableViewController") as? DutyDetailsTableViewController {
            vc.reportId = cell["id"].int64
            navigationController?.pushViewController(vc, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let duty = data[indexPath.row]
        return actionButtonDecider(duty)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func actionButtonDecider(_ report: JSON?) -> [UITableViewRowAction]? {
        var actions:[UITableViewRowAction]? = [UITableViewRowAction]()
        guard let status = report?["dutyStatus"].string else { return nil }
        switch status {
        case DutyStatus.UNASSIGN.rawValue:
            let assign = UITableViewRowAction(style: .normal, title: "分配") { [weak self](action, indexPath) in
                if let vc = self?.storyboard?.instantiateViewController(withIdentifier: "AvailableLocationsViewController") as? AvailableLocationsViewController {
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            }
            assign.backgroundColor = UIColor(hexString: themeBlue)
            actions?.append(assign)
        case DutyStatus.CANTDO.rawValue:
            let assign = UITableViewRowAction(style: .normal, title: "分配") { [weak self](action, indexPath) in
                if let vc = self?.storyboard?.instantiateViewController(withIdentifier: "AvailableLocationsViewController") as? AvailableLocationsViewController {
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            }
            assign.backgroundColor = UIColor(hexString: themeBlue)
            actions?.append(assign)
        case DutyStatus.FINISH.rawValue:
            let comment = UITableViewRowAction(style: .normal, title: "点评") { [weak self](action, indexPath) in
                //TODO: send the status
                
            }
            comment.backgroundColor = UIColor(hexString: themeBlue)
            actions?.append(comment)
        default:
            break
        }
        return actions
    }
}

extension AdminReportsTableViewController: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}

extension AdminReportsTableViewController: FilterTableViewControllerDelegate {
    
    func refeshData(_ status: DutyStatus?) {
        guard let status = status else { return }
        if status == DutyStatus.ALL {
            data = allData
        } else {
            var result = [JSON]()
            for json in allData {
                if json["dutyStatus"].string == status.rawValue {
                    result.append(json)
                }
            }
            data = result
        }
        
//        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "DutyReport")
//        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
//        guard let value = status?.rawValue else { return }
//        if value != DutyStatus.ALL.rawValue {
//            request.predicate = NSPredicate(format: "dutyStatus == %@", value)
//        }
//        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: appDelegate.dataStack.mainContext, sectionNameKeyPath: nil, cacheName: nil)
//        do {
//            try fetchedResultsController?.performFetch()
//        } catch  {
//            print(error)
//        }
    }
    
    func showTitle(_ status: DutyStatus?) {
        guard let status = status?.rawValue else { return }
        switch status {
        case "0":
            navigationItem.title = "未分配"
        case "1":
            navigationItem.title = "已分配"
        case "2":
            navigationItem.title = "开始处理"
        case "3":
            navigationItem.title = "遇到困难"
        case "4":
            navigationItem.title = "被退回"
        case "5":
            navigationItem.title = "处理完成"
        case "6":
            navigationItem.title = "确认处理"
        default:
            break
        }
    }
    
    func refeshFilter(_ status: DutyStatus?) {
        showTitle(status)
        refeshData(status)
    }
}
