import Foundation

enum ProgramState {
    case start
    case introduction
    case insertAmount
    case chooseBaseCurrency
    case chooseConvertedCurrency
    case insertInterestRate
    case calculate
    case exit
    
    func printInstruction() {
        switch self {
        case .start:
            Logger.log(.instruction(info: "Starting the program"))
        case .introduction:
            Logger.log(.instruction(info: "Welcome to ExRateCalc calculator\nType \"new\" to start new transaction\nType \"exit\" to exit program"))
        case .insertAmount:
            Logger.log(.instruction(info: "Insert Amount"))
        case .chooseBaseCurrency:
            Logger.log(.instruction(info: "Choose base currency"))
        case .chooseConvertedCurrency:
            Logger.log(.instruction(info: "Choose converted currency"))
        case .insertInterestRate:
            Logger.log(.instruction(info: "Insert interest rate or tap enter to choose default value 0"))
        case .calculate:
            Logger.log(.instruction(info: "Calculate"))
        case .exit:
            Logger.log(.instruction(info: "Exit"))
        }
    }
}
