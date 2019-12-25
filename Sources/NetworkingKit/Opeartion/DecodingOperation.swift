import Foundation

protocol DecodingDataProvider: class {
    var data: Data? { get }
}

protocol DecodableOperationType: class {
    associatedtype DataType: Decodable
    associatedtype Provider: DecodingDataProvider
}

class DecodingOperation<Element, DataProvider>: BasicOperation, DecodableOperationType
where Element: Decodable, DataProvider: DecodingDataProvider {
    
    typealias DataType = Element
    typealias Provider = DataProvider
    
    private(set) var decodedObject: DataType?
    
    override var isAsynchronous: Bool {
        return true
    }
    
    override func main() {
        guard let dataToDecode = (dependencies.first { $0 is Provider } as? Provider)?.data else {
            setFinished()
            return
        }
        do {
            decodedObject = try JSONDecoder().decode(DataType.self, from: dataToDecode)
            setFinished()
        } catch {
            setFinished()
        }
    }
}
