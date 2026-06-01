import Fluent
import Vapor

struct ProductDTO: Content {
    var id: UUID?
    var name: String?
    var price: Int?
    
    func toModel() -> Product {
        let model = Product()
        
        model.id = self.id
        if let name = self.name {
            model.name = name
        }
        if let price = self.price {
            model.price = price
        }
        return model
    }
}
