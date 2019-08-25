//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Langxing Daniel Bai [STUDENT] on 2019/8/17.
//  Copyright © 2019 Daniel Bai. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
    var categoryArr : Results<Category>?
  
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
    }
    
    //MARK: - TableView Datasource Method
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArr?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categoryArr?[indexPath.row].name
        return cell
    }
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC  = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArr?[indexPath.row]
        }
        
    }
    //MARK: - Data Manipulation Methods
    func saveItems (category : Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error occur when saving : \(error)")
        }
        tableView.reloadData()
    }
    
    func loadItems () {
        categoryArr = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    //MARK: - Add New Categories

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add Todoey Category", message: "", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Add new category", style: .default) { (action) in
            let newItem = Category()
            newItem.name = textField.text!
            self.saveItems(category: newItem)
        }
        alert.addTextField { (altertTextField) in
            altertTextField.placeholder = "Enter new category"
            textField = altertTextField
        }
        alert.addAction(alertAction)
        present(alert, animated: true, completion: nil)
    }
    

    
}
