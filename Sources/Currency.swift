import Foundation

enum Currency: String {
    case usd = "usd"
    case eur = "eur"
    
    private enum Rate {
        static let usd = 1.0
        static let eur = 1.15
    }
    
    private var exchangeRateToUSD: Double {
        switch self {
        case .usd:
            return Rate.usd
        case .eur:
            return Rate.eur
        }
    }
    
    func exchanteRate(to currency: Currency) -> Double {
        switch self {
        case .usd:
            return self.exchangeRateToUSD / currency.exchangeRateToUSD
        case .eur:
            return self.exchangeRateToUSD / currency.exchangeRateToUSD
        }
    }
}
