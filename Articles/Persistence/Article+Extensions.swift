import Foundation

struct MockArticle: ArticlePresentible {
    var id: Int64
    var title: String?
    var articleDescription: String?
    var author: String?
    var releaseDate: String?
    var image: String?
}

extension MockArticle: Codable {
    enum CodingKeys: String, CodingKey {
        case id, title, author
        case releaseDate = "release_date"
        case articleDescription = "description"
        case image
    }
}

typealias Articles = [MockArticle]

public protocol ArticlePresentible: Equatable {
    
    var id: Int64 {get set}
    var title: String? {get set}
    var articleDescription: String? {get set}
    var author: String? {get set}
    var releaseDate: String? {get set}
    var image: String? {get set}
    var imageUrl: URL? { get }
    var formattedReleaseDate: String { get }
}

extension ArticlePresentible {
    public var imageUrl: URL? {
        if let image {
            return URL(string: image)
        }
        return nil
    }
    
    public var formattedReleaseDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "MM/dd/yyyy"
        guard let releaseDate, let date = dateFormatter.date(from: releaseDate) else {
            return "N/A"
        }
        dateFormatter.dateFormat = "E, MMM d,''yy"
        let stringDate = dateFormatter.string(from: date)
        return stringDate
    }
}


