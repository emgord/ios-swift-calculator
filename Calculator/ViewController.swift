//
//  ViewController.swift
//  Calculator
//
//  Created by Pivotal on 3/17/17.
//  Copyright © 2017 Emily. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var displayOperation: UILabel!
    
    var isTyping = false

    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        if isTyping {
            let textCurrentlyInDisplay = display.text!
            if (digit != "."  || !textCurrentlyInDisplay.contains(".")) {
                display.text = textCurrentlyInDisplay + digit
            }
        } else {
            display.text = digit
            isTyping = true
        }
    }
    var displayValue: Double {
        get {
            if let digit = Double(display.text!) {
                return digit
            } else {
                return 0
            }
            
        }
        set {
            display.text = String(newValue)
        }
    }
    
    @IBAction func updateDisplayOperation(_ sender: UIButton) {
        var suffix = " ="
        if (brain.resultIsPending) {
            suffix = " ..."
        }
        displayOperation.text = brain.description + suffix
    }
    
    private var brain = CalculatorBrain()
    
    @IBAction func performOperation(_ sender: UIButton) {
        if isTyping {
            brain.setOperand(displayValue)
            isTyping = false
        }
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(mathematicalSymbol)
        }
        if let result = brain.result {
            displayValue = result
        }
    }
    @IBAction func clear(_ sender: UIButton) {
        brain = CalculatorBrain()
        display.text = "0"
        displayOperation.text = " "
    }
    
    
    @IBAction func saveToVariable(_ sender: UIButton) {
        brain.setOperand(variable: sender.currentTitle!)
        print("saveToVariable")
    }
   
    @IBAction func setStorageMode(_ sender: UIButton) {
        brain.storageMode = !brain.storageMode
        if brain.storageMode {
            sender.backgroundColor = .blue
        } else {
            sender.backgroundColor = .green
        }
    }

}

