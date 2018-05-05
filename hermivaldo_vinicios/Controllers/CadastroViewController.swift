//
//  CadastroViewController.swift
//  hermivaldo_vinicios
//
//  Created by Usuário Convidado on 23/04/18.
//  Copyright © 2018 fiap. All rights reserved.
//

import UIKit
import CoreData

class CadastroViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var tvProdName: UITextField!
    @IBOutlet weak var tvState: UITextField!
    @IBOutlet weak var tvPrice: UITextField!
    @IBOutlet weak var sCard: UISwitch!
    @IBOutlet weak var btSubmit: UIButton!
    @IBOutlet weak var ivProduct: UIImageView!
    
    
    // MARK: properties
    var smallImage: UIImage!
    var pickerView: UIPickerView!
    var dataSource:[State] = []
    var product: Product!
    
    // MARK: - methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pickerView = UIPickerView()
        
        pickerView.backgroundColor = .white
        pickerView.delegate = self
        pickerView.dataSource = self
        
        let toobar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.height))
        
        let btCancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        let btSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let btDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        
        toobar.items = [btCancel, btSpace, btDone]
        tvState.inputView = pickerView
        tvState.inputAccessoryView = toobar
     
    }
    
    func loadState() {
        let fetchRequest: NSFetchRequest<State> = State.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            dataSource = try context.fetch(fetchRequest)
        }catch {
            print(error.localizedDescription)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadState()
        if product != nil {
            let price = self.currencyFormatter.string(from: product.price as NSNumber)
            tvPrice.text = price
            tvProdName.text = product?.name
            let state = product?.stateProduct
            tvState.text = state?.name
            sCard.isOn = product.iscard
            btSubmit.setTitle("Editar", for: .normal)
            if let image = product.poster as? UIImage {
                ivProduct.image = image
            }
        }
       
    }
    @IBAction func changeSwitch(_ sender: Any) {
        enableSubmit()
    }
    
    @objc func cancel() {
        tvState.resignFirstResponder()
    }

    @objc func done() {
        if (dataSource.count > 0){
            tvState.text = dataSource[pickerView.selectedRow(inComponent: 0)].name

        }
        cancel()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - IBAction
    
    @IBAction func inputMoney(_ sender: UITextField) {
        var _ = isMoney(sender: sender)
        enableSubmit()
    }
    
    @IBAction func inputValue(_ sender: Any) {
        enableSubmit()
    }
    
    @IBAction func selectImage(_ sender: Any) {
        
        let alert = UIAlertController(title: "Selecionar imagem do produto", message: "Qual local da foto do produto", preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action: UIAlertAction) in
               self.selectPicture(sourceType: .camera)
            }
            alert.addAction(cameraAction)
        }
        
        let libraryAction = UIAlertAction(title: "Biblioteca de fotos", style: .default) { (action: UIAlertAction) in
            self.selectPicture(sourceType: .photoLibrary)
        }
        alert.addAction(libraryAction)
        
        let photosAction = UIAlertAction(title: "Álbum de fotos", style: .default) { (action: UIAlertAction) in
            self.selectPicture(sourceType: .savedPhotosAlbum)
        }
        alert.addAction(photosAction)
        let cancel = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
        
    }
    
    
    @IBAction func submitProdutct(_ sender: Any) {
        if product == nil {
            product = Product(context: self.context)
        }
        
        product.name = tvProdName.text
        guard let price = currencyFormatter.number(from: tvPrice.text!)?.doubleValue else {return }
        product.price = price
        product.iscard = sCard.isOn
        
        if smallImage != nil {
            product.poster = smallImage
        }
        
        if let state = dataSource.index(where: {$0.name == tvState.text!}){
            product.stateProduct = dataSource[state]
        }
        
        do {
            try context.save()
            self.navigationController?.popViewController(animated: true)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @IBAction func close(_ sender: Any) {
        if (product != nil && product.name == nil) {
            context.delete(product)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - METHODS
    func isMoney (sender: UITextField) -> Bool {
        guard let money = sender.text else {
            return false
        }
        guard let _ = currencyFormatter.number(from: money) else {
            sender.text = String(money.dropLast())
            return false
        }
        return true
    }
    
    func enableSubmit(){
        if !(tvProdName.text?.isEmpty)! && !(tvState.text?.isEmpty)!
            && !(tvPrice.text?.isEmpty)! {
            btSubmit.isEnabled = true
        }else {
            btSubmit.isEnabled = false
        }
    }
    
    func selectPicture(sourceType: UIImagePickerControllerSourceType){
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
        
    }

}

// MARK: - UIImagePickerControllerDelegate
extension CadastroViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        let smallSize = CGSize(width: 300, height: 280)
        
        UIGraphicsBeginImageContext(smallSize)
        image.draw(in: CGRect(x: 0, y: 0, width: smallSize.width, height: smallSize.height))
        
        smallImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        ivProduct.image = smallImage
        
        dismiss(animated: true, completion: nil)
    }
}

extension CadastroViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataSource[row].name
    }
    
}

extension CadastroViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataSource.count
    }
    
    
}
