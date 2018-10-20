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

class DutyDetailsTableViewController: UITableViewController {
    
    var reportId: Int64?
    var dataModels: [DutyStatusModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.setStyledNavigationBar()
        initTableView()
        updateDataSource()
    }
    
    func initTableView() {
        navigationItem.title = "疫情状态"
        let footView = UIView()
        tableView.tableFooterView = footView
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateDataSource() {
        OPLoadingHUD.show(UIImage(named: "loading"), title: "努力加载中", animated: true, delay: 0)
        DataService.sharedInstance.getReportAllStatus(reportId?.description) { [weak self](success, data, error) in
            if let statusData = data, success {
                self?.dataModels = statusData
                self?.tableView.reloadData()
            }
            OPLoadingHUD.hide()
        }
    }
}

extension DutyDetailsTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = dataModels?.count {
            return count
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DutyDetailTableViewCell", for: indexPath) as! DutyDetailTableViewCell
        guard let data = dataModels?[indexPath.item], let count = dataModels?.count else { return cell }
        let isFirst = indexPath.item == 0 ? true : false
        let isLast = (indexPath.item == count - 1) ? true : false
        cell.updateDataSource(data, isFirst: isFirst, isLast: isLast)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let data = dataModels?[indexPath.item] else { return }
        let storyboard = UIStoryboard.init(name: "Report", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "DutyStatusViewController") as? DutyStatusViewController {
            vc.data = data
            navigationController?.pushViewController(vc, animated: true)
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
