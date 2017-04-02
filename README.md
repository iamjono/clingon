# Clingon

The Swift project scaffolding application.

This project builds a command line application which is then used to generate full code scaffolds for an API or Web Application from a JSON file.

It allows you to specify all routes, handlers, classes and class properties - and then generates them.

The resulting codebase is ready to go with [Perfect](https://www.perfect.org) base HTTP Server libraries, plus HTTP logging, Mustache support, optional ORM and Session support. The code is organized as in the pattern of the [Perfect App Template](https://github.com/PerfectlySoft/PerfectAppTemplate).



## Usage

This application requires Swift 3.1 on macOS. While it may work on Swift 3.0.2 or earlier, YMMV.

Once cloned, build with `swift build` then to use:

``` bash
.build/debug/clingon \n
	--config <path_to_json> \n
	--dest <path_to_destination_dir> \n
	--xcode y
```

* The `--config` argument is the path to your JSON file **[Required]**.
* The `--dest` argument is the path to your directory you wish to create the project in **[Required]**.
* The `--xcode` argument determines if an Xcode project file is created **[Optional]**.


## JSON File

The JSON file specifies the properties that Clingon gives your generated code.


``` json
{
	"projectName": "sample",
	"config": {
		"includeHealthCheck" : "true",
		"includeSessionFilters" : "false",
		"ORMDriver": "SQLite",
		"HTTPPort": 8181
	},
	"classes" : [
			{
				"name" : "Test",
				"inherits" : "SQLiteStORM",
				"includeORMSupport" : "true",
				"properties" : [
								{"name":"id","type": "Int", "default": 0},
								{"name":"prop","type": "String", "default": ""},
								{"name":"val","type": "String", "default": ""}
								],
				"includeSetup": "true"
			},
			 {
				 "name" : "Test2",
				 "inherits" : "SQLiteStORM",
				 "includeORMSupport" : "true",
				 "properties" : [
								 {"name":"id","type": "Int", "default": 0},
								 {"name":"one","type": "String", "default": ""},
								 {"name":"two","type": "String", "default": ""}
								 ],
				 "includeSetup": "true"
			 }
	],
	"routes" : [
				{"method": "get", "route": "/hello", "handler": "helloWorld", "type": "html"},
				{"method": "get", "route": "/monster", "handler": "monsterizer", "type": "json"}
	]
}
```

### Base Specification

Property | Description | Value Type | Restrictions
---- | ---- | ---- | ----
projectName | The name of the project | String | No spaces or special characters
config | The configuration of the project | See config spec | 
classes | The object classes to generate | See classes spec | 
routes | The routes and handlers to generate | See routes spec |

### Config Specification

Property | Description | Value Type | Restrictions
---- | ---- | ---- | ----
includeHealthCheck | If true, includes a `/healthcheck` route | Bool | Default: false
includeSessionFilters | If true, includes the Session driver filters | Bool | Default: false
ORMDriver | The ORM Driver to use | String | Default: none. Options: SQLite, MySQL, PostgreSQL, MongoDB, CouchDB
HTTPPort | Port number for HTTP Server | Int | Default: 8181


### Classes Specification

This is an array of zero or more Classes.

Property | Description | Value Type | Restrictions
---- | ---- | ---- | ----
name | The class name | String | No spaces or special characters
inherits | The class or protocol to inherit | String | No spaces or special characters
includeORMSupport | Add ORM-specific helpers | Bool | Default: false
properties | An array of zero or more properties | See properties spec |
includeSetup | Include "Setup" run at application startup | Bool | Default: false


### Properties Specification

This is an array of zero or more Properties.

Property | Description | Value Type | Restrictions
---- | ---- | ---- | ----
name | The property name | String | No spaces or special characters
type | The Swift type of the property | String | Must be a valid Swift type
default | The default value to assign | Any | Must conform to the property type


### Routes Specification

This is an array of zero or more Routes.

Property | Description | Value Type | Restrictions
---- | ---- | ---- | ----
method | The HTTP method | String | Default: get. Must be a valid HTTP verb, lowercase.
route | The route for matching | String | No spaces or special characters. Must conform to routing syntax. May include wildcards.
handler | The function name to trigger on route match. Note that this function will be a function extension to class `Handlers` | String | No spaces or special characters
type | The Response Type | String | Default: html. Options: html, json



# License

This code is licensed as per the Apache 2.0 license, included in this repository.

# Author

Jonathan Guthrie: [https://github.com/iamjono](https://github.com/iamjono) >> Twitter: [@iamjono](https://twitter.com/iamjono)

# Issues & Pull Requests

If you have problems with executing the code, please first try pinging me on the [Perfect Slack](http://www.perfect.ly) ([www.perfect.ly](http://www.perfect.ly)), else post an issue!

Pull requests for improvements and fixing are welcome!

Thanks; 
Jono