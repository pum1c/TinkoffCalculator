//
//  ViewController.swift
//  TinkoffCalculator
//
//  Created by Вадим Амбарцумян on 10.03.2024.
//

import UIKit

enum Operation: String {
    case add = "+"
    case substract = "-"
    case multiply = "x"
    case divide = "/"
    
    
    func calculate(_ number1: Double, _ number2: Double) -> Double {
        switch self {
            
        case .add:
            return number1 + number2
            
        case .substract:
            return number1 - number2
            
        case .multiply:
            return number1 * number2
            
        case .divide:
            return number1 / number2
            
        }
    }
}
    enum CalculationHistoryItem {
        case number(Double)
        case operation(Operation)
    }
    
    class ViewController: UIViewController {
        
        @IBAction func buttonPressed(_ sender: UIButton) {
            guard let buttonText = sender.currentTitle else { return }
            
            print(buttonText)
            if buttonText == "," && label.text?.contains(",") == true {
                return
            }
            
            if label.text == "0" {
                label.text = buttonText
            } else {
                label.text?.append(buttonText)
            }
        }
    
        
        @IBAction func operationButtonPressed(_ sender: UIButton) {
            guard
                let buttonText = sender.currentTitle,
                let buttonOperation = Operation(rawValue: buttonText)
            else { return }
            
            guard
                let labelText = label.text,
                let labelNumber = numberFormatter.number(from: labelText)?.doubleValue
            else { return }
            
            calculationHistory.append(.number(labelNumber))
            calculationHistory.append(.operation(buttonOperation))
            
            resetLabelText()
        }
        
        @IBAction func clearButtonPressed() {
            calculationHistory.removeAll()
            
            resetLabelText()
        }
        
        @IBAction func calculateButtonPressed() {
            guard
                let labelText = label.text,
                let labelNumber = numberFormatter.number(from: labelText)?.doubleValue
            else { return }

            calculationHistory.append(.number(labelNumber))
            
            // Проверка на достаточное количество операндов
            guard calculationHistory.count % 2 == 0 else {
                label.text = "Ошибка: недостаточное количество операндов"
                calculationHistory.removeAll()
                return
            }
            
            do {
                let result = try calculate()
                label.text = numberFormatter.string(from: NSNumber(value: result))
            } catch {
                label.text = "Ошибка"
            }
            
            calculationHistory.removeAll()
        }
        
        @IBOutlet weak var label: UILabel!
        
        var calculationHistory : [CalculationHistoryItem] = []
        
        lazy var numberFormatter: NumberFormatter = {
            let numberFormatter = NumberFormatter()
            
            numberFormatter.usesGroupingSeparator = false
            numberFormatter.locale = Locale(identifier: "ru_RU")
            numberFormatter.numberStyle = .decimal
            
            return numberFormatter
        }()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            resetLabelText()
        }
        
        func calculate() throws ->  Double {
            guard case .number(let firstNumber) = calculationHistory[0] else { return 0 }

            var currentResult = firstNumber
            
            // Проверка на то, что пользователь не делит на 0
            for index in stride(from: 1, to: calculationHistory.count - 1, by: 2) {
                guard
                    case .operation(let operation) = calculationHistory[index],
                    case .number(let number) = calculationHistory[index + 1]
                else { break }

                currentResult = try operation.calculate(currentResult, number)
            }

                return currentResult

        }
        
        func resetLabelText() {
            label.text = "0"
        }
        
    }

