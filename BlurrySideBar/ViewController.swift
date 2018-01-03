//
//  ViewController.swift
//  BlurrySideBar
//
//  Created by Prateek Sharma on 01/01/18.
//  Copyright © 2018 Prateek Sharma. All rights reserved.
//

import UIKit

class ViewController: UIViewController , SideBarControlDelegate{

    @IBOutlet weak var label : UILabel!
    var sideBar : SideBarControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layer = CAGradientLayer()
        layer.frame = self.view.bounds
        layer.colors = [UIColor.yellow.cgColor, UIColor.orange.cgColor, UIColor.red.cgColor]
        
        self.view.layer.addSublayer(layer)
        
        sideBar = SideBarControl(sourceView: view, menuItems: ["First", "Second", "Third", "Fourth"])
        sideBar.delegate = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    func sideBarDidSelectMenu(atIndex index: Int) {
        print(index)
    }
}

