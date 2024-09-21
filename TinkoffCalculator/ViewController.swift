//
//  ViewController.swift
//  TinkoffCalculator
//
//  Created by Egor on 21.09.2024.
//

import UIKit

enum CalculationError: Error {
    case divideByZero
}

enum Operation: String {
    case add = "+"
    case substract = "-"
    case multiply = "x"
    case divide = "/"
    
    func calculate(_ number1: Double, _ number2: Double) throws -> Double {
        return switch self {
        case .add:
            number1 + number2
        case .substract:
            number1 - number2
        case .multiply:
            number1 * number2
        case .divide:
            if number2 == 0 {
                throw CalculationError.divideByZero
            } else {
                number1 / number2
            }
        }
    }
}

enum CalculationHistoryItem {
    case number(Double)
    case operation(Operation)
}

class ViewController: UIViewController {
    
    // MARK: - Private properties
    
    private lazy var numberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.usesGroupingSeparator = false
        numberFormatter.locale = Locale(identifier: "ru_RU")
        numberFormatter.numberStyle = .decimal
        return numberFormatter
    }()
    
    private var calculationHistory: [CalculationHistoryItem] = []
    
    // MARK: - UI elements
    
    @IBOutlet private weak var label: UILabel!
    
    // MARK: - Button actions

    @IBAction private func buttonTapped(_ sender: UIButton) {
        guard let buttonText = sender.currentTitle else { return }
        if buttonText == "," 
            && (label.text?.contains(",") == true
                || label.text == "0"
                || label.text == "") 
        { return }
        if label.text == "0" {
            label.text = buttonText
        } else {
            label.text?.append(buttonText)
        }
    }
    
    @IBAction private func operationButtonTapped(_ sender: UIButton) {
        guard let labelText = label.text,
              let labelNumber = numberFormatter.number(from: labelText)?.doubleValue,
              let buttonText = sender.currentTitle,
              let buttonOperation = Operation(rawValue: buttonText)
        else { return }
        
        calculationHistory.append(.number(labelNumber))
        calculationHistory.append(.operation(buttonOperation))
        
        removeAllText()
    }
    
    @IBAction private func clearButtonTapped() {
        calculationHistory.removeAll()
        resetLabelText()
    }
    
    @IBAction private func calculateButtonTapped() {
        guard let labelText = label.text,
              let labelNumber = numberFormatter.number(from: labelText)?.doubleValue
        else { return }
        calculationHistory.append(.number(labelNumber))
        
        do {
            let result = try calculate()
            label.text = numberFormatter.string(from: NSNumber(value: result))
        } catch {
            label.text = "Error"
        }
        calculationHistory.removeAll()
    }
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resetLabelText()
    }
    
    // MARK: - Private methods
    
    private func resetLabelText() {
        label.text = "0"
    }
    
    private func removeAllText() {
        label.text = ""
    }
    
    private func calculate() throws -> Double {
        guard case .number(let firstNumber) = calculationHistory[0]
        else { return 0 }
        var currentResult = firstNumber
        for index in stride(from: 1, to: calculationHistory.count - 1, by: 2) {
            guard case .operation(let operation) = calculationHistory[index],
                  case .number(let number) = calculationHistory[index + 1]
            else { break }
            currentResult = try operation.calculate(currentResult, number)
        }
        return currentResult
    }
    
}

