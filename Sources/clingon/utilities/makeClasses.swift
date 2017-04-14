//
//  makeClasses.swift
//  clingon
//
//  Created by Jonathan Guthrie on 2017-04-01.
//
//


import PerfectLib


func makeClasses() throws {

	for cc in fconfig.classes {

		var classInheritsStr = ""

		if !cc.inherits.isEmpty {
			classInheritsStr = ": \(cc.inherits)"
		}

		let nl = "//"
		let el = ""

		var str: [String] = ["//"]
		str.append("//  \(cc.name).swift")
		str.append("//  \(fconfig.projectName)")
		str.append(nl)
		str.append("//  Created by Jonathan Guthrie on 2017-02-20.")
		str.append("//  Copyright (C) 2017 PerfectlySoft, Inc.")
		str.append(nl)
		str.append("//  Modified by Clingon: https://github.com/iamjono/clingon")
		str.append(nl)
		str.append("import PerfectLib")
		// ORM
		if !fconfig.config.ORMClass.isEmpty {
			str.append("import \(fconfig.config.ORMClass)")
			str.append("import StORM")
		}
		str.append(el)
		// Class
		if !cc.apicomment.isEmpty { str.append("/// \(cc.apicomment)") }
		str.append("class \(cc.name)\(classInheritsStr) {")
		str.append(el)
		str.append("    // Properties")

		for props in cc.properties {
			if !props.apicomment.isEmpty { str.append("    /// \(props.apicomment)") }
			switch props.propertyType {
			case "String":
				str.append("    public var \(props.name) = \"\(props.defaultValue)\"")
			default:
				str.append("    public var \(props.name) = \(props.defaultValue)")
			}
			str.append(el)
		}
		if cc.includeORMSupport {
			str.append(el)

			str.append("    // ORM helper method")
			str.append("    override public func to(_ this: StORMRow) {")
			for props in cc.properties {
				switch props.propertyType {
				case "String":
					str.append("        \(props.name) = this.data[\"\(props.name)\"] as? String ?? \"\(props.defaultValue)\"")
				case "[String:Any]":
					str.append("        if let dataObj = this.data[\"\(props.name)\"] { \(props.name) = (dataObj as? [String:Any])! }")
				case "[String]":
					str.append("        if let dataObj = this.data[\"\(props.name)\"] { \(props.name) = (dataObj as? String ?? \"\").components(separatedBy: \",\") }")
				default:
					str.append("        \(props.name) = this.data[\"\(props.name)\"] as? \(props.propertyType) ?? \(props.defaultValue)")
				}
			}
			str.append("    }")
			str.append(el)

			str.append("    // ORM helper method")
			str.append("    func rows() -> [\(cc.name)] {")
			str.append("        var rows = [\(cc.name)]()")
			str.append("        for i in 0..<self.results.rows.count {")
			str.append("            let row = \(cc.name)()")
			str.append("            row.to(self.results.rows[i])")
			str.append("            rows.append(row)")
			str.append("        }")
			str.append("        return rows")
			str.append("    }")
			str.append(el)
		}

		str.append("}")
		str.append("")


		// Write file
		do {
			try writeFile("\(fconfig.destinationDir)/Sources/\(fconfig.projectName)/objects/\(cc.name).swift", contents: str)
		} catch {
			throw scaffoldError.fileWriteError
		}


	}
	
}
