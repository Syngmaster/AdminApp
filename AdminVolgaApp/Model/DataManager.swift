//
//  DataManager.swift
//  AdminVolgaApp
//
//  Created by Syngmaster on 29/01/2018.
//  Copyright © 2018 Syngmaster. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage

class DataManager: NSObject {
    
    static var sharedInstance = DataManager()
    var photoURLArray: [String] = []

    func downloadSubCategories(category: String, completion: @escaping (Array<Any>) -> ()) {
        
        let db = FIRDatabase.database().reference()
        
        db.observe(.value) { (result) in

            guard let resultDict = result.value as? NSDictionary,
                let valueDict = resultDict.value(forKey: "\(category)") as? NSDictionary,
                let itemsDict = valueDict.value(forKey: "Subcategory") as? NSDictionary
                else { completion([]); return }

            var newArray = [Subcategory]()

            for dict in itemsDict {
                let dict = dict.value as! NSDictionary
                let category = Subcategory.init(photo: dict.value(forKey: "photo") as! String, title: dict.value(forKey: "title") as! String, parent: category)
                newArray.append(category)
            }

            completion(newArray)
            newArray = [Subcategory]()
        }
    }
    
    
    func addSubcategory(title: String?, photoURL:String!, category: String, completion: @escaping (Bool) -> ()) {
        
        guard let title = title?.uppercased() else { return }
        
        let dict = ["title" : title,"photo" : photoURL]
        
        let db = FIRDatabase.database().reference()
        db.observeSingleEvent(of: .value) { (result) in
            
            guard let resultDict = result.value as? NSDictionary,
                let valueDict = resultDict.value(forKey: "\(category)") as? NSDictionary,
                let itemsDict = valueDict.value(forKey: "Subcategory") as? NSDictionary
                else { return }
            
            for dict in itemsDict {
                print(dict.key)
                if title == dict.key as! String {
                    completion(false)
                    return
                }
                
            }
            db.child(category).child("Subcategory").child(title).setValue(dict)
            completion(true)
            
        }
    }
    
    func deleteSubcategory(subcategory: Subcategory, completion: @escaping (Bool) -> ()) {
        let title = subcategory.subcategoryTitle!
        let category = subcategory.parentCategory!
        
        let db = FIRDatabase.database().reference()
        downloadItems(category: category, subcategory: title) { (result) in
            if result.count == 0 {
                self.deletePhotos(photoURL: subcategory.subcategoryPhoto)
                db.child(category).child("Subcategory").child(title).setValue(nil)
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    func uploadPhotoUsingData(directory: String, data:Data!, completion: @escaping (String) -> ()) {
        
        let storageRef = FIRStorage.storage().reference()

        // Create a reference to the file you want to upload
        let d = Date()
        let df = DateFormatter()
        df.dateFormat = "y-MM-dd H:m:ss.SSSS"
        
        let riversRef = storageRef.child("\(directory)/\(df.string(from: d)).jpg")
        
        let metadata = FIRStorageMetadata()
        metadata.contentType = "image/jpeg"
        
        // Upload the file to the path "images/rivers.jpg"
        let uploadTask = riversRef.put(data, metadata: metadata) { (metadata, error) in
            guard let metadata = metadata else {
                // Uh-oh, an error occurred!
                return
            }
            // Metadata contains file metadata such as size, content-type, and download URL.
            let downloadURL = metadata.downloadURL
        }
        uploadTask.observe(.success) { snapshot in
            
            print(snapshot.reference.bucket)
            print(snapshot.reference.fullPath)
            let fullPath = "gs://\(snapshot.reference.bucket)/\(snapshot.reference.fullPath)"
            print(fullPath)
            completion(fullPath)
            // Upload completed successfully
        }
    }
    
    func deletePhotos(photoURL: String) {
        let storageRef = FIRStorage.storage().reference()
        let photoURL = String(photoURL.dropFirst(35))
        
        storageRef.child(photoURL).delete { (result) in
            
        }
        
        
    }
    
    func addNewItem(category:String!, subcategory:String!, item: ItemModel!, completion: @escaping () -> (Void)) {
        let db = FIRDatabase.database().reference()
        photoURLArray = []
        
        for photo in item.photoArray {
            let imgData = UIImageJPEGRepresentation(photo, 0.2)!
            self.uploadPhotoUsingData(directory: "ItemsPhotos", data: imgData, completion: { (result) in
                self.photoURLArray.append(result)
                if self.photoURLArray.count == item.photoArray.count {
                    var photoDict = [String : String]()
                    var i = 1
                    for photoURL in self.photoURLArray {
                        let intermDict = ["photo\(i)" : photoURL]
                        photoDict += intermDict
                        i += 1
                    }
                    
                    let dict = ["itemName" : item.itemName, "price" : item.itemPrice, "description" : item.itemDescription, "isOnSale" : item.isOnSale , "photos" : photoDict] as [String : Any]
                    db.child(category).child("Subcategory").child(subcategory).child("Items").child(item.itemName).setValue(dict)
                    
                    completion()
                }
            })
        }
    }
    
    func updateItem(oldName: String!, category:String!, subcategory:String!, item: ItemModel!, completion: @escaping () -> ()) {
        
        let db = FIRDatabase.database().reference()
        photoURLArray = []
        db.child(category).child("Subcategory").child(subcategory).child("Items").child(oldName).setValue(nil)
        
        for photo in item.photoArray {
            let imgData = UIImageJPEGRepresentation(photo, 0.2)!
            self.uploadPhotoUsingData(directory: "ItemsPhotos", data: imgData, completion: { (result) in
                self.photoURLArray.append(result)
                if self.photoURLArray.count == item.photoArray.count {
                    var photoDict = [String : String]()
                    var i = 1
                    for photoURL in self.photoURLArray {
                        let intermDict = ["photo\(i)" : photoURL]
                        photoDict += intermDict
                        i += 1
                    }
                    
                    let dict = ["itemName" : item.itemName, "price" : item.itemPrice, "description" : item.itemDescription, "isOnSale" : item.isOnSale , "photos" : photoDict] as [String : Any]
                    db.child(category).child("Subcategory").child(subcategory).child("Items").child(item.itemName).setValue(dict)
                    
                    completion()
                }
            })
        }
        
    }
    
    func deleteItem(category:String!, subcategory:String!, item: ItemModel!, completion: () -> ()) {
        
        let db = FIRDatabase.database().reference()
        
        for photoURL in item.photoURLArray {
            deletePhotos(photoURL: photoURL)
        }
        db.child(category).child("Subcategory").child(subcategory).child("Items").child(item.itemName).setValue(nil)
        completion()
        
    }
    
    
    func downloadItems(category: String, subcategory: String, completion: @escaping (Array<Any>) -> ()) {
        
        let db = FIRDatabase.database().reference()
        
        db.child(category).child("Subcategory").child(subcategory).child("Items").observeSingleEvent(of: .value) { (result) in
            if let resultDict = result.value as? NSDictionary {
                var newArray = [ItemModel]()
                for dict in resultDict {
                    let dict = dict.value as! NSDictionary
                    let item = ItemModel.init(dict: dict)
                    newArray.append(item)
                }
                completion(newArray)
            } else {
                completion([])
            }
        }
    }
}
