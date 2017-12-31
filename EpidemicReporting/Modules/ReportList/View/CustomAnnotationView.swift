//
//  CustomAnnotationView.swift
//  EpidemicReporting
//
//  Created by IBM on 31/12/2017.
//  Copyright © 2017 epidemicreporting.com. All rights reserved.
//

import UIKit

class CustomAnnotationView: MAAnnotationView {

    var calloutView: CustomCalloutView?
    let calloutWidth: CGFloat = 180
    let calloutHeight: CGFloat = 60
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        if (self.isSelected == selected) {
            return
        }
        
        if selected {
            if calloutView == nil {
                let nib = UINib(nibName: "CustomCalloutView", bundle: nil)
                calloutView = nib.instantiate(withOwner: self, options: nil).first as? CustomCalloutView
            }
            guard let view = calloutView else { return }
            addSubview(view)
        } else {
            calloutView?.removeFromSuperview()
        }
        super.setSelected(selected, animated: animated)
    }
}
