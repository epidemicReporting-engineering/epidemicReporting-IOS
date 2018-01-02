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
    
    fileprivate var customCalloutView: CustomCalloutView?
    fileprivate var annotations: [MAAnnotation] = [MAAnnotation]()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setStyledNavigationBar()
        
//        mapView?.isShowsUserLocation = false
//        mapView?.setZoomLevel(14.2, animated: false)
//        mapView?.showsScale = true
        
        customCalloutView = CustomCalloutView()
        
        mapView.delegate = self
        
        let pointAnnotation1 = MAPointAnnotation()
        pointAnnotation1.coordinate = CLLocationCoordinate2D(latitude: 29.8925661892361, longitude: 121.620976291233)
        
        let pointAnnotation2 = MAPointAnnotation()
        pointAnnotation2.coordinate = CLLocationCoordinate2D(latitude: 31.8925661892361, longitude: 121.620976291233)
        mapView.addAnnotation(pointAnnotation1)
        mapView.addAnnotation(pointAnnotation2)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
        if annotation.isKind(of: MAPointAnnotation.self) {
            let pointReuseIndetifier = "pointReuseIndetifier"
            var annotationView: CustomAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: pointReuseIndetifier) as? CustomAnnotationView
            
            if annotationView == nil {
                annotationView = CustomAnnotationView(annotation: annotation, reuseIdentifier: pointReuseIndetifier)
            }
            
            //annotationView!.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30)
            //设置中心点偏移，使得标注底部中间点成为经纬度对应点
            annotationView!.image = UIImage.init(named: "location_map")
            annotationView!.centerOffset = CGPoint.init(x: 0, y: -18)
            annotationView!.canShowCallout = false
            return annotationView!
        }
        
        return nil
    }
    
    func mapView(_ mapView: MAMapView!, didSelect view: MAAnnotationView!) {
        //
    }
    
//    func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
//
//        if annotation.isKind(of: MAPointAnnotation.self) {
//            let pointReuseIndetifier = "pointReuseIndetifier"
//            var annotationView: MAPinAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: pointReuseIndetifier) as! MAPinAnnotationView?
//
//            if annotationView == nil {
//                annotationView = MAPinAnnotationView(annotation: annotation, reuseIdentifier: pointReuseIndetifier)
//            }
//
//            annotationView!.canShowCallout = true
//            annotationView!.animatesDrop = true
//            annotationView!.isDraggable = true
//            annotationView!.rightCalloutAccessoryView = UIButton(type: UIButtonType.detailDisclosure)
//
//            let idx = annotations.index(of: annotation as! MAPointAnnotation)
//            annotationView!.pinColor = MAPinAnnotationColor(rawValue: idx!)!
//
//            return annotationView!
//        }
//
//        return nil
//    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
