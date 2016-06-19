//
//  StatCell.swift
//  Steve's App
//
//  Created by Must on 2/2/16.
//  Copyright © 2016 Must. All rights reserved.
//

import Foundation
import UIKit



class StatCell : UITableViewCell{
    
    @IBOutlet weak var m_NFLWeekFirst: UILabel!
    
    @IBOutlet weak var m_DateFirst: UILabel!
    
    @IBOutlet weak var m_TimeFirst: UILabel!
    
    @IBOutlet weak var m_GMFirst: UILabel!
    
    @IBOutlet weak var m_TeamFirst: UILabel!
    
    @IBOutlet weak var m_LineFirst: UILabel!
   
    @IBOutlet weak var m_OptionCheckFirst: UIImageView!
    
    @IBOutlet weak var m_TeamImgFirst: UIImageView!
    
    @IBOutlet weak var m_NFLWeekSecond: UILabel!
    
    @IBOutlet weak var m_LineSecond: UILabel!
    
    @IBOutlet weak var m_DateSecond: UILabel!
    
    @IBOutlet weak var m_TimeSecond: UILabel!
    
    @IBOutlet weak var m_GMSecond: UILabel!
    
    @IBOutlet weak var m_TMSecond: UILabel!
    
    @IBOutlet weak var m_TeamImageSecond: UIImageView!
    
    @IBOutlet weak var m_OptionCheckSecond: UIImageView!
    
    
    @IBOutlet weak var m_UpperView: UIView!
    
    @IBOutlet weak var m_DownView: UIView!
    
    
    
    var tableIndex = -1
    
    var selectedViewIndex = -1 // -1 : no selected, 0 : Upper View, 1 : Down View

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        
        let touch:UITouch = touches.first!
        let location = touch.locationInView(self)
        let upperViewFrame = self.convertRect(m_UpperView.frame, fromView: self)
        if (upperViewFrame.contains(location)){
            selectedViewIndex = 0
        }
        let downViewFrame = self.convertRect(m_DownView.frame, fromView: self)
        if (downViewFrame.contains(location)){
            selectedViewIndex = 1
        }

        var parentController:UIViewController = (UIApplication.sharedApplication().keyWindow?.rootViewController)!
        while (parentController.presentedViewController != nil){
            parentController = parentController.presentedViewController!
        }

        let controller:ChooseViewController = parentController as! ChooseViewController
        let dataIndex = tableIndex * 2 + selectedViewIndex
        let data : StatData = controller.statDataArray[dataIndex]
        
        if (data.selected == true){
            controller.statDataArray[dataIndex].selected = false
            var i = 0;
            for (i = 0; i < controller.selectedTeamIndexArray.count; i++){
                if (controller.selectedTeamIndexArray[i] == dataIndex){
                    break
                }
            }
            controller.selectedTeamIndexArray.removeAtIndex(i)
            
            if (selectedViewIndex == 0){
                m_OptionCheckFirst.image = UIImage(named: "option_no")
            }
            else {
                m_OptionCheckSecond.image = UIImage(named: "option_no")
            }
        }
        else {
            if (controller.selectedTeamIndexArray.count >= 5){
                let alertController: UIAlertController = UIAlertController(title: "Count Over", message: "You can select only 5 teams.", preferredStyle: .Alert)
                let action:UIAlertAction = UIAlertAction(title: "OK", style: .Default, handler: { action -> Void in
                    alertController.dismissViewControllerAnimated(true, completion: nil)
                    }
                )
                alertController.addAction(action)
                controller.presentViewController(alertController, animated: true, completion: nil)
            }
            else {
                controller.statDataArray[dataIndex].selected = true
                controller.selectedTeamIndexArray.append(dataIndex)
                if (selectedViewIndex == 0){
                    m_OptionCheckFirst.image = UIImage(named: "option_ok")
                }
                else {
                    m_OptionCheckSecond.image = UIImage(named: "option_ok")
                }
            }
        }

    }
    
}