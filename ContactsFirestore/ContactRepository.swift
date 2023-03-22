//
//  ContactRepository.swift
//  ContactsFirestore
//
//  Created by alex on 17/3/2023.
//

import Foundation
import FirebaseFirestore


class ContactRepository{
    
    var db = Firestore.firestore()
    var contacts = [Contact]()
    
    func findContactById(id: String, onCompletion : @escaping (Contact?) -> Void){
        let docRef = db.collection("Contacts").document(id)
        var contactResult : Contact!
        
        docRef.getDocument { (document, error) in
             
            if let doc = document, doc.exists {
               let data = doc.data()
                contactResult = Contact(id: doc.documentID, dictionary: data!)
                onCompletion(contactResult)
            }else {
                print("Document for the id: \(id) does not exist")
            }
        }
        
    }
    
    func add(contact: Contact) -> Bool {
        var result = true
        let dictionary : [String : Any] = [
            "name": contact.name,
            "email": contact.email,
            "phone": contact.phone,
            "photo": contact.photo,
            "position": contact.position
        ]
        
        db.collection("Contacts").addDocument(data: dictionary){ error in
            if let error = error {
                print("Contact Could not be added: \(contact.toString()), error: \(error)")
                result = false
            }else{
                print("Contact Added: \(contact.toString())")
            }
        }
        return result
    }
    
    func delete(contact: Contact) -> Bool {
        var result = true
        db.collection("Contacts").document(contact.id!).delete(){ error in
            if let error = error {
                print("Error removing document: \(error)")
                result = false
            }else{
                print("Document successfully deleted")
            }
            
        }
        return result
    }
    
    func update(contact: Contact) -> Bool {
        var result = true

        let dictionary : [String : Any] = [
            "name": contact.name,
            "email": contact.email,
            "phone": contact.phone,
            "photo": contact.photo,
            "position": contact.position
        ]
        
        db.collection("Contacts").document(contact.id!).updateData(dictionary){ error in
            if let error = error {
                print("Error updating document: \(error)")
                result = false
            }else{
                print("Document updated")
            }
        }

        return result
    }
    
}
