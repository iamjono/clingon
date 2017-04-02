//
//  clone.swift
//  scaffolder
//
//  Created by Jonathan Guthrie on 2017-04-01.
//
//

import PerfectLib

func clone(_ path: String) {
	do {
		// git clone
		try runProc("git", args: [
			"clone",
			"https://github.com/PerfectlySoft/PerfectAppTemplate.git",
			path
		])

		// remove .git dir
		try runProc("rm", args: [
			"-fR",
			"\(path)/.git/"
			])

	} catch {
		print(error)
	}
}
