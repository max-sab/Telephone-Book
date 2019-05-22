//
//  Person.swift
//  POOP_01Lab_Sabadyshyn
//
//  Created by Max Sabadyshyn on 5/11/19.
//  Copyright © 2019 Maksym Sabadyshyn. All rights reserved.
//

import Foundation

struct Person{
    let name: String
    private(set) var telNumbers: [String]
    
    init(name: String, initialNum: String){
        self.name = name
        telNumbers = [initialNum]
    }
    
    mutating func add(number: String){
        let intNum = Int(number)
        if !(telNumbers.contains(number) || intNum==nil){
            telNumbers.append(number)
            print("New person added!")
        }
        
    }
    
    
    mutating func remove(number: String){
            //checking if number exists
            if let indexOfNumber = telNumbers.firstIndex(of: number){
                telNumbers.remove(at: indexOfNumber)
            } else{
                print("\(number) doesn't exist under this name")
            }
    }
    
    //given number, find what name it belongs to
    func lookForNumber(with number: String)->Bool{
        if telNumbers.contains(number){
            return true
        }
        print("There is no \(number) in telephone book")
        return false
    }
}
