//
//  configuration.swift
//  clingon
//
//  Created by Jonathan Guthrie on 2017-04-01.
//
//

import PerfectLib
import JSONConfig

class Configuration {
	var destinationDir: String = ""
	var projectName: String = ""
	var config: ConfigurationConfig = ConfigurationConfig()
	var classes: [ConfigurationClasses] = [ConfigurationClasses]()
	var routes: [ConfigurationRoutes] = [ConfigurationRoutes]()

	init(){}

	init(_ fileName: String, destinationDirectory: String) throws {
		destinationDir = destinationDirectory

		if let configData = JSONConfig(name: fileName) {
			if let data = configData.getValues() {

				// Start processing and assigning
				guard let pName = data["projectName"] else {
					throw scaffoldError.noPackageName
				}
				projectName = pName as! String


				// =============================================
				// Config
				// =============================================
				guard let c = data["config"] else {
					throw scaffoldError.noConfig
				}
				let cc = c as! [String: Any]
				config = ConfigurationConfig(cc)
//				print(config.ORMDriver)

				// =============================================
				// Routes
				// =============================================
				guard let r = data["routes"] else {
					throw scaffoldError.noRoutes
				}
				guard let rr = r as? [[String: String]] else {
					throw scaffoldError.invalidRoutes
				}
				rr.forEach{routes.append(ConfigurationRoutes($0))}

				// =============================================
				// Classes
				// =============================================
				guard let cl = data["classes"] else {
					throw scaffoldError.noClasses
				}
				guard let clcl = cl as? [[String: Any]] else {
					throw scaffoldError.invalidClasses
				}
				clcl.forEach{classes.append(ConfigurationClasses($0))}



			} else {
				fatalError("Unable to get Configuration")
			}
		} else {
			fatalError("Unable to get Configuration")
		}

	}
}

class ConfigurationConfig {
	var includeHealthCheck = true
	var includeSessionFilters = false
	var ORMDriver: ORMDriver = .none
	var sessionDriver: SessionDriver = .none
	var HTTPPort = 8181

	var ORMClass = ""
	var ORMInclude = ""
	var sessionDriverInclude = ""

	init() {}
	init(_ cc: [String: Any]) {
//		print("Setting ConfigurationConfig: \(cc)")

		if cc["includeHealthCheck"] as! String == "false" { includeHealthCheck = false }
		if cc["includeSessionFilters"] as! String == "true" { includeSessionFilters = true }
		if let port = cc["HTTPPort"] { HTTPPort = port as! Int }

		switch cc["ORMDriver"] as? String {
		case "SQLite"?:
			ORMDriver = .SQLite
			ORMClass = "SQLiteStORM"
			ORMInclude = ".Package(url: \"https://github.com/SwiftORM/SQLite-StORM.git\", majorVersion: 1)"
		case "PostgreSQL"?:
			ORMDriver = .PostgreSQL
			ORMClass = "PostgresStORM"
			ORMInclude = ".Package(url: \"https://github.com/SwiftORM/Postgres-StORM.git\", majorVersion: 1)"
		case "MySQL"?:
			ORMDriver = .MySQL
			ORMClass = "MySQLStORM"
			ORMInclude = ".Package(url: \"https://github.com/SwiftORM/MySQL-StORM.git\", majorVersion: 1)"
		case "CouchDB"?:
			ORMDriver = .CouchDB
			ORMClass = "CouchDBStORM"
			ORMInclude = ".Package(url: \"https://github.com/SwiftORM/CouchDB-StORM.git\", majorVersion: 1)"
		case "MongoDB"?:
			ORMDriver = .MongoDB
			ORMClass = "MongoDBStORM"
			ORMInclude = ".Package(url: \"https://github.com/SwiftORM/MongoDB-StORM.git\", majorVersion: 1)"
		default:
			ORMDriver = .none
		}

		print("ORMDriver is \(ORMDriver)")

		if let sdriver = cc["SessionDriver"] {
			switch sdriver as! String {
			case "Redis":
				sessionDriver = .Redis
			case "SQLite":
				sessionDriver = .SQLite
			case "PostgreSQL":
				sessionDriver = .PostgreSQL
			case "MySQL":
				sessionDriver = .MySQL
			case "CouchDB":
				sessionDriver = .CouchDB
			case "MongoDB":
				sessionDriver = .MongoDB
			default:
				sessionDriver = .none
			}
		}

	}

}

class ConfigurationClasses {
	var name = ""
	var inherits = ""
	var properties: [ConfigurationClassProperties] = [ConfigurationClassProperties]()
	var includeORMSupport = false
	var includeSetup = false

	init(_ cc: [String: Any]) {

		name		= cc["name"] as? String ?? "invalidName"
		inherits	= cc["inherits"] as? String ?? ""

		let classSetupStr	= cc["includeSetup"] as? String ?? "false"
		if classSetupStr == "true" { includeSetup = true }

		let includeORMSup	= cc["includeORMSupport"] as? String ?? "false"
		if includeORMSup == "true" { includeORMSupport = true }
		print(includeORMSupport)


		let cp = cc["properties"] as? [[String: Any]]
		cp?.forEach{properties.append(ConfigurationClassProperties($0))}
	}

}

class ConfigurationRoutes {
	var method = "get"
	var route = "unimplimented"
	var handler = "unimplimented"
	var responseType: handlerType = .html

	init(_ rr: [String: String]) {
		method = rr["method"] ?? "get"
		route = rr["route"] ?? "/unimplimented"
		handler = rr["handler"] ?? "unimplimented"

		let thisHandlerType = rr["type"] ?? "html"
		if thisHandlerType == "json" {
			responseType = .json
		}
	}

}

class ConfigurationClassProperties {
	var name = ""
	var propertyType = ""
	var defaultValue: Any = ""

	init(_ props: [String: Any]) {
		name				= props["name"] as? String ?? "invalidName"
		propertyType		= props["type"] as? String ?? "String"
		defaultValue		= props["default"] ?? ""
	}

}


enum handlerType {
	case json, html
}

enum ORMDriver {
	case none, SQLite, MySQL, PostgreSQL, MongoDB, CouchDB
}

enum SessionDriver {
	case none, SQLite, MySQL, PostgreSQL, MongoDB, CouchDB, Redis
}

