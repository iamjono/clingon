//
//  makeRoutes.swift
//  scaffolder
//
//  Created by Jonathan Guthrie on 2017-04-01.
//
//

import PerfectLib


/*
import PerfectHTTPServer

func mainRoutes() -> [[String: Any]] {

var routes: [[String: Any]] = [[String: Any]]()
// Special healthcheck
routes.append(["method":"get", "uri":"/healthcheck", "handler":Handlers.healthcheck])

// Handler for home page
routes.append(["method":"get", "uri":"/", "handler":Handlers.main])


return routes
}
*/


func makeRoutes(_ directory: String, projectName: String, data: [String: Any]) throws {
	// Data must have Config section
	guard let c = data["config"] else {
		throw scaffoldError.noConfig
	}
	// Data must have Routes section
	guard let r = data["routes"] else {
		throw scaffoldError.noRoutes
	}

	let config = c as! [String: Any]
	guard let routes = r as? [[String: String]] else {
		throw scaffoldError.invalidRoutes
	}
	var includeHealthCheck = false
	if config["includeHealthCheck"] as! String == "true" { includeHealthCheck = true }

	let nl = "//"
	let el = ""

	var str: [String] = ["//"]
	str.append("//  Routes.swift")
	str.append("//  \(projectName)")
	str.append(nl)
	str.append("//  Created by Jonathan Guthrie on 2017-02-20.")
	str.append("//  Copyright (C) 2017 PerfectlySoft, Inc.")
	str.append(nl)
	str.append("//===----------------------------------------------------------------------===//")
	str.append(nl)
	str.append("// This source file is part of the Perfect.org open source project")
	str.append(nl)
	str.append("// Copyright (c) 2015 - 2016 PerfectlySoft Inc. and the Perfect project authors")
	str.append("// Licensed under Apache License v2.0")
	str.append(nl)
	str.append("// See http://perfect.org/licensing.html for license information")
	str.append(nl)
	str.append("//===----------------------------------------------------------------------===//")
	str.append(nl)
	str.append("//  Modified by Codify: https://github.com/iamjono/codify")
	str.append(nl)
	str.append("import PerfectHTTPServer")
	str.append(el)
	str.append("func mainRoutes() -> [[String: Any]] {")
	str.append("    var routes: [[String: Any]] = [[String: Any]]()")
	if includeHealthCheck {
		str.append("    // Special healthcheck")
		str.append("    routes.append([\"method\":\"get\", \"uri\":\"/healthcheck\", \"handler\":Handlers.healthcheck])")
	}
	for rr in routes {
		let thisMethod = rr["method"] ?? "get"
		let thisRoute = rr["route"] ?? "/unimplimented"
		let thisHandler = rr["handler"] ?? "unimplimented"
		let thisHandlerType = rr["type"] ?? "html"
		var thisHandlerTypeType: handlerType = .html
		if thisHandlerType == "json" {
			thisHandlerTypeType = .json
		}

		str.append("    routes.append([\"method\":\"\(thisMethod)\", \"uri\":\"\(thisRoute)\", \"handler\":Handlers.\(thisHandler)])")
		do {
			try makeHandler(directory, projectName: projectName, handler: thisHandler, hType: thisHandlerTypeType)
		} catch {
			throw scaffoldError.cannotMakeHandler
		}
	}
	str.append("    return routes")
	str.append("}")

	
	let routeFile = File("\(directory)/Sources/\(projectName)/configuration/Routes.swift")
	do {
		try routeFile.open(.truncate, permissions: .rwUserGroup)
		try routeFile.write(string: str.joined(separator: "\r\n"))
		routeFile.close()

	} catch {
		print(error)
		throw scaffoldError.invalidRequest
	}




}
