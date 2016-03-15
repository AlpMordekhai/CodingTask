//
//  UserListTableViewController.swift
//  CodingTask_Futurice
//
//  Created by Alberto Lopez on 13/03/16.
//  Copyright © 2016 AlbertoLopez. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD

class UserListTableViewController: UITableViewController, UserListDataSource {

    var userListInterface = DataRetrievalModule()
    var userArray:[UserStructs] = []
    
    // MARK: - webServiceDelegate
    /**
    Retrieves the user list , sorts it and removes the loading spinner
    */
    func getUserList(controller: DataRetrievalModule, usersArray:[UserStructs])
    {
        MBProgressHUD.hideAllHUDsForView(self.navigationController!.view, animated: true)
        self.userArray = usersArray.sort { $0.userName < $1.userName }
        self.tableView.reloadData()
    }

    /**
     Calls the web service module for the user list
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        let loadingNotification = MBProgressHUD.showHUDAddedTo(self.navigationController!.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        userListInterface.userListDelegate = self
        userListInterface.getUserList()
    }


    // MARK: - Table view data source and delegates
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userArray.count
    }

    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.alpha = 0.0
        UIView.animateWithDuration(1.0, animations: {cell.alpha = 1.0})
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("userListCell", forIndexPath: indexPath) as! UserListTableViewCell
        let selectedUser = self.userArray[indexPath.row]
        cell.lblName.text = selectedUser.userName
        cell.lblSubtitle.text = selectedUser.nameTag
        cell.lblUppercase.text = String(selectedUser.userName.characters.first!).uppercaseString
        return cell
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "userProfileSegue") {
            let newVC:UserProfileViewController = segue.destinationViewController as! UserProfileViewController
            let selectedUser = self.userArray[self.tableView.indexPathForSelectedRow!.row]
            newVC.userId = selectedUser.userId
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}
