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
        print("\(username!) \(password!)")
        // hacer la conexion con el servicio rest
        // guardar en el property el id del usuario que se esta logueando
    }
    
    func loadUsers(){
            // populate using Rest
            Alamofire.request(.GET, "https://ccomunities.herokuapp.com/users")
                .responseJSON { response in
                    if let JSON = response.result.value {
                        print("JSON: \(JSON)")
                    }
            }
            
    }

}
