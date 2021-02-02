//
//  Calculator.swift
//  Calculator_iOS
//
//  Created by Meruyert Tastandiyeva on 2/2/21.
//

import Foundation

class Calculator {
    
    private var accumulator = 0.0
    
    enum Operation {
        case Unary((Double) -> Double)
        case Binary((Double, Double) -> Double)
        case Equals
    }
    
    private struct BinaryOperation {
        var binaryFunction: (Double, Double) -> Double
        var firstOperand: Double
    }
    
    private var pending: BinaryOperation?
    
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
            if evaluateWholesomeness(number: accumulator) {
                if let number = accumulator.toInt() {
                    return String(number)
                } else {
                    return String(accumulator)
                }
            } else {
                return String(accumulator)
            }
        }
    }
    
    func setOperand(operand: Double) {
        accumulator = operand
    }
    
    func completeBinaryOperation() {
        if pending != nil {
            accumulator = pending?.binaryFunction(pending?.firstOperand ?? accumulator, accumulator) ?? accumulator
            pending = nil
        }
    }
    
    func performOperation(symbol: String) {
        if let operation = operations[symbol] {
            
            switch operation {
            case .Binary(let function):
                completeBinaryOperation()
                pending = BinaryOperation(binaryFunction: function, firstOperand: accumulator)
            case .Unary(let function):
                if accumulator == 0.0 && symbol == "+/-" && symbol == "%" {
                    print("performOperation: operation cannot be calculated")
                } else {
                    accumulator = function(accumulator)
                }
            case .Equals:
                completeBinaryOperation()
            }
            
        }
    }
    
    func undo() {
        if pending != nil {
            pending = nil
        }
    }
    
    func clearHistory() {
        accumulator = 0.0
        pending = nil
    }
    
    func evaluateWholesomeness(number: Double) -> Bool {
        let ceilAccumulator = number
        let floorAccumulator = number
        
        return ceilAccumulator.rounded(.up) == floorAccumulator.rounded(.down)
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
