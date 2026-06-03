import Fluent
import Vapor

struct ProductController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let products = routes.grouped("products")

        products.get(use: self.index)
        products.group("new") { product in
            product.post(use: self.create)
            product.get(use: self.create_form)
        }
        products.group(":productID") { product in
            product.get("delete", use: self.delete)
            product.get("edit", use: self.update_form)
            product.post("edit", use: self.update)
        }
    }

    @Sendable
    func index(req: Request) async throws -> View {
        let products = try await Product.query(on: req.db).all()
        // in a sane language you would just be able to use a dict
        struct ProductListContext: Encodable {
            let title: String
            let products: [Product]
        }
        return try await req.view.render("products", ProductListContext(title: "Products", products: products))
    }

    @Sendable
    func create(req: Request) async throws -> Response {
        let product = try req.content.decode(ProductDTO.self).toModel()

        try await product.save(on: req.db)
        return req.redirect(to: "/products")
    }

    @Sendable
    func create_form(req: Request) async throws -> View {
        return try await req.view.render("product_form", ["title": "New product", "action": "/products/new"])
    }

    @Sendable
    func delete(req: Request) async throws -> Response {
        guard let product = try await Product.find(req.parameters.get("productID"), on: req.db) else {
            throw Abort(.notFound)
        }

        try await product.delete(on: req.db)
        return req.redirect(to: "/products")
    }

    @Sendable
    func update(req: Request) async throws -> Response {
        guard let id = req.parameters.get("productID", as: UUID.self) else {
            throw Abort(.badRequest)
        }

        let input = try req.content.decode(ProductDTO.self)

        guard let product = try await Product.find(id, on: req.db) else {
            throw Abort(.notFound)
        }

        product.name = input.name ?? product.name
        product.price = input.price ?? product.price

        try await product.update(on: req.db)
        return req.redirect(to: "/products")
    }

    @Sendable
    func update_form(req: Request) async throws -> View {
        guard let id = req.parameters.get("productID", as: UUID.self) else {
            throw Abort(.badRequest)
        }

        guard let product = try await Product.find(id, on: req.db) else {
            throw Abort(.notFound)
        }

        struct ProductFormContext: Encodable {
            let title: String
            let action: String
            let product: Product
        }
        return try await req.view.render(
            "product_form",
            ProductFormContext(
                title: "Edit \(product.name)",
                action: "/products/\(id)/edit",
                product: product
            )
        )
    }
}
