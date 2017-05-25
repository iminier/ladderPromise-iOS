//
//  ViewController.swift
//  ladderPromise
//
//  Created by Ivan Minier on 5/22/17.
//  Copyright © 2017 Ivan Minier. All rights reserved.
//

import UIKit

class ViewController: UIViewController, PromiseManagerDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // Decalre constants
    let promiseController = PromiseManager()

    // Declare variables
    @IBOutlet weak var mainTextField: UITextField!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var uiPickerPromises: UIPickerView!
    @IBOutlet weak var errorLabel: UILabel!

    // Start postData method and reloads tableview when the Send button is pressed from keyboard
    @IBAction func sendPressed(_ sender: UITextField) {
        
        // Check to see promise begins with "I will" or "I won't"
        if (mainTextField.text?.hasPrefix("I will"))! || (mainTextField.text?.hasPrefix("I won't"))! {
            promiseController.postData(url: "http://127.0.0.1:8000/promises/", promise: mainTextField.text!)
            promiseController.promises = []
            mainTextField.text = ""
            
            // Remove error label in event it was displayed previously
            if errorLabel.alpha == 1 {
                errorLabel.alpha = 0
            }
            
        } else {
             errorLabel.alpha = 1 // Display error label
        }

    }
}

extension ViewController {
    
    // Load data and view
    override func viewDidLoad() {
        super.viewDidLoad()
        userImage.makeImageRound()
        uiPickerPromises.delegate = self
        uiPickerPromises.dataSource = self
        promiseController.delegate = self
        promiseController.getData(url: "http://127.0.0.1:8000/promises/")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

// TableView methods
extension ViewController {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return promiseController.promises.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = promiseController.promises[indexPath.row].promise
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        let idInt = promiseController.promises[indexPath.row].id!
        let id = String(describing: idInt)
        
        if editingStyle == UITableViewCellEditingStyle.delete {
            
            promiseController.deleteData(url: "http://127.0.0.1:8000/promises/" + (id))
            promiseController.promises.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func loadedPromises() {
        tableview.reloadData()
    }
}

// PickerView methods
extension ViewController {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return promiseController.promiseSuggestions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return promiseController.promiseSuggestions[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        mainTextField.text = promiseController.promiseSuggestions[row]
    }
}
