//
//  ViewController.swift
//  CComunities
//
//  Created by QUIÑONES ALVAREZ ALAIN on 20/8/16.
//  Copyright © 2016 QUIÑONES ALVAREZ ALAIN. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var responsableTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextView!
    
    
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var publication: Publication?
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUsers()
        // Do any additional setup after loading the view, typically from a nib.
        responsableTextField.delegate = self
        titleTextField.delegate = self
        //descriptionTextField.delegate = self
        
        checkValidPublication()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getUserLoggedId() -> Int{
        let preferences = NSUserDefaults.standardUserDefaults()
        return preferences.integerForKey("user_id");
    }
    
    func loadUsers(){
        let userId = getUserLoggedId()
        
        Alamofire.request(.GET, "https://ccomunities.herokuapp.com/users")
            .responseJSON {response in
                //Parseo
                let json = JSON(data: response.data!)
                
                for(key, subJson):(String, JSON) in json{
                    //create Publication object
                    let newUser = User(userId: subJson["id"].int!, username: subJson["username"].string!, name: subJson["name"].string!, lastName: subJson["last_name"].string!, email: subJson["email"].string!, photo: UIImage(named: "User")!)
                    
                    self.users.append(newUser!)
                    if userId == newUser!.userId {
                        self.responsableTextField.text = "\(newUser!.name) \(newUser!.lastName)"
                    }
                }
        }
    }

    @IBAction func cancel(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func dateTextField(sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = UIDatePickerMode.Date
        
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(ViewController.datePickerValueChanged), forControlEvents: UIControlEvents.ValueChanged)
        
    }
    
    func datePickerValueChanged(sender:UIDatePicker) {
    
        let dateFormatter = NSDateFormatter()
        
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
    
        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
    
        dateTextField.text = dateFormatter.stringFromDate(sender.date)
    
    }
    

    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        checkValidPublication()
        navigationItem.title = textField.text
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        // Disable the Save button while editing.
        saveButton.enabled = false
    }
    
    func checkValidPublication() {
        // Disable the Save button if the text field is empty.
        let responsable = responsableTextField.text ?? ""
        let title = titleTextField.text ?? ""
        saveButton.enabled = !responsable.isEmpty && !title.isEmpty
    }
    
    // This method lets you configure a view controller before it's presented.
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if saveButton === sender {
            let responsable = responsableTextField.text ?? ""
            let title = titleTextField.text ?? ""
            let description = descriptionTextField.text ?? ""
            let date = dateTextField.text ?? ""
            
            // Set the meal to be passed to MealListTableViewController after the unwind segue.
            publication = Publication(title: title, description: description, responsable: responsable, date: date)
            
            savePublicationRest(publication!)
        }
    }
    
    func savePublicationRest(publication: Publication){
        let parameters = [
            "responsible_id": getUserLoggedId(),
            "title": publication.title,
            "description": publication.description,
            "date": publication.date
        ]

        Alamofire.request(.POST, "https://ccomunities.herokuapp.com/publications", parameters: (parameters as! [String : AnyObject]), encoding: .JSON)
    }

}

