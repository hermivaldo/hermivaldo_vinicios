//
//  TotalViewController.swift
//  hermivaldo_vinicios
//
//  Created by Usuário Convidado on 23/04/18.
//  Copyright © 2018 fiap. All rights reserved.
//

import UIKit
import CoreData

class TotalViewController: UIViewController {

    @IBOutlet weak var lbFinalU: UILabel!
    @IBOutlet weak var lbFinalR: UILabel!
    
    var dolar = 0.0
    var iof = 0.0
    var dataSource: [Product] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        dolar = UserDefaults.standard.double(forKey: "dolar")
        iof = UserDefaults.standard.double(forKey: "iofCard")
        loadProduct()
        calcTotal()
    }
    

    func calcTotal(){
        var totalU = 0.0
        var totalR = 0.0
        var stateValue = 0.0
        var crediCardValue = 0.0
        var valueAfterAll = 0.0
        
        for produto in dataSource {
            stateValue = (produto.stateProduct?.iof)! * (produto.price / 100)
            crediCardValue = produto.iscard == true ? (produto.price/100) * iof : 0
            valueAfterAll += stateValue + crediCardValue + produto.price
             totalU += produto.price
        }
        
        totalR = valueAfterAll * dolar
        
        lbFinalU.text = self.currencyFormatter.string(from: totalU as NSNumber)
        lbFinalR.text = self.currencyFormatter.string(from: totalR as NSNumber)
    }

    func loadProduct() {
        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            dataSource = try context.fetch(fetchRequest)
        }catch {
            print(error.localizedDescription)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}
