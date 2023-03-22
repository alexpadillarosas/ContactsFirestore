//
//  Contact.swift
//  ContactsFirestore
//
//  Created by alex on 16/3/2023.
//

import Foundation


public class Contact {
    var id: String?
    var name: String
    var email: String
    var phone: String
    var photo: String
    var position: String
    
    init(name: String, email: String, phone: String, photo: String, position: String) {
        self.name = name
        self.email = email
        self.phone = phone
        self.photo = photo
        self.position = position
    }
    
    convenience init(id: String, name: String, email: String, phone: String, photo: String, position: String) {
        self.init(name: name, email: email, phone: phone, photo: photo, position: position)
        self.id = id
    }
    
    convenience init(id: String){
        self.init(name: "", email: "", phone: "", photo: "", position: "")
        self.id = id
    }
    
    convenience init(id: String, dictionary: [String: Any]){
        self.init(  id: id,
                    name: dictionary["name"] as! String,
                    email: dictionary["email"] as! String,
                    phone: dictionary["phone"] as! String,
                    photo: dictionary["photo"] as! String,
                    position: dictionary["position"] as! String
        )
    }
    //since id it's an optional we can provide a default value when it's nil
    func toString() -> String {
        return "id: \(self.id ?? "" ), name: \(self.name), email: \(self.email), phone: \(self.phone), photo: \(self.photo), position: \(self.position)"
    }
}
