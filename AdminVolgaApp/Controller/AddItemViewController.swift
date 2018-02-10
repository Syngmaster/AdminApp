//
//  AddItemViewController.swift
//  AdminVolgaApp
//
//  Created by Syngmaster on 04/02/2018.
//  Copyright © 2018 Syngmaster. All rights reserved.
//

import UIKit
import FirebaseStorage

class AddItemViewController: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var saleLabel: UILabel!
    @IBOutlet weak var saleTextField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var saleSwitch: UISwitch!
    @IBOutlet weak var saveButton: CustomButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var item: ItemModel?
    var subcategory: Subcategory!
    var isOnSale = false
    var photoArray : [UIImage] = []
    let picker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.activityIndicator.stopAnimating()
        picker.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
        if let item = item {
            updateUI(item: item)
        }
    }
    
    func updateUI(item:ItemModel){
        saveButton.setTitle("Save changes", for: .normal)
        nameTextField.text = item.itemName
        priceTextField.text = "\(item.itemPrice!)"
        descriptionTextView.text = item.itemDescription
        isOnSale = item.isOnSale
        if item.isOnSale {
            saleSwitch.setOn(true, animated: true)
            itemIsOnSale(isOnSale: true)
        } else {
            saleSwitch.setOn(false, animated: true)
            itemIsOnSale(isOnSale: false)
        }
        
        DispatchQueue.global(qos: .background).async {
            
            for photoURL in item.photoURLArray {
                self.loadImages(photoURL: photoURL, item: item)
            }
        }
        
    }
    
    
    func loadImages(photoURL: String, item: ItemModel) {
        
        let storage = FIRStorage.storage()
        let imageRef = storage.reference(forURL: photoURL)
        
        imageRef.data(withMaxSize: 1*2048*2048) { (data, error) in
            
            if let data = data {
                let image = UIImage(data:data)
                self.photoArray.append(image!)
                
                if self.photoArray.count == item.photoURLArray.count {
                    self.collectionView.reloadData()
                }
            }
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collectionView.reloadData()
    }
    
    func raiseAlert() {
        let alertVC = UIAlertController(title: "Warning", message: "Please add all information and upload photos!", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertVC.addAction(okAction)
        present(alertVC, animated: true, completion: nil)
    }
    
    func itemIsOnSale(isOnSale:Bool) {
        if isOnSale {
            saleLabel.alpha = 1
            saleTextField.alpha = 1
            saleTextField.isEnabled = true
         } else {
            saleLabel.alpha = 0.3
            saleTextField.alpha = 0.3
            saleTextField.isEnabled = false
        }
        
    }

    @IBAction func saleOnAction(_ sender: UISwitch) {
        
        if isOnSale {
            isOnSale = false
            itemIsOnSale(isOnSale: false)
        } else {
            isOnSale = true
            itemIsOnSale(isOnSale: true)
        }
    }
    
    @IBAction func addItemAction(_ sender: UIButton) {
        activityIndicator.startAnimating()
        guard let name = nameTextField.text,
            name.count > 0,
            let price = priceTextField.text,
            price.count > 0,
            let description = descriptionTextView.text,
            description.count > 0,
            photoArray.count > 0 else {
            raiseAlert()
                activityIndicator.stopAnimating()
            return
        }
        
        let newItem = ItemModel(name:name.uppercased(), price:Int(price), description:descriptionTextView.text, onSale: isOnSale)
        newItem.photoArray = photoArray
        
        if item != nil {
            DataManager.sharedInstance.updateItem(oldName: item?.itemName, category: subcategory.parentCategory, subcategory: subcategory.subcategoryTitle, item: newItem, completion: {
                self.activityIndicator.stopAnimating()
                self.navigationController?.popViewController(animated: true)
            })
        } else {
            DataManager.sharedInstance.addNewItem(category: subcategory.parentCategory, subcategory: subcategory.subcategoryTitle, item: newItem, completion: {
                self.activityIndicator.stopAnimating()
                self.navigationController?.popViewController(animated: true)
            })
        }
        

    }
}

extension AddItemViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoArray.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! AddItemViewCell
        
        cell.configureCell(photos: photoArray, row: indexPath.row)
        
        return cell
    }
}

extension AddItemViewController: UICollectionViewDelegateFlowLayout  {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellSize = collectionView.bounds.height * 0.7
        return CGSize(width: cellSize, height: cellSize)
    }
}

extension AddItemViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        photoArray.append(image)
        dismiss(animated: true, completion: nil)
    }
}

extension AddItemViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            addPhoto()
        } else {
            removePhotoAtIndexPath(indexPath: indexPath)
        }
    }
    
    func removePhotoAtIndexPath(indexPath: IndexPath) {
        
        if indexPath.row < photoArray.count + 1 {
            let alertVC = UIAlertController(title: "Info", message: "Remove photo?", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let okAction = UIAlertAction(title: "Remove", style: .default, handler: {[weak self] (action) in
                guard let strongSelf = self else {return}
                strongSelf.photoArray.remove(at: indexPath.row - 1)
                strongSelf.collectionView.reloadData()
            })
            
            alertVC.addAction(cancelAction)
            alertVC.addAction(okAction)
            present(alertVC, animated: true, completion: nil)
        }
    }
    
    func addPhoto() {
        let alertVC = UIAlertController(title: "Info", message: "Add photo", preferredStyle: .alert)
//        let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: {[weak self] (action) in
//            guard let strongSelf = self else {return}
//            strongSelf.picker.sourceType = .camera
//            strongSelf.picker.allowsEditing = true
//            strongSelf.present(strongSelf.picker, animated: true, completion: nil)
//        })
        let libraryAction = UIAlertAction(title: "Library", style: .default, handler: {[weak self] (action) in
            guard let strongSelf = self else {return}
            strongSelf.picker.sourceType = .photoLibrary
            strongSelf.picker.allowsEditing = true
            strongSelf.present(strongSelf.picker, animated: true, completion: nil)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

//        alertVC.addAction(cameraAction)
        alertVC.addAction(libraryAction)
        alertVC.addAction(cancelAction)
        present(alertVC, animated: true, completion: nil)

    }
    
}

extension AddItemViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return validationNumericCheckFrom(textField: textField, string: string)
    }
    
    func validationNumericCheckFrom(textField: UITextField, string: String) -> Bool {
        
        let set = CharacterSet.decimalDigits.inverted
        let words = string.components(separatedBy: set)
        
        if words.count > 1 {
            return false
        }
        return true
    }
}
