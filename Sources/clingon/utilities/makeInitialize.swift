//
//  makeInitialize.swift
//  clingon
//
//  Created by Jonathan Guthrie on 2017-04-02.
//
//


import PerfectLib


func makeInitialize() throws {

	let nl = "//"
	let el = ""

	var str: [String] = ["//"]
	str.append("//  initializeObjects.swift")
	str.append("//  \(fconfig.projectName)")
	str.append(nl)
	str.append("//  Created by Jonathan Guthrie on 2017-02-20.")
	str.append("//  Copyright (C) 2017 PerfectlySoft, Inc.")
	str.append(nl)
	str.append("//  Modified by Clingon: https://github.com/iamjono/clingon")
	str.append(nl)
	str.append("import PerfectLib")
	str.append(el)
	str.append("extension Utility {")
	str.append("    static func initializeObjects() {")

	var counter = 0
	for cc in fconfig.classes {

		if cc.includeSetup {
			str.append(el)
			str.append("        let a\(counter) = \(cc.name)()")
			str.append("        try? a\(counter).setup()")
			counter += 1
		}
	}
	str.append(el)
	str.append("    }")
	str.append("}")


	// Write file
	do {
		try writeFile("\(fconfig.destinationDir)/Sources/\(fconfig.projectName)/objects/initializeObjects.swift", contents: str)
	} catch {
		throw scaffoldError.fileWriteError
	}

}
