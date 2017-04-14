//
//  makeHandlers.swift
//  clingon
//
//  Created by Jonathan Guthrie on 2017-04-01.
//
//


import PerfectLib



func makeHandler(handler: String, responseType: handlerType, apicomment: String = "") throws {

	let nl = "//"
	let el = ""

	var str: [String] = ["//"]
	str.append("//  \(handler).swift")
	str.append("//  \(fconfig.projectName)")
	str.append(nl)
	str.append("//  Created by Jonathan Guthrie on 2017-02-20.")
	str.append("//  Copyright (C) 2017 PerfectlySoft, Inc.")
	str.append(nl)
	str.append("//  Modified by Clingon: https://github.com/iamjono/clingon")
	str.append(nl)

	str.append("import PerfectHTTP")
	if responseType == .html { str.append("import PerfectMustache") }

	str.append(el)
	str.append("extension Handlers {")
	if !apicomment.isEmpty { str.append("    /// \(apicomment)") }
	str.append("    static func \(handler)(data: [String:Any]) throws -> RequestHandler {")
	str.append("        return {")
	str.append("        request, response in")

	// response type switch
	if responseType == .json {
		str.append("            let _ = try? response.setBody(json: [\"error\": \"Handler \(handler) not implemented\"])")
	} else {
		do {
			try makeTemplate(handler: handler)
			str.append("            let context: [String : Any] = [")
			str.append("                \"property\": \"value\"")
			str.append("            ]")
			str.append("            response.render(template: \"templates/\(handler)\", context: context)")
		} catch {
			str.append("            response.setBody(string: \"<html><title>Not Implemented</title><body>This handler (\(handler)) is yet to be implemented</body></html>\")")
			print("unable to create handler template for \(handler)")
		}
	}

	
	str.append("            response.completed()")
	str.append("        }")
	str.append("    }")
	str.append("}")
	str.append("")

	// Write file
	do {
		try writeFile("\(fconfig.destinationDir)/Sources/\(fconfig.projectName)/handlers/\(handler).swift", contents: str)
	} catch {
		throw scaffoldError.fileWriteError
	}
	
}
