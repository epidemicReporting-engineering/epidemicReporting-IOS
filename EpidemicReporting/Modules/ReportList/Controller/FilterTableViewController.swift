//
//  FilterTableViewController.swift
//  EpidemicReporting
//
//  Created by eleven on 2017/12/28.
//  Copyright © 2017年 epidemicreporting.com. All rights reserved.
//

import UIKit
import CoreData

class FilterTableViewController: UITableViewController {

    var delegate: FilterTableViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func initTableView() {
        let footview = UIView()
        tableView.tableFooterView = footview
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 7
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "filterCell", for: indexPath) as? FilterTableViewCell
        customFilter(indexPath, cell: cell)
        guard let dataCell = cell else { return UITableViewCell()}
        return dataCell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    fileprivate func customFilter(_ indexPath: IndexPath, cell: FilterTableViewCell?) {
        var image: UIImage?
        var content: String?
        var status: DutyStatus?
        var number: String?
        
        switch indexPath.item {
        case 0:
            image = UIImage(named: "unassign")
            content = "未分配"
            status = DutyStatus.UNASSIGN
            number = getStatusNumber(status)
        case 1:
            image = UIImage(named: "assigned")
            content = "已分配"
            status = DutyStatus.ASSIGNED
            number = getStatusNumber(status)
        case 2:
            image = UIImage(named: "start")
            content = "开始处理"
            status = DutyStatus.START
            number = getStatusNumber(status)
        case 3:
            image = UIImage(named: "block")
            content = "遇到困难"
            status = DutyStatus.BLOCK
            number = getStatusNumber(status)
        case 4:
            image = UIImage(named: "cantdo")
            content = "被退回"
            status = DutyStatus.CANTDO
            number = getStatusNumber(status)
        case 5:
            image = UIImage(named: "success")
            content = "处理完成"
            status = DutyStatus.FINISH
            number = getStatusNumber(status)
        case 6:
            image = UIImage(named: "confirm")
            content = "确认处理"
            status = DutyStatus.SUCCESS
            number = getStatusNumber(status)
        default:
            break
        }
        guard let indicator = image, let contentType = content, let saveStatus = status , let count = number else { return }
        cell?.updataSouce(indicator, content: contentType, status: saveStatus, count: count)
    }
    
    func getStatusNumber(_ status: DutyStatus?) -> String? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "DutyReport")
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
        guard let value = status?.rawValue else { return nil}
        request.predicate = NSPredicate(format: "dutyStatus == %@", value)
        let number = ((try! appDelegate.dataStack.mainContext.fetch(request)) as? [DutyReport])
        return number?.count.description
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as? FilterTableViewCell
                delegate?.refeshFilter(cell?.dutyStatus)
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.refeshFilter(cell?.dutyStatus)
        dismiss(animated: true, completion: nil)
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
