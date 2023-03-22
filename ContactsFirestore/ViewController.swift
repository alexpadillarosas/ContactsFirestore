//
//  ViewController.swift
//  ContactsFirestore
//
//  Created by alex on 16/3/2023.
//

import UIKit
import FirebaseFirestore


class ViewController: UIViewController {
    
    @IBOutlet weak var idTextField: UITextField!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var phoneTextField: UITextField!
    
    @IBOutlet weak var photoTextField: UITextField!
    
    @IBOutlet weak var positionTextField: UITextField!
    
    
    let database = Firestore.firestore()
    var contacts = [Contact]()
    let service = ContactRepository()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        _ = database.collection("Contacts")
                            .whereField("position", isEqualTo: "IT")
                            .addSnapshotListener { (querySnapshot, error) in
                                /* One way to do it
                                querySnapshot?.documents.forEach({ (document) in
                                    let contactId = document.documentID
                                    let dictionary = document.data()
                                    let contact = Contact(id: contactId, dictionary: dictionary)
                                    print(contact.toString())
                                    
                                    self.contacts.append(contact)
                                })
                                */
                                
                                if let documents = querySnapshot?.documents {
                                    self.contacts = documents.map({ queryDocumentSnapshot -> Contact in
                                        let data = queryDocumentSnapshot.data()
                                        return Contact(id: queryDocumentSnapshot.documentID, dictionary: data)
                                    })
                                    
                                    for contact in self.contacts {
                                        print(contact.toString())
                                    }
                                }else{
                                    print("No Documents")
                                }
                                
                                
                            }
    }

    @IBAction func searchDidPress(_ sender: Any) {
        var myContact : Contact!
        let docId = idTextField.text
        if docId!.isEmpty {
            showAlertMessage(title: "ID is Mandatory", message: "We need the ID to search for a particular contact")
            return
        }
        
        
        service.findContactById(id: docId!) { retContact in
            if let retContact = retContact {
                myContact = retContact
                print("Contact Found: \(myContact.toString())")
                
                self.nameTextField.text = myContact.name
                self.emailTextField.text = myContact.email
                self.phoneTextField.text = myContact.phone
                self.photoTextField.text = myContact.photo
                self.positionTextField.text = myContact.position
            }
        }
    }
    
    
    @IBAction func addDidPress(_ sender: Any) {
        let name = nameTextField.text
        if name!.isEmpty {
            showAlertMessage(title: "Name is mandatory", message: "We need the contact's name")
            return
        }
        
        let email = emailTextField.text
        if email!.isEmpty {
            showAlertMessage(title: "Email is mandatory", message: "We need the contact's email")
            return
        }
        
        let position = positionTextField.text
        if position!.isEmpty {
            showAlertMessage(title: "Position is mandatory", message: "We need the contact's position")
            return
        }
        
        let contact = Contact(name: self.nameTextField.text!,
                              email: self.emailTextField.text!,
                              phone: self.phoneTextField.text!,
                              photo: self.photoTextField.text!,
                              position: self.positionTextField.text!)
        
        if service.add(contact: contact) {
            showAlertMessage(title: "Success", message: "\(contact.name) was added." )
            cleanScreen()
        }else{
            showAlertMessage(title: "Failed", message: "\(contact.name) could not be registered.")
        }
    }
    
    @IBAction func updateDidPress(_ sender: Any) {
        
        let docId = idTextField.text
        if docId!.isEmpty {
            showAlertMessage(title: "Id is Mandatory", message: "We need the Id to update a contact")
            return
        }
        let name = nameTextField.text
        if name!.isEmpty {
            showAlertMessage(title: "Name is mandatory", message: "We need the contact's name")
            return
        }
        
        let email = emailTextField.text
        if email!.isEmpty {
            showAlertMessage(title: "Email is mandatory", message: "We need the contact's email")
            return
        }
        
        let position = positionTextField.text
        if position!.isEmpty {
            showAlertMessage(title: "Position is mandatory", message: "We need the contact's position")
            return
        }
        
        let contact = Contact(id: self.idTextField.text!,
                              name: self.nameTextField.text!,
                              email: self.emailTextField.text!,
                              phone: self.phoneTextField.text!,
                              photo: self.photoTextField.text!,
                              position: self.positionTextField.text!)
        
        if service.update(contact: contact) {
            showAlertMessage(title: "Success", message: "\(contact.name) was updated.")
            cleanScreen()
        }else{
            showAlertMessage(title: "Failed", message: "\(contact.name) could not be updated.")
        }
    }
    
    
    @IBAction func deleteDidPress(_ sender: Any) {
        let docId = idTextField.text
        if docId!.isEmpty {
            showAlertMessage(title: "ID is Mandatory", message: "We need the ID to delete a contact")
            return
        }
        
        let contact = Contact(id: self.idTextField.text!)
        
        if service.delete(contact: contact) {
            showAlertMessage(title: "Success", message: "contact deleted")
            cleanScreen()
        }else{
            showAlertMessage(title: "Failed", message: "contact could not be deleted.")
        }
    }
    
    @IBAction func clearDidPress(_ sender: Any) {
        cleanScreen()
    }
    
    func cleanScreen(){
        self.idTextField.text = ""
        self.nameTextField.text = ""
        self.emailTextField.text = ""
        self.phoneTextField.text = ""
        self.photoTextField.text = ""
        self.positionTextField.text = ""
    }
    
    func showAlertMessage(title : String, message: String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        self.present(alert, animated: true)
    }
    
    
}

