//
//  changeSourceDir.swift
//  scaffolder
//
//  Created by Jonathan Guthrie on 2017-04-01.
//
//

import PerfectLib
import SwiftString

func changeSourceDir() throws {
	/* =======================================================
	Update the name of the Sources Directory Content Dir.
	======================================================= */
	let sourceProjectDirectory = Dir("\(fconfig.destinationDir)/Sources/Perfect-App-Template")
	if !sourceProjectDirectory.exists {
		throw scaffoldError.noSourcesSubdirectory
	}
	do {
		try runProc("mv", args: ["\(fconfig.destinationDir)/Sources/Perfect-App-Template", "\(fconfig.destinationDir)/Sources/\(fconfig.projectName)"])
	} catch {
		throw scaffoldError.noSourcesSubdirectory
	}
}
