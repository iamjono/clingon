//
//  errors.swift
//  scaffolder
//
//  Created by Jonathan Guthrie on 2017-04-01.
//
//


public enum scaffoldError: Error {
	/// The request was invalid
	case invalidRequest,

	/// cannot read file
	cannotReadFile,

	/// no package name
	noPackageName,

	/// no Sources SubDir
	noSourcesSubdirectory,

	/// Routes & Handlers
	noRoutes,
	invalidRoutes,
	cannotMakeHandler,

	/// no Config
	noConfig,


	/// The method is unimplemented
	unimplemented
}
