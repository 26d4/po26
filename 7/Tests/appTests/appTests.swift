@testable import app
import VaporTesting
import Testing
import Fluent

@Suite("App Tests with DB", .serialized)
struct appTests {
    private func withApp(_ test: (Application) async throws -> ()) async throws {
        let app = try await Application.make(.testing)
        do {
            try await configure(app)
            try await app.autoMigrate()
            try await test(app)
            try await app.autoRevert()
        } catch {
            try? await app.autoRevert()
            try await app.asyncShutdown()
            throw error
        }
        try await app.asyncShutdown()
    }
    
    @Test("Test Hello World Route")
    func helloWorld() async throws {
        try await withApp { app in
            try await app.testing().test(.GET, "hello", afterResponse: { res async in
                #expect(res.status == .ok)
                #expect(res.body.string == "Hello, world!")
            })
        }
    }
    
    @Test("Getting all the Products")
    func getAllProducts() async throws {
        try await withApp { app in
            let sampleProducts = [Product(name: "sample1", price: 1990), Product(name: "sample2", price: 9000)]
            try await sampleProducts.create(on: app.db)
            
            try await app.testing().test(.GET, "products", afterResponse: { res async throws in
                #expect(res.status == .ok)
                #expect(try
                    res.content.decode([ProductDTO].self).sorted(by: { ($0.name ?? "") < ($1.name ?? "") }) ==
                    sampleProducts.map { $0.toDTO() }.sorted(by: { ($0.name ?? "") < ($1.name ?? "") })
                )
            })
        }
    }
    
    @Test("Creating a Product")
    func createProduct() async throws {
        let newDTO = ProductDTO(id: nil, name: "test", price: 1997)
        
        try await withApp { app in
            try await app.testing().test(.POST, "products", beforeRequest: { req in
                try req.content.encode(newDTO)
            }, afterResponse: { res async throws in
                #expect(res.status == .ok)
                let models = try await Product.query(on: app.db).all()
                #expect(models.map({ $0.toDTO().name }) == [newDTO.name])
            })
        }
    }
    
    @Test("Deleting a Product")
    func deleteProduct() async throws {
        let testProducts = [Product(name: "test1", price: 1999), Product(name: "test2", price: 2499)]
        
        try await withApp { app in
            try await testProducts.create(on: app.db)
            
            try await app.testing().test(.DELETE, "products/\(testProducts[0].requireID())", afterResponse: { res async throws in
                #expect(res.status == .noContent)
                let model = try await Product.find(testProducts[0].id, on: app.db)
                #expect(model == nil)
            })
        }
    }

    @Test("Updating Product")
    func updateProduct() async throws {
        let testProduct = Product(name: "test1", price: 1999)
        let newDTO = ProductDTO(id: nil, name: nil, price: 1549)
        
        try await withApp { app in
            try await testProduct.create(on: app.db)
            
            try await app.testing().test(.PATCH, "products/\(testProduct.requireID())", beforeRequest: { req in
                try req.content.encode(newDTO)
            }, afterResponse: { res async throws in
                #expect(res.status == .ok)
                if let model = try await Product.find(testProduct.id, on: app.db) {
                    #expect(model.$price.value == newDTO.price)
                }
            })
        }
    }
}

extension ProductDTO: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id && lhs.name == rhs.name && lhs.price == rhs.price
    }
}
