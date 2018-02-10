//
//  AddSubcategoryViewController.swift
//  AdminVolgaApp
//
//  Created by Syngmaster on 31/01/2018.
//  Copyright © 2018 Syngmaster. All rights reserved.
//

import UIKit

class AddSubcategoryViewController: UIViewController, UINavigationControllerDelegate {
    
    var category:String!
    var photoURL = ""
    let picker = UIImagePickerController()
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var subCatTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.activityIndicator.stopAnimating()
        photoURL = ""

        // Do any additional setup after loading the view.
        picker.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func addPhotoAction(_ sender: UIButton) {
        activityIndicator.startAnimating()
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(picker, animated: true, completion: nil)
        
    }
    
    @IBAction func saveAction(_ sender: UIButton) {
        
        activityIndicator.startAnimating()
        guard subCatTextField.text != "", photoURL != "" else {
            raiseAlert(title: "Warning", message: "Please add all information!")
            activityIndicator.stopAnimating()
            return
        }
        
        DataManager.sharedInstance.addSubcategory(title: subCatTextField.text, photoURL:photoURL, category: category, completion: { (result) in
            print("!!!!!!!!!addSubcategory!!!!!!!!!")
            self.activityIndicator.stopAnimating()
            if result {
                self.raiseAlert(title: "Success!", message: "Category is created!")
            } else {
                self.raiseAlert(title: "Warning!", message: "Category already exists!")
            }
        })
    }
    
    func raiseAlert(title: String!, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel) { (result) in
            self.navigationController?.popViewController(animated: true)
        }
        alertVC.addAction(okAction)
        present(alertVC, animated: true, completion: nil)
    }
}

extension AddSubcategoryViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.activityIndicator.stopAnimating()

        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        //let data = UIImagePNGRepresentation(image)
        let data = UIImageJPEGRepresentation(image, 0.2)

        DataManager.sharedInstance.uploadPhotoUsingData(directory: "Subcategory", data: data, completion: {[weak self] result in
            guard let strongSelf = self else {return}

            strongSelf.photoURL = result
            strongSelf.dismiss(animated:true, completion: nil)
            
        })
    }
}

extension AddSubcategoryViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.textField.resignFirstResponder()
        return true
    }
}
