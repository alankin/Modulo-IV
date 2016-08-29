//
//  LoginViewController.swift
//  CComunities
//
//  Created by NICAELA on 26/8/16.
//  Copyright © 2016 QUIÑONES ALVAREZ ALAIN. All rights reserved.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    var users = [User]()
    
    let prefixPassword = "password"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUsers()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    @IBAction func login(sender: UIButton) {
        let username = usernameTextField.text
        let password = passwordTextField.text
        let user = getUser(username!, password: password!)
        
        if(user.userId > -1){
            // login succesfull
            // Save user_id on properties
            saveOnProperties(user.userId, property: "user_id")
            
            goToPublications()
            
        }else{
            //login failed
            print("Login failed")
        }
    }
    
    func goToPublications(){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
    
        let tabBarController = storyBoard.instantiateViewControllerWithIdentifier("TabBarController") as! UITabBarController
        self.presentViewController(tabBarController, animated:true, completion:nil)
    
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
    
    func getUser(username:String, password:String) -> User{
        var userRes = User()
        
        for user in self.users{
            if user.username == username &&  password == getPassword(user.userId){
                userRes = user
                break
            }
        }
        
        return userRes!
    }
    
    func getPassword(id:Int) -> String{
        return prefixPassword + String(id)
    }
    
    func loadUsers(){
            // populate using Rest
            Alamofire.request(.GET, "https://ccomunities.herokuapp.com/users")
                .responseJSON { response in
                    if let restUsers = response.result.value {
                        //print("JSON: \(restUsers)")
                        for user in restUsers as! [AnyObject] {
                            let newUser = User(userId: user["id"]!!.integerValue, username: user["username"]!! as! String, name: user["name"]!! as! String, lastName: user["name"]!! as! String, email: user["email"]!! as! String, photo:UIImage(named: "User")!)
                            self.users.append(newUser!)
                        }
                    }
            }
            
    }

}
