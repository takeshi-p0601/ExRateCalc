import Foundation

final class Calculator {
    
    private var interestRate: Double {
        didSet {
            if oldValue > Range.max {
                interestRate = Range.max
            } else if oldValue < Range.min {
                interestRate = Range.min
            }
        }
    }
    
    private enum Range {
        static let min = 0.0
        static let max = 100.0
    }
    
    /// - Parameter interestRate: the percent that is charged for transaction.
    ///                           Accaptable values are in range `0 <= interestRate <= 100`.
    ///                           Values that are out of range will be round to nearest accaptable value
    init(interestRate: Double = 0.0) {
        self.interestRate = interestRate
    }
    
    func convert(amount: Amount, from baseCurrency: Currency, to convertedCurrency: Currency) -> Amount {
        let exchangedAmount = baseCurrency.exchanteRate(to: convertedCurrency) * amount
        return exchangedAmount - ((exchangedAmount * interestRate) / Range.max)
    }
}
