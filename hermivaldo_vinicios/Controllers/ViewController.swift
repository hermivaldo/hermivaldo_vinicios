//
//  ViewController.swift
//  hermivaldo_vinicios
//
//  Created by Usuário Convidado on 23/04/18.
//  Copyright © 2018 fiap. All rights reserved.
//

import UIKit
import CoreData

enum OperationType {
    case add
    case edit
}

class ViewController: UIViewController {
    
    var alert: UIAlertController?
    let currencyFormatter =  NumberFormatter()
    var dataSource: [State] = []
    
    @IBOutlet weak var iofCard: UITextField!
    @IBOutlet weak var dolarValue: UITextField!
    @IBOutlet weak var tableViewStates: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableViewStates.delegate = self
        self.tableViewStates.dataSource = self
        
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.locale = Locale.current
        currencyFormatter.minimumFractionDigits = 2
        
        // Do any additional setup after loading the view, typically from a nib.
        loadState()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func loadState() {
        let fetchRequest: NSFetchRequest<State> = State.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            dataSource = try context.fetch(fetchRequest)
            tableViewStates.reloadData()
        }catch {
            print(error.localizedDescription)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - BEGIN METHODS
    
    func showAlert(type: OperationType, state: State?){
        let title = (type == .add) ? "Adicionar" : "Editar"
        self.alert = UIAlertController(title: "\(title) Estado", message: nil, preferredStyle: .alert)
        
        alert?.addTextField { (textField: UITextField) in
            textField.placeholder = "Nome do estado"
            if let name = state?.name{
                textField.text = name
            }
            textField.addTarget(self, action: #selector(self.alertTextDidChange), for: .editingChanged)
        }
        
        alert?.addTextField { (textField: UITextField) in
            textField.placeholder = "IOF do estado"
            textField.keyboardType = .numbersAndPunctuation
            if let iof = state?.iof {
                textField.text = self.currencyFormatter.string(from: iof as NSNumber)
            }
            textField.addTarget(self, action: #selector(self.alertTextDidChange), for: .editingChanged)
        }
        
        let submit = UIAlertAction(title: title, style: .default, handler: { (action: UIAlertAction) in
            let state = state ?? State(context: self.context)
            
            guard let name = self.alert?.textFields?.first?.text else { return }
            
            state.name = name
            
            guard let value = self.currencyFormatter.number(from: (self.alert?.textFields?.last?.text)!)?.doubleValue else { return }
            
            state.iof = value
            
            do {
                try self.context.save()
                self.loadState()
            }catch {
                print(error.localizedDescription)
            }
            
        })
        
        submit.isEnabled = false
        
        alert?.addAction(submit)
        
        alert?.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        present(alert!, animated: true, completion: nil)
    }
    
    @IBAction func inputMoney(_ sender: UITextField) {
        var _ = isMoney(sender)
    }
    
    @objc func isMoney(_ sender: UITextField) -> Bool{
        
        guard let money = sender.text else {
            return false
        }
        
        guard let _ = currencyFormatter.number(from: money) else {
            sender.text = String(money.dropLast())
            return false
        }
        return true
    }
    
    @objc func alertTextDidChange(sender: UITextField) {
        guard let nmState = alert?.textFields?.first?.text, let iofState = alert?.textFields?.last?.text, let submitAction = alert?.actions.first
            else {return}
        
        if isMoney((alert?.textFields?.last)!) {
            submitAction.isEnabled = nmState.count > 1 && iofState.count > 0
        }else {
            submitAction.isEnabled = false
        }
        
    }
    
    
    // MARK: - END METHOTDS
    
    // MARK: - BEGIN IOBounds
    
    
    
    @IBAction func allertAddState(_ sender: Any) {
        showAlert(type: .add, state: nil)
    }
    
    // MARK: - END IOBounds
    
}

extension ViewController : UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Excluir") { (action: UITableViewRowAction, indexPath: IndexPath) in
            let state = self.dataSource[indexPath.row]
            self.context.delete(state)
            try! self.context.save()
            self.dataSource.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        let editAction = UITableViewRowAction(style: .normal, title: "Editar") { (action: UITableViewRowAction, indexPath: IndexPath) in
            
            let state = self.dataSource[indexPath.row]
            tableView.setEditing(false, animated: true)
            self.showAlert(type: .edit, state: state)
            
        }
        
        return [editAction ,deleteAction]
    }
    
}

extension ViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewStates.dequeueReusableCell(withIdentifier: "cellState", for: indexPath)
        let state = dataSource[indexPath.row]
        cell.textLabel?.text = state.name
        return cell
    }
    
    
}
