import Foundation

struct Task: Codable {
    let id: Int
    let title: String
    let address: String
    let status: String
    let date: String
    let latitude: Double
    let longitude: Double
}
