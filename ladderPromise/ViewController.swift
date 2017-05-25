//
//  ViewController.swift
//  ladderPromise
//
//  Created by Ivan Minier on 5/22/17.
//  Copyright © 2017 Ivan Minier. All rights reserved.
//

import UIKit

class ViewController: UIViewController, PromiseManagerDelegate, UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate {
    
    let promiseController = PromiseManager()

    @IBOutlet weak var mainTextField: UITextField!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!

    // Starts postData method and reloads tableview
    @IBAction func sendPressed(_ sender: UITextField) {
        promiseController.postData(url: "http://127.0.0.1:8000/promises/", promise: mainTextField.text!)
        promiseController.promises = []
        mainTextField.text = ""

    }
}

extension ViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        userImage.makeImageRound()
        promiseController.delegate = self
        promiseController.getData(url: "http://127.0.0.1:8000/promises/")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadedPromises() {
        tableview.reloadData()
    }

}

extension ViewController {
    // TableView Methods
    
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
    
}
