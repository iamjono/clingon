//
//  processChanges.swift
//  scaffolder
//
//  Created by Jonathan Guthrie on 2017-04-01.
//
//

import PerfectLib
import SwiftString


func processChanges(_ data: [String: Any], _ directory: String) throws {

//	var d = Dir(directory)

	guard let projectName = data["projectName"] else {
		throw scaffoldError.noPackageName
	}

	/* =======================================================
	Change the Packages Dir
	======================================================= */
	do {
		try changeName(directory, projectName as! String)
	} catch {
		throw error
	}
	/* =======================================================
	Update the name of the Sources Directory Content Dir.
	======================================================= */
	do {
		try changeSourceDir(directory, projectName as! String)
	} catch {
		throw error
	}
	/* =======================================================
	Routes
	======================================================= */
	do {
		try makeRoutes(directory, projectName: projectName as! String, data: data)
	} catch {
		throw error
	}


}
