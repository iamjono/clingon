//
//  makeTemplates.swift
//  clingon
//
//  Created by Jonathan Guthrie on 2017-04-04.
//
//

import PerfectLib

func makeTemplate(handler: String) throws {

	var str: [String] = ["<html>"]
	str.append("    <title>\(fconfig.projectName) :: \(handler)</title>")
	str.append("    <body>")
	str.append("        <p>\(handler)</p>")
	str.append("    </body>")
	str.append("</html>")
	str.append("")

	// Write file
	do {
		try writeFile("\(fconfig.destinationDir)/webroot/templates/\(handler).mustache", contents: str)
	} catch {
		throw scaffoldError.fileWriteError
	}
	
}
