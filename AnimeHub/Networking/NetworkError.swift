import Foundation

enum NetworkError: LocalizedError {
    case invalidURL
    case invalidResponse
    case httpStatus(Int)
    case decoding(Error)
    case underlying(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL: "The API URL is invalid."
        case .invalidResponse: "The server returned an invalid response."
        case .httpStatus(let code):
            switch code {
            case 429: "The service is receiving too many requests. Please wait and try again."
            case 404: "The requested anime could not be found."
            case 500...599: "The anime service is temporarily unavailable."
            default: "Request failed (HTTP \(code))."
            }
        case .decoding: "The server response could not be read."
        case .underlying(let error):
            if let urlError = error as? URLError, urlError.code == .notConnectedToInternet {
                "No internet connection. Check your network and try again."
            } else {
                error.localizedDescription
            }
        }
    }
}
