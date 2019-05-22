//
//  TelBook.swift
//  POOP_01Lab_Sabadyshyn
//
//  Created by Max Sabadyshyn on 5/11/19.
//  Copyright © 2019 Maksym Sabadyshyn. All rights reserved.
//

import Foundation

struct TelBook{
    init() {
        telephoneBook = [String:Person]()
        telephoneNames = [String]()
    }
    private(set) var telephoneBook: [String:Person]
    private(set) var telephoneNames: [String]
    
    //TODO: check if number already added with method of search
    mutating func addNumber(_ telNum: String, to personName: String){
        if telephoneBook[personName] != nil{
            telephoneBook[personName]!.add(number: telNum)
            print("New person added!")
        } else{
            print("\(personName) doesn't exist in tel book yet so we will create him.")
            telephoneNames.append(personName)
            telephoneBook[personName] = Person(name: personName, initialNum: telNum)
        }
    }
    
    
    //TODO: if there is no numbers in person - delete it
    mutating func removeNumber(_ telNum: String, from personName: String){
        //checking if name exists
        if telephoneBook[personName] != nil{
            //checking if number exists
            telephoneBook[personName]!.remove(number: telNum)
        } else{
            print("\(personName) doesn't exist in tel book")
        }
    }
    
    //given number, find what name it belongs to
    func lookForPerson(with number: String)->String{
        for person in telephoneBook.keys{
            if telephoneBook[person]!.lookForNumber(with: number) == true{
                return person
            }
        }
        
        print("There is no \(number) in telephone book")
        return ""
    }
    
    //given name, look what numbers it has
    func lookForNumber(with name: String)->[String]{
        if let foundPerson = telephoneBook[name]{
            return foundPerson.telNumbers
        } else{
            print("There is no \(name) in telephone book yet")
            return []
        }
    }
    
}
