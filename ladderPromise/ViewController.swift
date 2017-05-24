//
//  ViewController.swift
//  ladderPromise
//
//  Created by Ivan Minier on 5/22/17.
//  Copyright © 2017 Ivan Minier. All rights reserved.
//

import UIKit

class ViewController: UIViewController, PromiseManagerDelegate, UITableViewDataSource, UITableViewDelegate {
    
    let promiseController = PromiseManager()

    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!

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
    
}
