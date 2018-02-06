//
//  CalculatorBrain.swift
//  Ca;culator
//
//  Created by Abhijith Prasanna Kumar on 1/23/18.
//  Copyright © 2018 Abhijith Prasanna Kumar. All rights reserved.
//

import Foundation


class CalculatorBrain
{
    
    private var accumalator : Double = 0.0
    private var internalProgram = [AnyObject]()
    func setOperand (operand:Double)
    {
        accumalator = operand
        internalProgram.append(operand as AnyObject)
    }
    
    private var operations : Dictionary<String,Operation> =
        [
            "π":Operation.Constant(Double.pi),
            "e":Operation.Constant(M_E),
            "√":Operation.UnaryOperation(sqrt),
            "cos":Operation.UnaryOperation(cos),
            "×":Operation.BinaryOperation({$0*$1}),
            "÷":Operation.BinaryOperation({$0/$1}),
            "+":Operation.BinaryOperation({$0+$1}),
            "-":Operation.BinaryOperation({$0-$1}),
            "=":Operation.Equals
            
    ]
    
    private enum Operation {
        case Constant (Double)
        case UnaryOperation((Double) -> Double)
        case BinaryOperation ((Double, Double) -> Double)
        case Equals
    }
    func performOperation (symbol: String) {
        if let operation = operations[symbol] {
            internalProgram.append(symbol as AnyObject)
            switch operation {
            case.Constant(let value): accumalator=value
            case.UnaryOperation(let function): accumalator=function(accumalator)
            case.BinaryOperation(let function):
                executePendingBinaryOperation()
                pending=PendingBinaryOperationInfo(binaryFunction:function, firstOperand:accumalator)
            case .Equals:
                executePendingBinaryOperation()
            }
        }
        
    }
    
    private func executePendingBinaryOperation()
    {
        if pending != nil {
            accumalator=pending!.binaryFunction(pending!.firstOperand,accumalator)
            pending=nil
    }
    }
    
    private var pending:PendingBinaryOperationInfo?
    
    private struct PendingBinaryOperationInfo {
        var binaryFunction: (Double,Double)->Double
        var firstOperand: Double
    }
    typealias PropertyList = AnyObject
    var program : PropertyList {
        get {
            return internalProgram as CalculatorBrain.PropertyList
        }
        set {
            clear()
            if let arrayOfOps = newValue as? [AnyObject] {
                for op in arrayOfOps {
                    if let operand = op as? Double {
                        setOperand(operand: operand)
                    } else if let symbol = op as? String {
                        performOperation(symbol: symbol)
                }
                    
            }
        }
            
        }
    }
    
    func clear() {
        accumalator=0.0
        internalProgram.removeAll()
        pending = nil
    }
    var result:Double {
        get {
            return accumalator
        }
    }
}
