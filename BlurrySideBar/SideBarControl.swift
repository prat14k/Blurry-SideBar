//
//  SideBarControl.swift
//  BlurrySideBar
//
//  Created by Prateek Sharma on 02/01/18.
//  Copyright © 2018 Prateek Sharma. All rights reserved.
//

import UIKit

@objc protocol SideBarControlDelegate {
    
    @objc optional func willOpenSideBar()
    @objc optional func willCloseSideBar()
    @objc optional func didOpenSideBar()
    @objc optional func didCloseSideBar()
    
    func sideBarDidSelectMenu(atIndex index : Int)
}

class SideBarControl: NSObject, SideBarTableDelegate {
    
    var delegate : SideBarControlDelegate?
    var originView : UIView!
    let barWidth : CGFloat = 130.0
    let topInsets : CGFloat = 50.0
    var sideBarContainerView = UIView()
    var sideBarTableController : SideBarTableViewController!
    
    var isBarOpen = false
    var animator : UIDynamicAnimator!
    
    override init() {
        super.init()
    }
    
    init(sourceView : UIView, menuItems : [String]) {
        super.init()
        originView = sourceView

        setupSideBar()
        
        sideBarTableController.tableData = menuItems
        
        animator = UIDynamicAnimator(referenceView: originView)
        
        let showSideBarGesture = UISwipeGestureRecognizer(target: self, action: #selector(showSideBar(_:)))
        showSideBarGesture.direction = .right
        originView.addGestureRecognizer(showSideBarGesture)
        
        let hideSideBarGesture = UISwipeGestureRecognizer(target: self, action: #selector(hideSideBar(_:)))
        hideSideBarGesture.direction = .left
        originView.addGestureRecognizer(hideSideBarGesture)
    }
    
    func setupSideBar(){
        sideBarContainerView.frame = CGRect(x: -barWidth - 1, y: originView.frame.origin.y, width: barWidth, height: originView.frame.size.height)
        
        sideBarContainerView.backgroundColor = UIColor.clear
        
        originView.addSubview(sideBarContainerView)
        
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        blurView.frame = sideBarContainerView.bounds
        sideBarContainerView.addSubview(blurView)
        
        sideBarTableController = SideBarTableViewController(style: .plain)
        sideBarTableController.delegate = self
        sideBarTableController.tableView.frame = sideBarContainerView.bounds
        sideBarTableController.tableView.separatorStyle = .none
        sideBarTableController.tableView.scrollsToTop = false
        sideBarTableController.tableView.backgroundColor = UIColor.clear
        sideBarTableController.tableView.contentInset = UIEdgeInsets(top: topInsets, left: 0, bottom: 0, right: 0)
        
        sideBarTableController.tableView.reloadData()
        
        sideBarContainerView.addSubview(sideBarTableController.tableView)
    }
    
    @objc func showSideBar(_ gesture : UISwipeGestureRecognizer) {
        if isBarOpen == false {
            animateSideBar(toOpen: true)
        }
    }
    
    @objc func hideSideBar(_ gesture : UISwipeGestureRecognizer) {
        if isBarOpen == true {
            animateSideBar(toOpen: false)
        }
    }
    
    func animateSideBar(toOpen shouldOpen : Bool) {
        animator.removeAllBehaviors()
        
        isBarOpen = shouldOpen
        
        let gravityX : CGFloat = shouldOpen ? 0.5 : -0.5
        let magnitudeX : CGFloat = shouldOpen ? 20 : -20
        let boundaryX : CGFloat = shouldOpen ? barWidth : (-barWidth - 1)
    
        let gravityBehaviour = UIGravityBehavior(items: [sideBarContainerView])
        gravityBehaviour.gravityDirection = CGVector(dx: gravityX, dy: 0)
        animator.addBehavior(gravityBehaviour)
        
        let collisionBehaviour = UICollisionBehavior(items: [sideBarContainerView])
        collisionBehaviour.addBoundary(withIdentifier: "sideBarBoundary" as NSCopying, from: CGPoint(x: boundaryX, y: 20), to: CGPoint(x: boundaryX, y: originView.frame.size.height))
        animator.addBehavior(collisionBehaviour)
        
        let pushBehaviour = UIPushBehavior(items: [sideBarContainerView], mode: .instantaneous)
        pushBehaviour.magnitude = magnitudeX
        animator.addBehavior(pushBehaviour)
        
        let sideBarBehaviour = UIDynamicItemBehavior(items: [sideBarContainerView])
        sideBarBehaviour.elasticity = 0.3
        animator.addBehavior(sideBarBehaviour)
    }
    
    func sideBarControlDidSelectMenuAt(indexPath: IndexPath) {
        if delegate != nil {
            delegate?.sideBarDidSelectMenu(atIndex: indexPath.row)
        }
        else{
            print("Please set up the delegate")
        }
    }
    
}
