//
//  SideBarTableViewController.swift
//  BlurrySideBar
//
//  Created by Prateek Sharma on 02/01/18.
//  Copyright © 2018 Prateek Sharma. All rights reserved.
//

import UIKit

protocol SideBarTableDelegate {
    func sideBarControlDidSelectMenuAt(indexPath : IndexPath)
}

class SideBarTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    var tableData = [String]()
    var delegate : SideBarTableDelegate?
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
            
            cell!.backgroundColor = UIColor.clear
            cell!.textLabel?.textColor = UIColor.darkText
            
            let selectedView = UIView(frame: CGRect(x: 0, y: 0, width: cell!.frame.size.width, height: cell!.frame.height))
            selectedView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
            
            cell!.selectedBackgroundView = selectedView
        }
        
        cell!.textLabel?.text = tableData[indexPath.row]
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if delegate != nil {
            delegate?.sideBarControlDidSelectMenuAt(indexPath: indexPath)
        }
        else{
            print("Please setup the delegate correctly")
        }
    }

}
