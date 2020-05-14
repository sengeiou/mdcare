//
//  UITabBarController+TabBarVisible.swift
//  Medicare
//
//  Created by sanghv on 2/17/20.
//

import Foundation

extension UITabBarController {

    private struct AssociatedKeys {
        // Declare a global var to produce a unique address as the assoc object handle
        static var orgFrameView: UInt8 = 0
        static var movedFrameView: UInt8 = 1
        static var isMovingFrame: UInt8 = 2
    }

    var orgFrameView: CGRect? {
        get { return objc_getAssociatedObject(self, &AssociatedKeys.orgFrameView) as? CGRect }
        set { objc_setAssociatedObject(self, &AssociatedKeys.orgFrameView, newValue, .OBJC_ASSOCIATION_COPY) }
    }

    var movedFrameView: CGRect? {
        get { return objc_getAssociatedObject(self, &AssociatedKeys.movedFrameView) as? CGRect }
        set { objc_setAssociatedObject(self, &AssociatedKeys.movedFrameView, newValue, .OBJC_ASSOCIATION_COPY) }
    }

    var isMovingFrame: Bool? {
        get { return objc_getAssociatedObject(self, &AssociatedKeys.isMovingFrame) as? Bool }
        set { objc_setAssociatedObject(self, &AssociatedKeys.isMovingFrame, newValue, .OBJC_ASSOCIATION_COPY) }
    }

    override open func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        if let movedFrameView = movedFrameView {
            tabBar.frame = movedFrameView
        }
    }

    func setTabBarVisible(visible: Bool, animated: Bool, duration: TimeInterval = 0.3) {
        //since iOS11 we have to set the background colour to the bar color it seams the navbar seams to get smaller during animation; this visually hides the top empty space...
        view.backgroundColor = tabBar.barTintColor
        // bail if the current state matches the desired state
        if tabBarIsVisible() == visible {
            return
        }

        if tabBarIsMoving() {
            return
        }

        //we should show it
        if visible {
            tabBar.isHidden = false
            UIView.animate(withDuration: animated ? duration : 0.0, animations: {
                self.isMovingFrame = true
                //restore form or frames
                self.tabBar.frame = self.orgFrameView!
                //errase the stored locations so that...
                self.orgFrameView = nil
                self.movedFrameView = nil
                //...the layoutIfNeeded() does not move them again!
                // self.view.layoutIfNeeded()
            }, completion: { (_) in
                self.isMovingFrame = false
            })
        }
            //we should hide it
        else {
            //safe org positions
            orgFrameView = tabBar.frame
            // get a frame calculation ready
            let offsetY = tabBar.frame.height
            movedFrameView = CGRect(
                x: 0,
                y: view.frame.height + offsetY,
                width: tabBar.frame.width,
                height: offsetY
            )
            //animate
            UIView.animate(withDuration: animated ? duration : 0.0, animations: {
                self.isMovingFrame = true
                self.tabBar.frame = self.movedFrameView!
                // self.view.layoutIfNeeded()
            }, completion: { (_) in
                self.isMovingFrame = false
                self.tabBar.isHidden = true
            })
        }
    }

    func tabBarIsVisible() -> Bool {
        return orgFrameView == nil
    }

    func tabBarIsMoving() -> Bool {
        return isMovingFrame ?? false
    }
}
