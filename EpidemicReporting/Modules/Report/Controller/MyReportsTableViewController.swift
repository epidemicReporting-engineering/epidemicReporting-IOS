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

class MyReportsTableViewController: CoreDataTableViewController {
    
    fileprivate var assetsPickerVC: AssetsPickerViewController?
    fileprivate var assets = [PHAsset]()
    fileprivate var pickerConfig = AssetsPickerConfig()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        intiUI()
        initTableView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initTableView() {
        let footview = UIView()
        tableView.tableFooterView = footview
        
        let nib = UINib.init(nibName: "ReportTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ReportTableViewCell")
    }
    
    func intiUI() {
        navigationController?.setStyledNavigationBar()
        navigationItem.title = "疫情上报"
        
        let baseView = UIView.init(frame: CGRect.init(x: Utils.getScreenWidth() - 100, y: Utils.getScreenHeigh() - 200, width: 60, height: 60))
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
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(accessAssets))
        plusView.addGestureRecognizer(tap)
    }
    
    @objc func accessAssets() {
        pickerConfig.selectedAssets = self.assets
        pickerConfig.albumIsShowHiddenAlbum = true
        assetsPickerVC = AssetsPickerViewController()
        assetsPickerVC?.pickerDelegate = self
        guard let vc = assetsPickerVC else { return }
        present(vc, animated: true, completion: nil)
    }
    
    lazy var setup: () = {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "DutyReport")
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
        guard let userid = appDelegate.currentUser?.username else { return }
        request.predicate = NSPredicate(format: "username == %@", userid)
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: appDelegate.dataStack.mainContext, sectionNameKeyPath: nil, cacheName: nil)
    }()
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReportTableViewCell", for: indexPath) as? ReportTableViewCell
        guard let dataCell = cell else { return UITableViewCell()}
        return dataCell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let cell = tableView.cellForRow(at: indexPath) as? FilterTableViewCell
//        delegate?.refeshFilter(cell?.dutyStatus)
//        tableView.deselectRow(at: indexPath, animated: true)
//        delegate?.refeshFilter(cell?.dutyStatus)
//        dismiss(animated: true, completion: nil)
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
        if let nav = storyboard?.instantiateViewController(withIdentifier: "sendReportNav") as? UINavigationController, let reportVc  = nav.childViewControllers.first as? AssetsViewController {
            reportVc.assets = self.assets
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
