//
//  ChooseViewController.swift
//  Steve's App
//
//  Created by Must on 2/2/16.
//  Copyright © 2016 Must. All rights reserved.
//

import Foundation
import UIKit
import MessageUI

struct StatData{
    var weekNum:Int
    var date: NSDate
    var gmNum: Int
    var teamName: String
    var lineNum: Float
    var selected: Bool
    
    init(weekNum:Int, date:NSDate, gmNum:Int, teamName:String, lineNum:Float, selected:Bool){
        self.weekNum = weekNum
        self.date = date
        self.gmNum = gmNum
        self.lineNum = lineNum
        self.selected = selected
        self.teamName = teamName
    }
}

class ChooseViewController : UIViewController, UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate{
    
    @IBOutlet weak var m_weekTitle: UILabel!
    
    @IBOutlet weak var m_DateTitle: UILabel!
    
    @IBOutlet weak var m_TimeTitle: UILabel!
    
    @IBOutlet weak var m_GMTitle: UILabel!
    
    @IBOutlet weak var m_TeamTitle: UILabel!
    
    @IBOutlet weak var m_Linetitle: UILabel!
    
    @IBOutlet weak var m_TitleView: UIView!
    
    @IBOutlet weak var m_StatTable: UITableView!
    
    var statDataArray : [StatData] = []
    
    var selectedTeamIndexArray : [Int] = []
    
    @IBOutlet weak var m_UserNAme: UITextField!
    
    
    let team : [String : String] = ["NY JETS" : "ny",
    "BUFFALO" : "buf",
    "TAMPA BAY" : "tb",
    "CAROLINA" : "car",
    "NEW ENGLAND" : "ne",
    "MIAMI" : "mia",
    "BALTIMORE" : "bal",
    "CINCINNATI" : "cin",
    "NEW ORLEANS" : "no",
    "ATLANTA" : "alt",
    "JACKSONVILLE" : "jax",
    "HOUSTON" : "hou",
    "PITTSBURGH" : "Pitts",
    "CLEVELAND" : "cle",
    "OAKLAND" : "oak",
    "KANSAS CITY" : "kc",
    "TENNESSEE" : "ten",
    "INDIANAPOLIS" : "ind",
    "WASHINGTON" : "was",
    "DALLAS" : "dal",
    "DETROIT" : "det",
    "CHICAGO" : "chi",
    "PHILADELPHIA" : "phi",
    "NY GIANTS" : "nyg",
    "MINNESOTA" : "min",
    "GREEN BAY" : "gb",
    "SAN DIEGO" : "sd",
    "DENVER" : "den",
    "ST. LOUIS" : "trim",
    "SAN FRANCISCO" : "sf",
    "SEATLE" : "sea",
    "ARIZONA" : "ari"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prefersStatusBarHidden() -> Bool{
        return false
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return (statDataArray.count / 2)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell:StatCell = tableView.dequeueReusableCellWithIdentifier("statCell") as! StatCell
        
        let index = indexPath.row
        let firstdata = statDataArray[index * 2]
        let seconddata = statDataArray[index * 2 + 1]
        
        cell.tableIndex = index
        
        cell.m_NFLWeekFirst.text = String(firstdata.weekNum)
        cell.m_NFLWeekSecond.text = String(seconddata.weekNum)
        
        let formater = NSDateFormatter()
        formater.dateFormat = "MM / dd"
        cell.m_DateFirst.text = formater.stringFromDate(firstdata.date)
        cell.m_DateSecond.text = formater.stringFromDate(seconddata.date)
        
        formater.dateFormat = "H : mm a"
        formater.AMSymbol = "am"
        formater.PMSymbol = "pm"
        cell.m_TimeFirst.text = formater.stringFromDate(firstdata.date)
        cell.m_TimeSecond.text = formater.stringFromDate(seconddata.date)
        
        cell.m_GMFirst.text = String(firstdata.gmNum)
        cell.m_GMSecond.text = String(seconddata.gmNum)
        
        cell.m_TeamFirst.text = firstdata.teamName
        cell.m_TMSecond.text = seconddata.teamName
        
        cell.m_TeamImgFirst.image = UIImage(named: team[firstdata.teamName]!)
        cell.m_TeamImageSecond.image = UIImage(named: team[seconddata.teamName]!)
        
        cell.m_LineFirst.text = getFloatString(firstdata.lineNum)
        cell.m_LineSecond.text = getFloatString(seconddata.lineNum)
        
        if (firstdata.selected == true){
            cell.m_OptionCheckFirst.image = UIImage(named: "option_ok")
        }
        else {
            cell.m_OptionCheckFirst.image = UIImage(named: "option_no")
        }
        
        if (seconddata.selected == true){
            cell.m_OptionCheckSecond.image = UIImage(named: "option_ok")
        }
        else {
            cell.m_OptionCheckSecond.image = UIImage(named: "option_no")
        }
        
        return cell
    }
    
    @IBAction func sendMail(sender: AnyObject) {
        if (m_UserNAme.text?.characters.count == 0){
            showAlertWithError("Enter your name", message: "Please enter your name.")
            return
        }
        
        if (selectedTeamIndexArray.count < 5){
            showAlertWithError("Must 5 Teams", message: "You can send 5 teams. Please select more teams.")
            return
        }
        
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients(["attilaher@outlook.com"])
        mailComposerVC.setSubject("Here are my 5 picks.")
        
        var body:String = "My five picks are \n"
        for (var i = 0; i < selectedTeamIndexArray.count; i++){
            let selectedIndex = selectedTeamIndexArray[i]
            let data:StatData = statDataArray[selectedIndex]
            body += "\(i + 1)." + data.teamName + "\n"
        }
        mailComposerVC.setMessageBody(body, isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        self.showAlertWithError("Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.")
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        if (result == MFMailComposeResultSent){
            showAlertWithError("Success", message: "Mail has been sent successfully.")
        }
        else {
            showAlertWithError("Failed", message: "Failed sending mail.")
        }
        
        controller.dismissViewControllerAnimated(true, completion: nil)
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
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        let touch : UITouch = touches.first!
        if (self.m_UserNAme.isFirstResponder() && (touch.view == self.m_UserNAme)){
            self.m_UserNAme.resignFirstResponder()
            return
        }
        self.view.endEditing(true)
    }
    
    func getFloatString(val: Float) -> String{
        let intVal : Int = Int(val)
        let frac : Float = val - Float(intVal)
        let demo: Int = frac == 0 ? 0 : Int(1 / frac)
        var retStr = String(intVal)
        if (demo != 0){
            retStr += " " + "1/" + String(demo)
        }
        return retStr
    }
}
