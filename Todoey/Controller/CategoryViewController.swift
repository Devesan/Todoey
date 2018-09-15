//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Devesan G on 13/09/18.
//  Copyright © 2018 Devesan G. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    
    var categoryArray = [Category]()
    let context =  (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategory()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    // MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categoryArray[indexPath.row].name
        
        return cell
    }
    
     //MARK: - Data Manipulation Methods
    
    func saveCategory(){
        
        do{
            try context.save()
        }
        catch{
            print("Error Saving Data \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategory(with request : NSFetchRequest<Category> = Category.fetchRequest()){
        
        do{
            categoryArray = try context.fetch(request)
        }
        catch{
            print("Error Fetching Data \(error)")
        }
    }

    //MARK: - Add button Pressed
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textfield = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default){ (action) in
            
            let newCategory = Category(context: self.context)
            newCategory.name = textfield.text!
            self.categoryArray.append(newCategory)
            self.saveCategory()
            
        }
        alert.addTextField{(alertTextField) in
            alertTextField.placeholder = "Enter New Category"
            textfield = alertTextField
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
   
    
    // MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "gotoItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categoryArray[indexPath.row]
            
        }
    }
}

