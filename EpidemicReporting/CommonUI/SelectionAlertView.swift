//
//  SelectionAlertView.swift
//  EpidemicReporting
//
//  Created by WangJianyu on 2018/9/23.
//  Copyright © 2018年 epidemicreporting.com. All rights reserved.
//

import UIKit
import SnapKit

typealias SelectionItem = (title: String, tag: Int)

class SelectionConfiguration {
    
    var selections: [SelectionItem]?
    var selectionHeight: CGFloat = 44
}

class SelectionButton: UIButton {
    
    var choosed: Bool = false {
        didSet {
            backgroundColor = choosed ? UIColor(hexString: "#0084C0") : UIColor.white
            setTitleColor(choosed ? UIColor.white : UIColor.black, for: .normal)
        }
    }
    
    var selectionTag: Int = -1
    
    init(title: String, tag: Int) {
        super.init(frame: .zero)
        setTitle(title, for: .normal)
        self.titleLabel?.textAlignment = .left
        self.selectionTag = tag
        backgroundColor = choosed ? UIColor(hexString: "#0084C0") : UIColor.white
        setTitleColor(choosed ? UIColor.white : UIColor.black, for: .normal)
        layer.borderColor = UIColor(hexString: "#0084C0").cgColor
        layer.borderWidth = 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class SelectionAlertView: UIView {

    let configuration: SelectionConfiguration
    
    var selectionButtons = [SelectionButton]()
    
    var confirmCompeletion: ((Int?) -> Void)?
    
    init(configuration: SelectionConfiguration, confirmCompeletion: ((Int?) -> Void)?) {
        self.configuration = configuration
        self.confirmCompeletion = confirmCompeletion
        super.init(frame: .zero)
        isHidden = true
        prepareUI()
//        layer.borderColor = UIColor(hexString: "#0084C0").cgColor
//        layer.borderWidth = 1
    }
    
    func show() {
        isHidden = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension SelectionAlertView {
    
    fileprivate func prepareUI() {
        guard let selections = configuration.selections else { return }
        backgroundColor = UIColor.white
        var last: UIView?
        // buttons
        for index in 0..<selections.count {
            let button = SelectionButton(title: selections[index].title, tag: selections[index].tag)
            button.addTarget(self, action: #selector(selectAction), for: .touchUpInside)
            addSubview(button)
            button.snp.makeConstraints { (maker) in
                if let last = last {
                    maker.top.equalTo(last.snp.bottom)
                } else {
                    maker.top.equalToSuperview()
                    button.choosed = true
                }
                maker.left.right.equalToSuperview()
                maker.height.equalTo(configuration.selectionHeight)
            }
            last = button
            selectionButtons.append(button)
        }
        // actions
        let confirmButton = UIButton()
//        confirmButton.setTitle("确认", for: .normal)
        confirmButton.addTarget(self, action: #selector(comfirmAction), for: .touchUpInside)
        confirmButton.setImage(#imageLiteral(resourceName: "selection_check"), for: .normal)
        addSubview(confirmButton)
        confirmButton.snp.makeConstraints { (maker) in
            maker.right.equalTo(-21)
            maker.size.equalTo(CGSize(width: 32, height: 32))
            if let last = last {
                maker.top.equalTo(last.snp.bottom).offset(5)
            }
        }
        
        let cancelButton = UIButton()
//        cancelButton.setTitle("取消", for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        cancelButton.setImage(#imageLiteral(resourceName: "selection_close"), for: .normal)
        addSubview(cancelButton)
        cancelButton.snp.makeConstraints { (maker) in
//            maker.left.right.bottom.equalToSuperview()
//            maker.height.equalTo(configuration.selectionHeight)
//            maker.top.equalTo(confirmButton.snp.bottom)
            maker.left.equalTo(21)
            maker.size.equalTo(CGSize(width: 32, height: 32))
            if let last = last {
                maker.top.equalTo(last.snp.bottom).offset(5)
            }
        }
    }
    
    @objc func selectAction(sender: SelectionButton) {
        for button in selectionButtons {
            button.choosed = button.selectionTag == sender.selectionTag
        }
    }
    
    @objc func comfirmAction() {
        var selectedTag: Int?
        for button in selectionButtons {
            if button.choosed {
                selectedTag = button.selectionTag
            }
        }
        isHidden = true
        confirmCompeletion?(selectedTag)
    }
    
    @objc func cancelAction() {
        isHidden = true
    }
}
