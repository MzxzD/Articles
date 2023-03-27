import Combine
import CoreData
import Foundation

// MARK: Async Implementation

class APIClient {
    
    enum APIError: Error {
        case networkError
        case invalidResponse
        case requestFailed
    }

    struct APIResponse {
        let data: Articles?
        let response: URLResponse?
        let error: Error?
    }
    
    private let retryCount = 3
    private let timeout = 10.0
    private let backoffDelay = 2.0

    
    private func createURLRequest(for url: URL) -> URLRequest {
        var request = URLRequest(url: url, timeoutInterval: timeout)
        request.httpMethod = "GET"
        return request
    }
    
    private func createDataTask(with urlRequest: URLRequest) async throws -> APIResponse {
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        let decoder = JSONDecoder()
        let articles = try decoder.decode(Articles.self, from: data)
        return APIResponse(data: articles, response: response, error: nil)
    }
    
    private func retryDataTask(with urlRequest: URLRequest, retryCount: Int) async throws -> APIResponse {
        do {
            return try await createDataTask(with: urlRequest)
        } catch {
            if retryCount == 0 {
                throw error
            } else {
                try await Task.sleep(nanoseconds:UInt64(backoffDelay * 1_000_000_000)) // sleep for 2 seconds before retrying
                return try await retryDataTask(with: urlRequest, retryCount: retryCount - 1)
            }
        }
    }
    
    func fetchData(from url: URL) async throws -> Articles {
        let request = createURLRequest(for: url)
        let response = try await retryDataTask(with: request, retryCount: retryCount)
        
        guard let httpResponse = response.response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw APIError.invalidResponse
        }
        
        guard let data = response.data else {
            throw APIError.requestFailed
        }
        
        return data
    }
}

class CoreDataHelper {

    static let shared = CoreDataHelper()
    private init() {}

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Articles")
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    // MARK: - Fetch Request

    func fetch<T: NSManagedObject>(_ entity: T.Type) async throws -> [T]? {
        let request = T.fetchRequest()
        let context = persistentContainer.viewContext
        return try context.performAndWait {
            let result = try context.fetch(request) as? [T]
            return result
        }
    }
}
