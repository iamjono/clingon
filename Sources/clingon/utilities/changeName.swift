//
//  changeName.swift
//  scaffolder
//
//  Created by Jonathan Guthrie on 2017-04-01.
//
//

import PerfectLib
import SwiftString

func changeName() throws {
	/* =======================================================
	Change the Packages Dir
	======================================================= */
	var filePackage = File("\(fconfig.destinationDir)/Package.swift")
	do {
		try filePackage.open(.readWrite, permissions: .rwUserGroup)
		defer {
			filePackage.close()
		}
	} catch {
		throw scaffoldError.cannotReadFile
	}

	do {
		var packageContents = try filePackage.readString()
		packageContents = packageContents.replacingOccurrences(of: "Perfect-App-Template", with: fconfig.projectName)

		if !fconfig.config.ORMInclude.isEmpty {
			packageContents = packageContents.replacingOccurrences(of: ",\n    ]\n)", with: ",\n        \(fconfig.config.ORMInclude)\n    ]\n)")

		}


		try filePackage.open(.truncate, permissions: .rwUserGroup)
		try filePackage.write(string: packageContents)
		filePackage.close()

	} catch {
		print(error)
		throw scaffoldError.invalidRequest
	}
}
