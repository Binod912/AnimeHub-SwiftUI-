import Foundation

struct APIResponse<T: Decodable>: Decodable {
    let data: T
    let pagination: Pagination?
}

struct Pagination: Decodable {
    let lastVisiblePage: Int?
    let hasNextPage: Bool?

    enum CodingKeys: String, CodingKey {
        case lastVisiblePage = "last_visible_page"
        case hasNextPage = "has_next_page"
    }
}
