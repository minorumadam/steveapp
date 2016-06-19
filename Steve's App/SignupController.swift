//
//  SignupController.swift
//  Steve's App
//
//  Created by Must on 2/3/16.
//  Copyright © 2016 Must. All rights reserved.
//

import Foundation
import UIKit

class SignupController:UIViewController{
    
    @IBOutlet weak var m_Email: UITextField!
    
    @IBOutlet weak var m_Password: UITextField!
    
    @IBOutlet weak var m_ActivityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var m_Signupbutton: UIButton!
    
    
    
    @IBAction func onClickSignUp(sender: AnyObject) {
        if (m_Email.text?.characters.count == 0 || m_Password.text?.characters.count == 0){
            showAlertWithError("SignUp Failed", message: "Please enter correct Email and Password.")
        }
        else {
            saveSignupInfo()
        }
    }
    
    func saveSignupInfo(){
        
        self.m_Signupbutton.enabled = false
        self.m_ActivityIndicator.hidden = false
        self.m_ActivityIndicator.startAnimating()
        
        let query = PFQuery(className: "UserInfo")
//        query.whereKey("password", equalTo: m_Password.text!)
        query.whereKey("email", equalTo: m_Email.text!)
        
        query.findObjectsInBackgroundWithBlock{(objects:[PFObject]?, error:NSError?) -> Void in
            self.m_ActivityIndicator.stopAnimating()
            self.m_ActivityIndicator.hidden = true
            self.m_Signupbutton.enabled = true
            
            if (error != nil){
                self.showAlertWithError("Network Error", message: "SignUp failed. Please check your network connection.")
            }
            else {
                if (objects?.count == 0){
                    
                    let object:PFObject = PFObject(className: "UserInfo")
                    object.setObject(self.m_Email.text!, forKey: "email")
                    object.setObject(self.m_Password.text!, forKey: "password")
                    self.m_Signupbutton.enabled = false
                    self.m_ActivityIndicator.hidden = false
                    self.m_ActivityIndicator.startAnimating()
                    object.saveInBackgroundWithBlock({(successed:Bool, error: NSError?) -> Void in
                        self.m_ActivityIndicator.stopAnimating()
                        self.m_ActivityIndicator.hidden = true
                        self.m_Signupbutton.enabled = true
                        if (error != nil){
                            self.showAlertWithError("Network Error", message: "SignUp failed. Please check your network connection.")
                        }
                        else {
                            self.loadStatDataFromServer()
                        }
                    })
                }
                else{
                    self.showAlertWithError("SignUpFailed", message: "This user has been already registered.")
                }
            }
        }
    
    }
    
    func loadStatDataFromServer(){
        m_ActivityIndicator.hidden = false
        m_Signupbutton.hidden = true
        m_ActivityIndicator.startAnimating()
        
        let query = PFQuery(className: "StatData")
        query.findObjectsInBackgroundWithBlock{(objects:[PFObject]?, error:NSError?) -> Void in
            self.m_ActivityIndicator.stopAnimating()
            self.m_ActivityIndicator.hidden = true
            
            if (error == nil && objects != nil){
                if (objects?.count == 0){
                    self.showAlertWithError("Database Error", message: "There are no data in database.")
                }
                else {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let controller:ChooseViewController = storyboard.instantiateViewControllerWithIdentifier("chooseViewController") as! ChooseViewController
                    
                    let count = objects!.count
                    for (var i = 0; i < count; i++){
                        let object : PFObject = objects![i]
                        let data : StatData = self.convertObjectToStatData(object)
                        controller.statDataArray.append(data)
                    }
                    self.dismissViewControllerAnimated(true, completion: {() -> Void in
                        UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(controller, animated: true, completion: nil)
                    }
                    )
                }
            }
            else {
                self.m_Signupbutton.hidden = false
                self.showAlertWithError("Network Error", message: "Can't access database.")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(animated: Bool) {
        m_ActivityIndicator.hidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func convertObjectToStatData(obj: PFObject) -> StatData{
        var data : StatData = StatData(weekNum: 0, date: NSDate(), gmNum: 0, teamName: "", lineNum: 0, selected: false)
        data.weekNum = obj.objectForKey("NFLWeek") as! Int
        data.date = obj.objectForKey("Date") as! NSDate
        data.gmNum = obj.objectForKey("GM") as! Int
        data.teamName = obj.objectForKey("TEAM") as! String
        data.lineNum = obj.objectForKey("MYLINE") as! Float
        data.selected = false
        return data
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        let touch : UITouch = touches.first!
        if (self.m_Password.isFirstResponder() && (touch.view == self.m_Password)){
            self.m_Password.resignFirstResponder()
            return
        }
        
        if (self.m_Email.isFirstResponder() && (touch.view == self.m_Email)){
            self.m_Email.resignFirstResponder()
            return
        }
        
        self.view.endEditing(true)
    }
    
    func showAlertWithError(title:String, message:String){
        let alertController: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let action:UIAlertAction = UIAlertAction(title: "OK", style: .Default, handler: { action -> Void in
            alertController.dismissViewControllerAnimated(true, completion: nil)
            }
        )
        alertController.addAction(action)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    @IBAction func onBack(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}