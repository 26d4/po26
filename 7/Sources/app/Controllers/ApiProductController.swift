import Fluent
import Vapor

struct ApiProductController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let products = routes.grouped("products")

        products.get(use: self.index)
        products.post(use: self.create)
        products.group(":productID") { product in
            product.delete(use: self.delete)
            product.put(use: self.update)
            product.patch(use: self.update)
        }
    }

    @Sendable
    func index(req: Request) async throws -> [ProductDTO] {
        try await Product.query(on: req.db).all().map { $0.toDTO() }
    }

    @Sendable
    func create(req: Request) async throws -> ProductDTO {
        let product = try req.content.decode(ProductDTO.self).toModel()

        try await product.save(on: req.db)
        return product.toDTO()
    }

    @Sendable
    func delete(req: Request) async throws -> HTTPStatus {
        guard let product = try await Product.find(req.parameters.get("productID"), on: req.db) else {
            throw Abort(.notFound)
        }

        try await product.delete(on: req.db)
        return .noContent
    }

    @Sendable
    func update(req: Request) async throws -> ProductDTO {
        guard let id = req.parameters.get("productID", as: UUID.self) else {
            throw Abort(.badRequest)
        }

        let input = try req.content.decode(ProductDTO.self)

        guard let product = try await Product.find(id, on: req.db) else {
            throw Abort(.notFound)
        }

        try needValue(v: input.name, method: req.method)
        try needValue(v: input.price, method: req.method)

        product.name = input.name ?? product.name
        product.price = input.price ?? product.price

        try await product.update(on: req.db)
        return product.toDTO()
    }
}
