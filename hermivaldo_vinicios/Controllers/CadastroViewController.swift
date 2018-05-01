//
//  CadastroViewController.swift
//  hermivaldo_vinicios
//
//  Created by Usuário Convidado on 23/04/18.
//  Copyright © 2018 fiap. All rights reserved.
//

import UIKit

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
    
    // MARK: - methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
        
        
        // verificar se tem camera disponivel para nao dar problemas no simulador.
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
    
    // MARK: - METHODS
    
    func isMoney (sender: UITextField) -> Bool {
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
    
    func enableSubmit(){
        if !(tvProdName.text?.isEmpty)! && !(tvPrice.text?.isEmpty)!
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

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

