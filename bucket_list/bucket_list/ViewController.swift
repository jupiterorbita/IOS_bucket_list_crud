//
//  ViewController.swift
//  bucket_list
//
//  Created by J on 7/10/2018.
//  Copyright © 2018 Jman. All rights reserved.
//
// ========= MAIN VIEW CONTROLLER ===========
import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var tableData: [String] = ["test", "test2"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }

    // save functionality - see if editing or saving
    @IBAction func unwindToViewController(segue: UIStoryboardSegue) {
        let src = segue.source as! AddItemVC
        let text = src.textField.text!
        
        if let indexPath = src.indexPath {
            tableData[indexPath.row] = text
        } else {
            tableData.append(text)
        }
        print(text)
        tableView.reloadData()
    }
    
    
    @IBAction func AddPressed(_ sender: UIBarButtonItem) {
        print("AddPressed")
        performSegue(withIdentifier: "AddEditSegue", sender: sender)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //check who is sending data to the other side
        if let indexPath = sender as? IndexPath {
            print("came from CELL pressed")
            let text = tableData[indexPath.row]
            let nav = segue.destination as! UINavigationController
            let dest = nav.topViewController as! AddItemVC
            dest.item = text
            dest.indexPath = indexPath
        } else {
            print("came from BAR button")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath)
        cell.textLabel?.text = tableData[indexPath.row]
        return cell
    }
    
    //edit
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "AddEditSegue", sender: indexPath)
    }
    
    //swipe to delete
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete", handler: { action, view, done in
            
            self.tableData.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
//            tableView.reloadData()
            
            done(true)
        })
        
        
        let swipeConfig = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipeConfig
    }
    
}
