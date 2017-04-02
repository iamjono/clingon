//
//  writeFile.swift
//  clingon
//
//  Created by Jonathan Guthrie on 2017-04-02.
//
//

import PerfectLib

func writeFile(_ fname: String, contents: [String]) throws {
	let routeFile = File(fname)
	do {
		try routeFile.open(.truncate, permissions: .rwUserGroup)
		try routeFile.write(string: contents.joined(separator: "\r\n"))
		routeFile.close()

	} catch {
		print(error)
		throw scaffoldError.fileWriteError
	}

}
