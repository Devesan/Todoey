//
//  ViewController.swift
//  Todoey
//
//  Created by Devesan G on 30/08/18.
//  Copyright © 2018 Devesan G. All rights reserved.
//

import UIKit
import CoreData
class TodoListViewController: UITableViewController{

    var itemArray =  [Item]()
    
    var selectedCategory : Category?{
        
        didSet{
            loadItem()
        }
    }
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
      

     
    }

    //MARK: - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
        
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row].title
        
        
        cell.accessoryType = itemArray[indexPath.row].done ? .checkmark : .none
        return cell
        
    }
    
    //MARK: - Tableview Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemarray[indexPath.row])
        
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)

        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK: - Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert =  UIAlertController(title: "Add New Todoey item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default){ (action) in
            
            
            let newitem = Item(context: self.context)
            newitem.title=textField.text!
            newitem.done = false
            newitem.parentCategory = self.selectedCategory
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

    //MARK: - Model Manipulation Methods
func saveItems(){
    
    do{
        try context.save()
    }
    catch {
        print("Error saving context \(error)")
    }
     tableView.reloadData()
}
    func loadItem(with request : NSFetchRequest<Item> = Item.fetchRequest(),predicate: NSPredicate? = nil){

        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
      let categorypredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate{
            
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categorypredicate , additionalPredicate])
        }
        else{
            request.predicate = categorypredicate
        }
        
        do {
           itemArray =  try context.fetch(request)
        }
        catch{
            print("Error fetching data \(error)")
        }
           tableView.reloadData()
    }
   
}
//MARK: - Searchbar Methods
    extension TodoListViewController :UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()

        let predicate = NSPredicate(format : "title CONTAINS[cd] %@" , searchBar.text! )
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
      
        loadItem(with: request , predicate : predicate)
        
    }
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            if searchBar.text?.count == 0 {
                loadItem()
                DispatchQueue.main.async {
                    searchBar.resignFirstResponder()
                }
                
            }
        }
}
