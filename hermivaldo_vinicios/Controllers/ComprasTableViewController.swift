//
//  ComprasTableViewController.swift
//  hermivaldo_vinicios
//
//  Created by Usuário Convidado on 23/04/18.
//  Copyright © 2018 fiap. All rights reserved.
//

import UIKit
import CoreData

class ComprasTableViewController: UITableViewController {

    var dataSource: [Product] = []
    var fechedResultController: NSFetchedResultsController<Product>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadProduct()
    }

    func loadProduct() {
        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fechedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fechedResultController.delegate = self
        
        do {
            try fechedResultController.performFetch()
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (!sender.debugDescription.contains("Add")){
            if let vc = segue.destination as? CadastroViewController {
                vc.product = fechedResultController.object(at: tableView.indexPathForSelectedRow!)
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = fechedResultController.fetchedObjects?.count{
            return count
        }else {
            return 0
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellCompras", for: indexPath)
        let product = fechedResultController.object(at: indexPath)
        cell.textLabel?.text = product.name
        cell.detailTextLabel?.text = "\(product.price)"
        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let product = fechedResultController.object(at: indexPath)
            context.delete(product)
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

extension ComprasTableViewController: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
    
}
