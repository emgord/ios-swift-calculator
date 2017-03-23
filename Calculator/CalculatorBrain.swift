//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Pivotal on 3/20/17.
//  Copyright © 2017 Emily. All rights reserved.
//

import Foundation

func factorial(_ number: Double) -> Double {
    var number = number
    var result = number
    while number != 1 {
        result = result * (number - 1)
        number = number - 1
    }
    return result
}

func square(_ base: Double) -> Double {
    return pow(base, 2)
}

func changeSign(_ number: Double) -> Double {
    return -number
}

struct CalculatorBrain {
    
    private var X: Double?
    private var Y: Double?
    
    var storageMode = false
    
    private var accumulator: Double?
    
    private var isPending = true
    
    private var operationString = " "
    
    private enum Operation {
        case constant(Double)
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double,Double) -> Double)
        case equals
    }
    
    private var operations: Dictionary<String, Operation> = [
        "π": Operation.constant(Double.pi),
        "e": Operation.constant(M_E),
        "√": Operation.unaryOperation(sqrt),
        "cos": Operation.unaryOperation(cos),
        "sin": Operation.unaryOperation(sin),
        "±": Operation.unaryOperation(changeSign),
        "abs": Operation.unaryOperation(abs),
        "!" : Operation.unaryOperation(factorial),
        "²": Operation.unaryOperation(square),
        "*": Operation.binaryOperation({ $0 * $1 }),
        "/": Operation.binaryOperation({ $0 / $1 }),
        "+": Operation.binaryOperation({ $0 + $1 }),
        "-": Operation.binaryOperation({ $0 - $1 }),
        "^": Operation.binaryOperation({ pow($0, $1) }),
        "=": Operation.equals
    ]
    
    mutating func performOperation(_ symbol: String){
        if let operation = operations[symbol] {
            switch operation {
            case .constant(let value):
                accumulator = value
                buildOperationString(String(value))
            case .unaryOperation(let function):
                if accumulator != nil {
                    accumulator = function(accumulator!)
                    buildOperationString(symbol)
                    isPending = false
                }
            case .binaryOperation(let function):
                if accumulator != nil {
                    pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!)
                    accumulator = nil
                    buildOperationString(symbol)
                    isPending = true
                }
            case .equals:
                performPendingBinaryOperation()
                isPending = false
            }
        }
    }
    
    private mutating func performPendingBinaryOperation() {
        if pendingBinaryOperation != nil && accumulator != nil {
            accumulator =  pendingBinaryOperation!.perform(with: accumulator!)
        }
       
    }
    
    private var pendingBinaryOperation: PendingBinaryOperation?
    
    private struct PendingBinaryOperation {
        let function: (Double, Double) -> Double
        let firstOperand: Double
        func perform(with secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }
    }
    
    mutating func buildOperationString(_ addition: String){
        operationString = "\(operationString) \(addition)"

    }
    
    mutating func setOperand(_ operand: Double) {
        accumulator = operand
        if resultIsPending {
            buildOperationString(String(operand))
        } else {
            operationString = String(operand)
        }
        
    }
    
    mutating func setOperand(variable named: String) {
        
        if storageMode {
            switch named {
            case "X":
                X = result
            case "Y":
                Y = result
            default:
                break
            }
        } else {
            switch named {
            case "X":
                print("X: \(X)")
                if let operand = X {
                    setOperand(operand)
                }

                print("result: \(result)")

            case "Y":
                print("Y: \(Y)")
                if let operand = Y {
                    setOperand(operand)
                }
                print("result: \(result)")

            default:
                break
            }
        }
        
    }
    
    var result: Double? {
        get {
            return accumulator
        }
    }
    
    var resultIsPending: Bool {
        get {
            return isPending
        }
    }
    
    var description: String {
        get {
            return operationString
        }
    }
    
}
