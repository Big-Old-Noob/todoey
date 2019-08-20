//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Langxing Daniel Bai [STUDENT] on 2019/8/17.
//  Copyright © 2019 Daniel Bai. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    var categoryArr = [Category]()
    let categoryContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
    }
    
    //MARK: - TableView Datasource Method
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArr.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categoryArr[indexPath.row].name
        return cell
    }
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC  = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArr[indexPath.row]
        }
        
    }
    //MARK: - Data Manipulation Methods
    func saveItems () {
        do {
            try categoryContext.save()
        } catch {
            print("Error occur when saving : \(error)")
        }
        tableView.reloadData()
    }
    
    func loadItems (with request : NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            categoryArr = try categoryContext.fetch(request)
        } catch {
            print("Error occur when loading items: \(error)")
        }
        tableView.reloadData()
    }
    //MARK: - Add New Categories

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add Todoey Item", message: "", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Add new item", style: .default) { (action) in
            let newItem = Category(context: self.categoryContext)
            newItem.name = textField.text
            self.categoryArr.append(newItem)
            self.saveItems()
        }
        alert.addTextField { (altertTextField) in
            altertTextField.placeholder = "Enter new item"
            textField = altertTextField
        }
        alert.addAction(alertAction)
        present(alert, animated: true, completion: nil)
    }
    

    
}
