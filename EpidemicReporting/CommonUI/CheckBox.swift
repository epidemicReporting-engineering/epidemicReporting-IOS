//
//  CheckBox.swift
//  EpidemicReporting
//
//  Created by WangJianyu on 2018/9/25.
//  Copyright © 2018年 epidemicreporting.com. All rights reserved.
//

import UIKit

enum CheckBoxStatus {
    case unSelected
    case selected
}

class SingleSelectionCheckBoxGroup {
    var checkBoxArray = [CheckBox]()
    
    var selectedTitle: String? {
        get {
            for index in 0..<checkBoxArray.count {
                if checkBoxArray[index].checkBoxStatus == .selected {
                    return checkBoxArray[index].titleLable.text
                }
            }
            return nil
        }
    }
    
    init(titles: [String]) {
        for title in titles {
            let box = CheckBox(title: title)
            let index = checkBoxArray.count
            box.selectAction = { [weak self] in
                self?.chooseOne(i: index)
            }
            checkBoxArray.append(box)
        }
    }
    
    func chooseOne(i: Int) {
        for index in 0..<checkBoxArray.count {
            checkBoxArray[index].checkBoxStatus = index == i ? .selected : .unSelected
        }
    }
    
    
}

class CheckBox: UIView {
    
    var checkBoxStatus: CheckBoxStatus = .unSelected {
        didSet {
            boxView.image = checkBoxStatus == .unSelected ?  #imageLiteral(resourceName: "check_box_outline_blank") :  #imageLiteral(resourceName: "check_box")
        }
    }
    
    let coverButton = UIButton()
    let boxView = UIImageView(image:  #imageLiteral(resourceName: "check_box_outline_blank"))
    let titleLable = UILabel()
    var selectAction: (()->())?
    
    
    init(title: String) {
        super.init(frame: .zero)
        
        addSubview(coverButton)
        coverButton.translatesAutoresizingMaskIntoConstraints = false
        coverButton.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        coverButton.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        coverButton.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        coverButton.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        coverButton.addTarget(self, action: #selector(checkAction), for: .touchUpInside)
        
        addSubview(boxView)
        boxView.translatesAutoresizingMaskIntoConstraints = false
        boxView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        boxView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        boxView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        boxView.widthAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        addSubview(titleLable)
        titleLable.adjustsFontSizeToFitWidth = true
        titleLable.textColor = UIColor.black
        titleLable.text = title
        titleLable.translatesAutoresizingMaskIntoConstraints = false
        titleLable.leftAnchor.constraint(equalTo: boxView.rightAnchor, constant: 8).isActive = true
        titleLable.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        titleLable.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func checkAction() {
        if let selectAction = selectAction {
            selectAction()
        } else {
            checkBoxStatus = checkBoxStatus == .unSelected ? .selected : .unSelected
        }
    }
}
