//
//  main.swift
//  scaffolder
//
//  Created by Jonathan Guthrie on 2017-04-01.
//
//


/*
rm -R /Users/jonathanguthrie/Documents/development/tests/SCAFFOLDTESTS/1 ; swift build; .build/debug/clingon --root /Users/jonathanguthrie/Documents/development/iamjono/clingon/demos/example.json  --dest /Users/jonathanguthrie/Documents/development/tests/SCAFFOLDTESTS/1
*/

import PerfectLib
import Foundation
import Darwin

// File source JSON for parsing
var sourceFile: String? = nil

// Destination directory
var destinationDirectory: String? = nil

var args = CommandLine.arguments.makeIterator()
var currArg = args.next()

func usage() {
	print("Usage: \(CommandLine.arguments.first!) [--root source_json] [--dest destination_dir]")
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

let validArgs = [
	"--root": {
		sourceFile = argFirst()
	},
	"--dest": {
		destinationDirectory = argFirst()
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

