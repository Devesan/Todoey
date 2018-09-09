//
//  ViewController.swift
//  Todoey
//
//  Created by Devesan G on 30/08/18.
//  Copyright © 2018 Devesan G. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController{

    var itemArray =  [Item]()
    let defaults = UserDefaults.standard
    
    let datafilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print(datafilePath!)
       
        loadItem()
    }

    //MARK - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
        
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row].title
        
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        return cell
        
    }
    
    //MARK - Tableview Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemarray[indexPath.row])
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK - Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert =  UIAlertController(title: "Add New Todoey item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default){ (action) in
            
            let newitem = Item()
            newitem.title=textField.text!
            self.itemArray.append(newitem)
            self.saveItems()
            
    }
        alert.addTextField{( alertTextField) in
            alertTextField.placeholder = " Enter new items "
            
            textField = alertTextField
            
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }

    //MARK - Model Manipulation Methods
func saveItems(){
    let encoder = PropertyListEncoder()
    do{
        
        let data = try encoder.encode(itemArray)
        try data.write(to:datafilePath!)
    }
    catch {
        print("Error encoding itemarray,\(error)")
    }
     tableView.reloadData()
}
    func loadItem(){
        
        if let data = try? Data(contentsOf: datafilePath!){
            let decoder = PropertyListDecoder()
            do{
                 itemArray = try decoder.decode([Item].self, from: data)
        }
            catch{
                print("Error decoding the array \(error)")
            }
    }
}
}
