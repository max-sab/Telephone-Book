//
//  ViewController.swift
//  POOP_01Lab_Sabadyshyn
//
//  Created by Max Sabadyshyn on 5/11/19.
//  Copyright © 2019 Maksym Sabadyshyn. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    
    @IBOutlet weak private var goButton: NSButton!
    @IBOutlet weak private var findNumberButton: NSButton!
    @IBOutlet weak private var findNameButton: NSButton!
    @IBOutlet weak private var removeButton: NSButton!
    @IBOutlet weak private var addButton: NSButton!
    private var buttonsCollection: [NSButton]!
    
    private var telephoneBook: TelBook!
    @IBOutlet weak private var numberInputField: NSTextField!
    @IBOutlet weak private var nameInputField: NSTextField!
    
    
    @IBOutlet weak private var tableView: NSTableView!
    
    lazy var sheetViewController: NSViewController = {
        return self.storyboard!.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("ResultsStoryboard")) as! NSViewController
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonsCollection = [findNumberButton,findNameButton,removeButton,addButton]
        telephoneBook = TelBook()
        goButton.isEnabled = false
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.target = self
        tableView.doubleAction = #selector(tableViewDoubleClick(_:))
        
        
    }
    
    //TODO: expand numbers in order to see all of them
    @objc private func tableViewDoubleClick(_ sender:AnyObject) {
        print("You are genius")
    }
    
    override var representedObject: Any? {
        didSet {
        }
    }
    
    //all actions that the user can pick
    enum Actions
    {
        case addNumber
        case removeNumber
        case findName
        case findNumber
    }
    
    //the one chosen action
    private var actionChosen: Actions?
    
    
    @IBAction private func addButtonClicked(_ sender: NSButton) {
        changeWhenClicked(button: sender, with: "Name goes here", and: "Number goes here")
        actionChosen = Actions.addNumber
    }
    
    @IBAction private func removeButtonClicked(_ sender: NSButton) {
        changeWhenClicked(button: sender, with: "Nothing goes here", and: "Number goes here")
        actionChosen = Actions.removeNumber
    }
    
    
    @IBAction private func findNumberButtonClicked(_ sender: NSButton) {
        changeWhenClicked(button: sender, with: "Name goes here", and: "Nothing goes here")
        actionChosen = Actions.findNumber
        
    }
    
    @IBAction private func findNameButtonClicked(_ sender: NSButton) {
        changeWhenClicked(button: sender, with: "Nothing goes here", and: "Number goes here")
        actionChosen = Actions.findName
    }
    override func viewDidAppear() {
        //setting window unresizable
        view.window!.styleMask.remove(.resizable)
    }
    
    
    
    @IBAction private func doActionButtonClicked(_ sender: NSButton) {
        if numberInputField.stringValue.isEmpty{
            print("NOOOOOO")
        }
        
        if actionChosen != nil{
            switch actionChosen!{
            case .addNumber:
                telephoneBook.addNumber(numberInputField.stringValue, to: nameInputField.stringValue)
            case .removeNumber:
                telephoneBook.removeNumber(numberInputField.stringValue, from: nameInputField.stringValue)
            case .findName:
                
                let alert = NSAlert()
                alert.messageText = "Find name by number"
                if telephoneBook.lookForPerson(with: numberInputField.stringValue) == "" {
                    alert.informativeText = "No name with number \(numberInputField.stringValue)"
                } else{
                    alert.informativeText = "\(numberInputField.stringValue) is the number of \(telephoneBook.lookForPerson(with: numberInputField.stringValue))"
                    }
                
                alert.beginSheetModal(for: self.view.window!) { (response) in
                    
                }
            

            case .findNumber:
                let alert = NSAlert()
                alert.messageText = "Find numbers by name"
                
                if telephoneBook.lookForNumber(with: nameInputField.stringValue).isEmpty{
                     alert.informativeText = "\(nameInputField.stringValue) doesn't have any numbers yet"
                } else{
                     alert.informativeText = "\(nameInputField.stringValue) has those numbers:  \(telephoneBook.lookForNumber(with: nameInputField.stringValue))"
                }
               
                alert.beginSheetModal(for: self.view.window!) { (response) in
                    
                }
                
            }
        }
        
        //after doActionButton button pressed reload NSTableView
        tableView.reloadData()
    }
    
    /**
     
     Change buttons style when any is clicked as well as to change placeholders for name and number
     
     - parameters:
     - button: a button that was clicked
     - nameLabel: reference to name textField
     - numberLabel: reference to number textField
     */
    
    private func changeWhenClicked(button: NSButton, with nameLabel: String, and numberLabel: String){
        
        let pstyle = NSMutableParagraphStyle()
        pstyle.alignment = .center
        for buttons in buttonsCollection{
            buttons.attributedTitle = NSAttributedString(string: buttons.title, attributes: [ NSAttributedString.Key.foregroundColor : NSColor.white, NSAttributedString.Key.paragraphStyle : pstyle ])
        }
        nameInputField.placeholderString = nameLabel
        numberInputField.placeholderString = numberLabel
        button.attributedTitle = NSAttributedString(string: button.title, attributes: [ NSAttributedString.Key.foregroundColor : NSColor.red, NSAttributedString.Key.paragraphStyle : pstyle ])
        goButton.isEnabled = true
    }
    
}

extension ViewController: NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return telephoneBook.telephoneBook.keys.count
    }
    
}

//extension needed for NSViewTable to show contacts
extension ViewController: NSTableViewDelegate {
    
    fileprivate enum CellIdentifiers {
        static let NameCell = "NameCellID"
        static let NumbersCell = "NumbersCellID"
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        var text: String = ""
        var cellIdentifier: String = ""
        
        //if no data to display - show nothing
        let dataToDisplay = telephoneBook.telephoneBook
        if dataToDisplay.isEmpty {
            return nil
        }

        //depending of which column is picked(with names or with numbers) prepare content for it and identify column in cellIdentifier variable
        if tableColumn == tableView.tableColumns[0] {
            text = telephoneBook.telephoneNames[row]
            cellIdentifier = CellIdentifiers.NameCell
        } else if tableColumn == tableView.tableColumns[1] {
            let currentName = telephoneBook.telephoneNames[row]
            for number in telephoneBook.telephoneBook[currentName]!.telNumbers{
                text += String(number) + "; "
            }
            cellIdentifier = CellIdentifiers.NumbersCell
        }
        
        //set content for particular cell
        if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellIdentifier), owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = text
            return cell
        }
        return nil
    }
    
}

