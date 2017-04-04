//
//  makeRoutes.swift
//  scaffolder
//
//  Created by Jonathan Guthrie on 2017-04-01.
//
//

import PerfectLib

func makeRoutes() throws {

	let nl = "//"
	let el = ""

	var str: [String] = ["//"]
	str.append("//  Routes.swift")
	str.append("//  \(fconfig.projectName)")
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
	str.append("//  Modified by Clingon: https://github.com/iamjono/clingon")
	str.append(nl)
	str.append("import PerfectHTTPServer")
	str.append(el)
	str.append("func mainRoutes() -> [[String: Any]] {")
	str.append("    var routes: [[String: Any]] = [[String: Any]]()")
	str.append("    routes.append([\"method\":\"get\", \"uri\":\"/**\", \"handler\":PerfectHTTPServer.HTTPHandler.staticFiles, \"documentRoot\":\"./webroot\",\"allowResponseFilters\":true])")
	str.append(el)
	if fconfig.config.includeHealthCheck {
		str.append("    /// Special healthcheck route")
		str.append("    routes.append([\"method\":\"get\", \"uri\":\"/healthcheck\", \"handler\":Handlers.healthcheck])")
		str.append(el)
	}
	for rr in fconfig.routes {
		if !rr.apicomment.isEmpty { str.append("    /// \(rr.apicomment)") }
		str.append("    routes.append([\"method\":\"\(rr.method)\", \"uri\":\"\(rr.route)\", \"handler\":Handlers.\(rr.handler)])")
		do {
			try makeHandler(handler: rr.handler, responseType: rr.responseType, apicomment: rr.apicomment)
		} catch {
			throw scaffoldError.cannotMakeHandler
		}
		str.append(el)
	}
	str.append("    return routes")
	str.append("}")


	// Write file
	do {
		try writeFile("\(fconfig.destinationDir)/Sources/\(fconfig.projectName)/configuration/Routes.swift", contents: str)
	} catch {
		throw scaffoldError.fileWriteError
	}





}
