//
//  processChanges.swift
//  scaffolder
//
//  Created by Jonathan Guthrie on 2017-04-01.
//
//

import PerfectLib
import SwiftString


func processChanges() throws {

	/* =======================================================
	Change the Packages Dir
	======================================================= */
	do {
		try changeName()
		print("Package name set")
	} catch {
		throw error
	}
	/* =======================================================
	Update the name of the Sources Directory Content Dir.
	======================================================= */
	do {
		try changeSourceDir()
		print("Sources directory name set")
	} catch {
		throw error
	}
	/* =======================================================
	Routes
	======================================================= */
	do {
		try makeRoutes()
		print("Routes and handlers complete")
	} catch {
		throw error
	}
	/* =======================================================
	Classes
	======================================================= */
	do {
		try makeClasses()
		try makeInitialize()
		print("Classes complete")
	} catch {
		// non-fatal.
		print(error)
	}


}
