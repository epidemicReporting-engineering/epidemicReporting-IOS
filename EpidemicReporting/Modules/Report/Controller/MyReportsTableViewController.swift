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
import SwiftyJSON

class MyReportsTableViewController: CoreDataTableViewController {
    
    fileprivate var assetsPickerVC: AssetsPickerViewController?
    fileprivate var assets = [PHAsset]()
    fileprivate var pickerConfig = AssetsPickerConfig()
    
    fileprivate var data = [JSON]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        intiUI()
        initTableView()
//        _ = setup
        refeshDataAll()
    }
    
    func initTableView() {
        let footview = UIView()
        tableView.tableFooterView = footview
        
        let nib = UINib.init(nibName: "ReportTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ReportTableViewCell")
        
        //add refresh controller
        self.refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refeshDataAll), for: .valueChanged)
        refreshControl?.attributedTitle = NSAttributedString(string: "下拉刷新数据")
    }
    
    func intiUI() {
        navigationController?.setStyledNavigationBar()
        navigationItem.title = "疫情上报"
        
        let baseView = UIView.init(frame: CGRect.init(x: Utils.getScreenWidth() - 100, y: Utils.getScreenHeigh() - 160, width: 60, height: 60))
        baseView.layer.cornerRadius = baseView.bounds.width / 2
        baseView.layer.masksToBounds = true
        baseView.backgroundColor = UIColor(hexString: themeBlue)
        
        let plusView = UIImageView(image: UIImage(named: "plus"))
        plusView.isUserInteractionEnabled = true
        baseView.addSubview(plusView)
        plusView.translatesAutoresizingMaskIntoConstraints = false
        plusView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        plusView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        plusView.centerXAnchor.constraint(equalTo: baseView.centerXAnchor).isActive = true
        plusView.centerYAnchor.constraint(equalTo: baseView.centerYAnchor).isActive = true
        navigationController?.view.addSubview(baseView)
        
        baseView.layer.shadowOpacity = 0.8
        baseView.layer.shadowColor = UIColor.black.cgColor
        baseView.layer.shadowOffset = CGSize(width: 4, height: 4)
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(accessAssets))
        plusView.addGestureRecognizer(tap)
    }
    
    @objc func refeshDataAll(){
        guard let userName = appDelegate.currentUser?.username else { return }
        DataService.sharedInstance.getAllReportsJSON(reporter: userName) { [weak self] (success, json, error)  in
            self?.refreshControl?.endRefreshing()
            guard let jsonData = json?["data"]["list"].array else { return }
            self?.data = jsonData
        }
    }
    
    @objc func accessAssets() {
        pickerConfig.selectedAssets = self.assets
        pickerConfig.albumIsShowHiddenAlbum = true
        assetsPickerVC = AssetsPickerViewController()
        assetsPickerVC?.pickerDelegate = self
        guard let vc = assetsPickerVC else { return }
        present(vc, animated: true, completion: nil)
    }
    
//    lazy var setup: () = {
//        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "DutyReport")
//        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
//        guard let userid = appDelegate.currentUser?.username else { return }
//        request.predicate = NSPredicate(format: "reporter == %@", userid)
//        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: appDelegate.dataStack.mainContext, sectionNameKeyPath: nil, cacheName: nil)
//    }()
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReportTableViewCell", for: indexPath) as? ReportTableViewCell
        guard let dataCell = cell else { return UITableViewCell()}
        let thisData = data[indexPath.row]
        cell?.updateDataSource(thisData)
        return dataCell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let thisData = data[indexPath.row]
        let storyboard = UIStoryboard(name: "Report", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "DutyDetailsTableViewController") as? DutyDetailsTableViewController {
            vc.reportId = thisData["id"].int64
            vc.dutyData = thisData
            navigationController?.pushViewController(vc, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension MyReportsTableViewController: AssetsPickerViewControllerDelegate {
    
    func assetsPickerCannotAccessPhotoLibrary(controller: AssetsPickerViewController) {
        
    }
    
    func assetsPickerDidCancel(controller: AssetsPickerViewController) {
        
    }
    
    func assetsPicker(controller: AssetsPickerViewController, selected assets: [PHAsset]) {
        // do your job with selected assets
        self.assets = assets
        if let nav = storyboard?.instantiateViewController(withIdentifier: "patientDetialNav") as? UINavigationController, let pdVc  = nav.childViewControllers.first as? PatientDetailViewController {
            pdVc.finishedAction = { [weak self] (reportData) in
                if let nav = self?.storyboard?.instantiateViewController(withIdentifier: "sendReportNav") as? UINavigationController, let reportVc  = nav.childViewControllers.first as? AssetsViewController {
                    reportVc.assets = self?.assets
                    reportVc.reportData = reportData
                    reportVc.finishedAction = { [weak self] in
                        self?.refeshDataAll()
                    }
                    self?.present(nav, animated: true, completion: nil)
                }
            }
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
