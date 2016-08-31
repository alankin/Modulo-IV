//
//  PublicationTableViewController.swift
//  CComunities
//
//  Created by NICAELA on 27/8/16.
//  Copyright © 2016 QUIÑONES ALVAREZ ALAIN. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class PublicationTableViewController: UITableViewController {
    
    var publications = [Publication]()
    var users = [User]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        verifyLogin()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //print("Cantidad de publicaciones creadas: \(publications.count)")
        return publications.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "PublicationTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! PublicationTableViewCell
        
        // Fetches the appropriate meal for the data source layout.
        let post = publications[indexPath.row]
        
        cell.titleLabel.text = post.title
        cell.descriptionTextView.text = post.description
        cell.responsableLabel.text = post.responsable
        cell.dateLabel.text = post.date

        return cell
    }
    
    func createPostExample(){
        let post1 = Publication(title: "Taller de maestros", description: "Una descripcion breve descripcion breve descripcion breve descripcion breve descripcion breve descripcion breve", responsable: "Nicaela Onofre", date: "02-11-2016")!;
        let post2 = Publication(title: "Reunión del ministerio jovenes", description: "Una reunion de emergencia descripcion breve descripcion breve descripcion breve descripcion breve descripcion breve descripcion breve", responsable: "Alain Quinones", date: "22-11-2016")!;
        
        publications += [post1]
        publications += [post2]
    }
    
    func verifyLogin(){
        loadUsers()
        if(!isLogged()){
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let loginViewController = storyBoard.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
            self.presentViewController(loginViewController, animated:false, completion:nil)
        }else{
            loadPublications()
        }
    }
    
    func isLogged() -> Bool{
        //TODO: Change this value to false when rest service is integrated
        var logged = false
        
        let preferences = NSUserDefaults.standardUserDefaults()
        
        let user_id = "user_id"
        
        if preferences.integerForKey(user_id) != -1 {
            logged = true
        }
        
        return logged;
    }
    
    func loadPublications() {
        //createPostExample();
        loadRestPublications();
    }
    
    func loadUsers(){
        Alamofire.request(.GET, "https://ccomunities.herokuapp.com/users")
            .responseJSON {response in
                //Parseo
                let json = JSON(data: response.data!)
                
                for(key, subJson):(String, JSON) in json{
                    //create Publication object
                    let newUser = User(userId: subJson["id"].int!, username: subJson["username"].string!, name: subJson["name"].string!, lastName: subJson["last_name"].string!, email: subJson["email"].string!, photo: UIImage(named: "User")!)
                    
                    self.users.append(newUser!)
                }
        }
    }
    
    func loadRestPublications() {
        // populate using Rest
        Alamofire.request(.GET, "https://ccomunities.herokuapp.com/publications")
            .responseJSON {response in
                //Parseo
                let json = JSON(data: response.data!)
                
                for(key, subJson):(String, JSON) in json{
                    //create Publication object
                    let username = self.getUsername(subJson["responsible_id"].int!)
                    let newPublication = Publication(title: subJson["title"].string!, description: subJson["description"].string!, responsable: username, date: subJson["date"].string!)
                    
                    self.publications.append(newPublication!)
                    //reload table
                    self.tableView.reloadData()
                    
                }
        }
    }
    
    func getUsername (userId:Int) -> String {
        var res = ""
        for user in users {
            if user.userId == userId {
                res = "\(user.name) \(user.lastName)"
                break
            }
        }
        return res
    }
    
    @IBAction func logout(sender: AnyObject) {
        saveOnProperties(-1, property: "user_id")
        			
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let loginViewController = storyBoard.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
        self.presentViewController(loginViewController, animated:false, completion:nil)
    }
    
    func saveOnProperties(id:Int, property:String){
        let preferences = NSUserDefaults.standardUserDefaults()
        
        preferences.setInteger(id, forKey: property)
        
        //  Save to disk
        let didSave = preferences.synchronize()
        
        if !didSave {
            print("There was a problem saving the id");
        }else{
            print("Saved on properties! id: \(id)");
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
