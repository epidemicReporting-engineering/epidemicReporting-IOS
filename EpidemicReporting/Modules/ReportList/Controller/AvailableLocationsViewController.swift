//
//  AvailableLocationsViewController.swift
//  EpidemicReporting
//
//  Created by IBM on 31/12/2017.
//  Copyright © 2017 epidemicreporting.com. All rights reserved.
//

import UIKit

class AvailableLocationsViewController: UIViewController, MAMapViewDelegate {
    
    @IBOutlet weak var mapView: MAMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setStyledNavigationBar()
        
        mapView?.isShowsUserLocation = false
        mapView?.setZoomLevel(14.2, animated: false)
        mapView?.showsScale = true
        
        let pointAnnotation = MAPointAnnotation()
        pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: 39.979590, longitude: 116.352792)
        pointAnnotation.title = "方恒国际"
        pointAnnotation.subtitle = "阜通东大街6号"
        mapView.addAnnotation(pointAnnotation)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
        
        if annotation.isKind(of: MAPointAnnotation.self) {
            let pointReuseIndetifier = "pointReuseIndetifier"
            var annotationView: MAAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: pointReuseIndetifier)
            
            if annotationView == nil {
                annotationView = MAAnnotationView(annotation: annotation, reuseIdentifier: pointReuseIndetifier)
            }
            
            annotationView!.image = UIImage(named: "restaurant")
            //设置中心点偏移，使得标注底部中间点成为经纬度对应点
            annotationView!.centerOffset = CGPoint.init(x: 0, y: -18)
            return annotationView!
        }
        
        return nil
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
