//
//  changeSourceDir.swift
//  scaffolder
//
//  Created by Jonathan Guthrie on 2017-04-01.
//
//

import PerfectLib
import SwiftString

func changeSourceDir(_ directory: String, _ projectName: String) throws {
	/* =======================================================
	Update the name of the Sources Directory Content Dir.
	======================================================= */
	let sourceProjectDirectory = Dir("\(directory)/Sources/Perfect-App-Template")
	if !sourceProjectDirectory.exists {
		throw scaffoldError.noSourcesSubdirectory
	}
	do {
		try runProc("mv", args: ["\(directory)/Sources/Perfect-App-Template", "\(directory)/Sources/\(projectName)"])
	} catch {
		throw scaffoldError.noSourcesSubdirectory
	}
}
