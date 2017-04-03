//
//  main.swift
//  scaffolder
//
//  Created by Jonathan Guthrie on 2017-04-01.
//
//


/*
rm -R /Users/jonathanguthrie/Documents/development/tests/SCAFFOLDTESTS/1 ; swift build; .build/debug/clingon --config /Users/jonathanguthrie/Documents/development/iamjono/clingon/demos/example.json  --dest /Users/jonathanguthrie/Documents/development/tests/SCAFFOLDTESTS/1
*/

import PerfectLib
import Foundation
import Darwin

// File source JSON for parsing
var sourceFile: String? = nil
var generateXcodeProject: Bool = false

// Destination directory
var destinationDirectory: String? = nil

var args = CommandLine.arguments.makeIterator()
var currArg = args.next()

func usage() {
	print("Usage: \(CommandLine.arguments.first!) [--config source_json] [--dest destination_dir] [--xcode xcode]")
	exit(0)
}

func argFirst() -> String {
	currArg = args.next()
	guard let frst = currArg else {
		print("Argument requires value.")
		exit(-1)
	}
	return frst
}

func argOptBoolean() -> Bool {
	currArg = args.next()
	guard let _ = currArg else {
		return false
	}
	return true
}

let validArgs = [
	"--config": {
		sourceFile = argFirst()
	},
	"--dest": {
		destinationDirectory = argFirst()
	},
	"--xcode": {
		generateXcodeProject = argOptBoolean()
	},
	"--help": {
		usage()
	}]

while let arg = currArg {
	if let closure = validArgs[arg.lowercased()] {
		closure()
	}
	currArg = args.next()
}

guard let srcs = sourceFile else {
	usage()
	exit(0)
}

struct ProcError: Error {
	let code: Int
	let msg: String?
}



// clone to destination
clone(destinationDirectory!)


var fconfig = Configuration()
// read config
do {
	fconfig = try Configuration(sourceFile!, destinationDirectory: destinationDirectory!)
	try processChanges()
} catch {
	fatalError("Could not process configuration file")
}

if generateXcodeProject {
	do {
		// Make Xcode Project file
		let d = Dir(destinationDirectory!)
		try d.setAsWorkingDir()
		try runProc("swift", args: ["package", "generate-xcodeproj"])
		print("Generated Xcode project file")
	} catch {
		print(error)
	}
}
