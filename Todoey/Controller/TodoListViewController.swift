//
//  ViewController.swift
//  Todoey
//
//  Created by Langxing Daniel Bai [STUDENT] on 2019/8/14.
//  Copyright © 2019 Daniel Bai. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController{
    
    var itemArr : Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        if let items = defaults.array(forKey: "ToDoListArray") as? [Item] {
//            itemArr = items
        
//        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArr?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = itemArr?[indexPath.row] {
            cell.textLabel?.text = item.title
            
            (item.done == true) ? (cell.accessoryType = .checkmark) : (cell.accessoryType = .none)
        } else {
            cell.textLabel?.text = "No item added"
        }
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArr[indexPath.row])
        if let item = itemArr?[indexPath.row] {
            do {
                try realm.write {
                    /*
                     deleting item in realm
                     realm.delete(item)
                    */
                    item.done = !item.done
                }
            } catch {
                print("Error saving item: \(error)")
            }
        }
        
        //itemArr[indexPath.row].done = !itemArr[indexPath.row].done
        /*
        Deleting Item using core data
        context.delete(itemArr[indexPath.row])
        itemArr.remove(at: indexPath.row)
        saveItem()
        */
        //saveItem()

        tableView.reloadData()
        
        //tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add new item", style: .default) { (action) in
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        print("\(newItem.dateCreated)")
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error occur while saving \(error)")
                }
            }
            self.tableView.reloadData()
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    func loadItems() {
        
        itemArr = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
//        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,predicate])
//
//        request.predicate = compoundPredicate
        
        tableView.reloadData()
    }
    
    
}

extension TodoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        itemArr = itemArr?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
 }

