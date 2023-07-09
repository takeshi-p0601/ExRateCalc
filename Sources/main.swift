import Foundation

do {
    let (amount, baseCurrency, convertedCurrency, interestRate) = try IOService.shared.readArguments()
    let calc = Calculator(interestRate: interestRate)
    let exchangedAmount = calc.convert(amount: amount, from: baseCurrency, to: convertedCurrency)
    IOService.shared.write(.standard(message: Message(format:"%.2f", exchangedAmount)))
} catch let error as IOService.ArgumentInputError {
    IOService.shared.write(.error(error: error))
}
