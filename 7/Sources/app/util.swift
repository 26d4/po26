import Vapor

func needValue(v: Any?, method: HTTPMethod) throws {
	if v == nil && method == .PUT {
		throw Abort(.badRequest)
	}
}