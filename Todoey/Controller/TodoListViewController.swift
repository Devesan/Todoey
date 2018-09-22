//
//  ViewController.swift
//  Todoey
//
//  Created by Devesan G on 30/08/18.
//  Copyright © 2018 Devesan G. All rights reserved.
//

import UIKit
import RealmSwift
class TodoListViewController: UITableViewController{

    var todoItems : Results<Item>?
    let realm = try! Realm()
    var selectedCategory : Category?{
        
        didSet{
            loadItem()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
      

     
    }

    //MARK: - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
        
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row] {
        cell.textLabel?.text = item.title
            
        cell.accessoryType = item.done ? .checkmark : .none
            
        }
        else{
            cell.textLabel?.text = "No Item Added"
        }
        return cell
        
    }
    
    //MARK: - Tableview Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row]{
            do{
                try realm.write {
                
                    item.done = !item.done
            }
            }
            catch{
                print("error updating the data \(error)")
            }
        }
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK: - Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert =  UIAlertController(title: "Add New Todoey item", message: "", preferredStyle: .alert)

        let action = UIAlertAction(title: "Add Item", style: .default){ (action) in

            if let currentCategory = self.selectedCategory{
                do{
                try self.realm.write {
                    let newItem = Item()
                    newItem.title = textField.text!
                    newItem.dateCreated = Date()
                    currentCategory.items.append(newItem)
                    
                }
                }
                    catch{
                            print("Error saving data \(error)")
                    }
            }
           self.tableView.reloadData()
    }
        alert.addTextField{( alertTextField) in
            alertTextField.placeholder = " Enter new items "

            textField = alertTextField

        }
        alert.addAction(action)

        present(alert, animated: true, completion: nil)
        tableView.reloadData()
    }


    func loadItem(){
            todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
}
}
//MARK: - Searchbar Methods
    extension TodoListViewController :UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

         todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()

    }
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            if searchBar.text?.count == 0 {
                loadItem()
                DispatchQueue.main.async {
                    searchBar.resignFirstResponder()
                }
//
            }
        }

}
