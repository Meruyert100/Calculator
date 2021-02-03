//
//  Calculator.swift
//  Calculator_iOS
//
//  Created by Meruyert Tastandiyeva on 2/2/21.
//

import Foundation

class Calculator {
    
    private var sum = 0.0
    
    enum Operation {
        case Unary((Double) -> Double)
        case Binary((Double, Double) -> Double)
        case Equals
    }
    
    private struct BinaryOperation {
        var binaryFunction: (Double, Double) -> Double
        var firstOperand: Double
    }
    
    private var undone: BinaryOperation?
    
    var operations: [String : Operation] = [
        "+" : Operation.Binary({$0 + $1}),
        "-" : Operation.Binary({$0 - $1}),
        "÷" : Operation.Binary({$0 / $1}),
        "x" : Operation.Binary({$0 * $1}),
        "%" : Operation.Unary({$0 / 100}),
        //"%" : Operation.Binary({($1 * 100) / $0}),
        "+/-" : Operation.Unary({-$0}),
        "=" : Operation.Equals
    ]
    
    var result: String {
        get {
            if evaluateWholesomeness(number: sum) {
                if let number = sum.toInt() {
//                    print("1")
                    return String(number)
                } else {
//                    print("2")
                    return String(sum)
                }
            } else {
//                print("3")
                return String(sum)
            }
        }
    }
    
    func setOperand(operand: Double) {
        sum = operand
    }
    
    func completeBinaryOperation() {
        if undone != nil {
            sum = undone?.binaryFunction(undone?.firstOperand ?? sum, sum) ?? sum
            undone = nil
        }
    }
    
    func performOperation(symbol: String) {
        if let operation = operations[symbol] {
            
            switch operation {
            case .Binary(let function):
                completeBinaryOperation()
                undone = BinaryOperation(binaryFunction: function, firstOperand: sum)
            case .Unary(let function):
                if sum == 0.0 && symbol == "+/-" && symbol == "%" {
                    print("performOperation: operation cannot be calculated")
                } else {
                    sum = function(sum)
                }
            case .Equals:
                completeBinaryOperation()
            }
            
        }
    }
    
    func unDo() {
        if undone != nil {
            undone = nil
        }
    }
    
    func clearHistory() {
        sum = 0.0
        undone = nil
    }
    
    func evaluateWholesomeness(number: Double) -> Bool {
        let ceilSum = number
        let floorSum = number
        
        return ceilSum.rounded(.up) == floorSum.rounded(.down)
    }
    
}

extension Double {
    func toInt() -> Int? {
        if self >= Double(Int.min) && self <= Double(Int.max) {
            return Int(self)
        } else {
            return nil
        }
    }
}
