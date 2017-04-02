//
//  makeHandlers.swift
//  codify
//
//  Created by Jonathan Guthrie on 2017-04-01.
//
//


import PerfectLib

enum handlerType {
	case json, html
}

func makeHandler(_ directory: String, projectName: String, handler: String, hType: handlerType) throws {

	let nl = "//"
	let el = ""

	var str: [String] = ["//"]
	str.append("//  \(handler).swift")
	str.append("//  \(projectName)")
	str.append(nl)
	str.append("//  Created by Jonathan Guthrie on 2017-02-20.")
	str.append("//  Copyright (C) 2017 PerfectlySoft, Inc.")
	str.append(nl)
	str.append("//  Modified by Codify: https://github.com/iamjono/codify")
	str.append(nl)
	str.append("import PerfectHTTP")
	str.append(el)
	str.append("extension Handlers {")
	str.append("    static func \(handler)(data: [String:Any]) throws -> RequestHandler {")
	str.append("        return {")
	str.append("        request, response in")
	if hType == .json {
		str.append("        let _ = try? response.setBody(json: [\"error\": \"Handler \(handler) not implemented\"])")
	} else {
		str.append("        response.setBody(string: \"<html><title>Not Implemented</title><body>This handler (\(handler)) is yet to be implemented</body></html>\")")

	}
	str.append("        response.completed()")
	str.append("        }")
	str.append("    }")
	str.append("}")


	let routeFile = File("\(directory)/Sources/\(projectName)/handlers/\(handler).swift")
	do {
		try routeFile.open(.truncate, permissions: .rwUserGroup)
		try routeFile.write(string: str.joined(separator: "\r\n"))
		routeFile.close()

	} catch {
		print(error)
		throw scaffoldError.invalidRequest
	}
	
	
	
	
}
