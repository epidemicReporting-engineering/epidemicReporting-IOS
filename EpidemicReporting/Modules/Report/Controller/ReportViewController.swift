//
//  ReportViewController.swift
//  EpidemicReporting
//
//  Created by eleven on 2017/11/13.
//  Copyright © 2017年 epidemicreporting.com. All rights reserved.
//

import UIKit
import AssetsPickerViewController
import Photos
import TinyLog

class ReportViewController: UIViewController {

    @IBOutlet weak var addReportBut: UIView!
    fileprivate var assets = [PHAsset]()
    fileprivate var assetVC: AssetsViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initUI()
    }
    
    fileprivate func initUI() {
        navigationController?.setStyledNavigationBar()
        navigationItem.title = "上报疫情"
        
        addReportBut.layer.cornerRadius = addReportBut.frame.width / 2
        addReportBut.layer.masksToBounds = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showAssets(_ sender: UITapGestureRecognizer) {
        let pickerConfig = AssetsPickerConfig()
        // set previously selected assets as selected assets on initial load
        pickerConfig.selectedAssets = self.assets
        
        let picker = AssetsPickerViewController(pickerConfig: pickerConfig)
        picker.pickerDelegate = self
        
        present(picker, animated: true, completion: nil)
        UIApplication.shared.statusBarStyle = .default
    }
}

extension ReportViewController: AssetsPickerViewControllerDelegate {
    
    func assetsPickerCannotAccessPhotoLibrary(controller: AssetsPickerViewController) {
        logw("Need permission to access photo library.")
    }
    
    func assetsPickerDidCancel(controller: AssetsPickerViewController) {
        log("Cancelled.")
    }
    
    func assetsPicker(controller: AssetsPickerViewController, selected assets: [PHAsset]) {
        self.assets = assets
        if let uploadNav = storyboard?.instantiateViewController(withIdentifier: "sendReportNav") as? UINavigationController {
            assetVC = uploadNav.childViewControllers.first as? AssetsViewController
            assetVC?.assets = assets
            present(uploadNav, animated: true, completion: nil)
        }
    }
    
    func assetsPicker(controller: AssetsPickerViewController, shouldSelect asset: PHAsset, at indexPath: IndexPath) -> Bool {
        log("shouldSelect: \(indexPath.row)")
        
        // can limit selection count
        if controller.selectedAssets.count > 5 {
            return false
        }
        return true
    }
    
    func assetsPicker(controller: AssetsPickerViewController, didSelect asset: PHAsset, at indexPath: IndexPath) {
        log("didSelect: \(indexPath.row)")
    }
    
    func assetsPicker(controller: AssetsPickerViewController, shouldDeselect asset: PHAsset, at indexPath: IndexPath) -> Bool {
        log("shouldDeselect: \(indexPath.row)")
        return true
    }
    
    func assetsPicker(controller: AssetsPickerViewController, didDeselect asset: PHAsset, at indexPath: IndexPath) {
        log("didDeselect: \(indexPath.row)")
    }
    
    func assetsPicker(controller: AssetsPickerViewController, didDismissByCancelling byCancel: Bool) {
        log("dismiss completed - byCancel: \(byCancel)")
        UIApplication.shared.statusBarStyle = .lightContent
    }
}

