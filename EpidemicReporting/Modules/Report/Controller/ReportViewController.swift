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
    
    }
}
