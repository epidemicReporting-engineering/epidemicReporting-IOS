//
//  File.swift
//  EpidemicReporting
//
//  Created by eleven on 2017/11/11.
//  Copyright © 2017年 epidemicreporting.com. All rights reserved.
//

import Foundation
import UIKit
import FSCalendar

class SelfCheckViewController: UIViewController, MAMapViewDelegate, AMapSearchDelegate {
    
    @IBOutlet weak var mapViewContainer: UIView!
    @IBOutlet weak var calendarContainer: UIView!
    @IBOutlet weak var calendar: FSCalendar!
    
    fileprivate var mapView: MAMapView?
    fileprivate var search: AMapSearchAPI?
    
    fileprivate let gregorian: NSCalendar! = NSCalendar(calendarIdentifier:NSCalendar.Identifier.gregorian)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initMapView()
        initSearch()
        initCalendar()
        
        navigationController?.setStyledNavigationBar()
        navigationItem.title = "我的足迹"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        mapView?.isShowsUserLocation = true
        mapView?.setZoomLevel(14.2, animated: false)
        mapView?.showsScale = false
        mapView?.userTrackingMode = MAUserTrackingMode.follow
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    private func initMapView() {
        mapView = MAMapView(frame: mapViewContainer.bounds)
        mapView?.delegate = self
        if let map = mapView {
            mapViewContainer.addSubview(map)
        }
    }
    
    func initSearch() {
        search = AMapSearchAPI()
        search?.delegate = self
    }
    
    func initCalendar() {
        calendar.dataSource = self
        calendarContainer.layer.borderWidth = 3.0
        calendarContainer.layer.borderColor = UIColor.init(hexString: themeBlue).cgColor
        calendarContainer.layer.cornerRadius = 10
    }
}

extension SelfCheckViewController: FSCalendarDataSource {
    
    func calendar(_ calendar: FSCalendar, imageFor date: Date) -> UIImage? {
        let day: Int! = self.gregorian.component(.day, from: date)
        return [11,10].contains(day) ? UIImage(named: "history") : nil
    }
}
