//
//  ViewController.swift
//  Steve's App
//
//  Created by Must on 2/2/16.
//  Copyright © 2016 Must. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var m_Password: UITextField!
    @IBOutlet weak var m_LoginButton: UIButton!
    @IBOutlet weak var m_ActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var m_Email: UITextField!
    
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

    @IBAction func onClickLogIn(sender: AnyObject) {
        if (m_Password.text?.characters.count == 0){
            self.showAlertWithError("Type Information", message: "Please type your email and password.")
            return
        }
        
        m_ActivityIndicator.hidden = false
        m_ActivityIndicator.startAnimating()
        m_LoginButton.enabled = false
        
        let query = PFQuery(className: "UserInfo")
        query.whereKey("password", equalTo: m_Password.text!)
        query.whereKey("email", equalTo: m_Email.text!)

        query.findObjectsInBackgroundWithBlock{(objects:[PFObject]?, error:NSError?) -> Void in
            self.m_ActivityIndicator.stopAnimating()
            self.m_ActivityIndicator.hidden = true
            self.m_LoginButton.enabled = true
            
            if (error == nil && objects != nil){
                if (objects?.count == 0){
                    self.showAlertWithError("Email or Password not correct", message: "Email or Password is not correct. Please retype your correct Email and password.")
                }
                else {
                    self.loadStatDataFromServer()
                }
            }
            else {
                self.showAlertWithError("Network Error", message: "Can't access database.")
            }
        }
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
    
    func loadStatDataFromServer(){
        m_ActivityIndicator.hidden = false
        m_LoginButton.hidden = true
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
                    self.presentViewController(controller, animated: true, completion: nil)
                }
            }
            else {
                self.m_LoginButton.hidden = false
                self.showAlertWithError("Network Error", message: "Can't access database.")
            }
        }
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
}

