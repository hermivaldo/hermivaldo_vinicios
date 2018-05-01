//
//  ViewController.swift
//  hermivaldo_vinicios
//
//  Created by Usuário Convidado on 23/04/18.
//  Copyright © 2018 fiap. All rights reserved.
//

import UIKit

enum OperationType {
    case add
    case edit
}

class ViewController: UIViewController {
    
    var alert: UIAlertController?
    
    @IBOutlet weak var iofCard: UITextField!
    @IBOutlet weak var dolarValue: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - BEGIN METHODS
    
    func showAlert(type: OperationType){
        let title = (type == .add) ? "Adicionar" : "Editar"
        self.alert = UIAlertController(title: "\(title) Estado", message: nil, preferredStyle: .alert)
        
        alert?.addTextField { (textField: UITextField) in
            textField.placeholder = "Nome do estado"
            textField.addTarget(self, action: #selector(self.alertTextDidChange), for: .editingChanged)
        }
        
        alert?.addTextField { (textField: UITextField) in
            textField.placeholder = "IOF do estado"
            textField.keyboardType = .numbersAndPunctuation
            textField.addTarget(self, action: #selector(self.alertTextDidChange), for: .editingChanged)
        }
        
        let submit = UIAlertAction(title: title, style: .default, handler: { (action: UIAlertAction) in
            
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
        let currencyFormatter =  NumberFormatter()
        
        guard let money = sender.text else {
            return false
        }
        
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.locale = Locale.current
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
        showAlert(type: .add)
    }
    
    // MARK: - END IOBounds
    
}

