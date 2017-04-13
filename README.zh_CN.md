# Clingon [English](README.md)

<p>
    <a href="https://developer.apple.com/swift/" target="_blank">
        <img src="https://img.shields.io/badge/Swift-3.1-orange.svg?style=flat" alt="Swift 3.1">
    </a>
    <a href="https://developer.apple.com/swift/" target="_blank">
        <img src="https://img.shields.io/badge/Platforms-macOS-lightgray.svg?style=flat" alt="Platforms macOS">
    </a>
    <a href="http://perfect.org/licensing.html" target="_blank">
        <img src="https://img.shields.io/badge/License-Apache-lightgrey.svg?style=flat" alt="License Apache">
    </a>
    <a href="http://twitter.com/iamjono" target="_blank">
        <img src="https://img.shields.io/badge/Twitter-@iamjono-blue.svg?style=flat" alt="PerfectlySoft Twitter">
    </a>
    <a href="http://www.perfect.ly" target="_blank">
        <img src="http://www.perfect.ly/badge.svg" alt="Slack Status">
    </a>
</p>

徒手登山或者拿着汤勺挖地道总是很困难的事情——程序设计也是如此。

因此我们期望在编程过程中使用代码折叠——不是上来就写源程序，而是首先控制程序接口，因为高级接口的逻辑性比底层代码更重要。

本项目允许您直接设计所有的网络服务程序接口路径、具柄、数据类对象和属性，甚至是未来参考手册用的内建程序标注。

本项目的结果集可以直接用 [Perfect](https://www.perfect.org) 服务器运行，需要附加HTTP 日志、Mustache模板支持，当然还有ORM关系数据库对象管理自动化函数库和网络会话函数库；本项目基于 [Perfect App Template](https://github.com/PerfectlySoft/PerfectAppTemplate)设计思路。

本项目会编译一个命令行程序，只要输入一个符合格式要求的JSON文件，就可以自动生成成完整的可折叠代码模板，用于管理您期望实施的新服务器编程计划。



## 使用方法

本程序基于macOS平台并使用 Swift 3.1 编译，不过也向下兼容Swift 3.0.2或者更早期的版本。

在复制本工程后，请使用标准的`$ swift build` 命令编译并运行：

``` bash
.build/debug/clingon \n
	--config <path_to_json> \n
	--dest <path_to_destination_dir> \n
	--xcode y
```

* 参数 `--config` 指向您需要输入的JSON文件 **[必选项]**。
* 参数 `--dest` 指向您即将保存新代码工程目录 **[必选项]**。
* 参数 `--xcode` 用于说明是否需要同时伴生一个Xcode工程 **[可选项]**。


## JSON 文件输入

请为您的工程提供一个JSON文件作为输入，内容是目标折叠代码的诸多属性，用于Clingon工程自动生成代码。


``` json
{
	"projectName": "这里填写项目名称",
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

### 基本参数说明

属性 | 说明 | 值类型 | 限制条件
---- | ---- | ---- | ----
projectName | 项目名称 | String | 不要有空格、不要有特殊字符
config | 项目配置数据 | 请参考config对象细节 | 
classes | 待创建的类 | 详见类说明 | 
routes | 待创建的路由及具柄 | 详见具柄说明 |

### Config 配置对象说明

属性 | 说明 | 值类型 | 限制条件
---- | ---- | ---- | ----
includeHealthCheck | 如果为真，则自动新建一个 `/healthcheck` 健康检查路由 | Bool | 默认值为假
includeSessionFilters | 如果为真，则自动包括会话管理驱动程序 | Bool | 默认为假
ORMDriver | 需要使用的关系数据库对象管理自动化驱动 | String | 默认为 none。可选项: SQLite, MySQL, PostgreSQL, MongoDB, CouchDB
HTTPPort | HTTP服务器端口号 | Int | 默认为 8181


### Classes 类对象说明

Classes是一个数组，可以包含零个或多个类对象。

属性 | 说明 | 值类型 | 限制条件
---- | ---- | ---- | ----
name | 类名称 | String | 不要有空格或者特殊字符
inherits | 需要继承的基类或者兼容的协议 | String | 不要有空格或者特殊字符
includeORMSupport | 增加ORM关系数据库对象管理自动化辅助工具 | Bool | 默认为假，即不包括该辅助工具
properties | 数组，包括零个或多个属性对象 | 详见属性说明 |
includeSetup | 是否包括在应用程序启动时的设置程序 | Bool | 默认为假，即不包括


### Properties 属性说明

Properties是一个数组，可以包含零个或多个属性对象。

属性 | 说明 | 值类型 | 限制条件
---- | ---- | ---- | ----
name | 属性名称 | String | 不要有空格或者特殊字符
type | 该属性的 Swift 变量类型 | String | 必须为有效的 Swift 类型
default | 默认值 | Any | 值类型必须和变量类型保持一致


### Routes 路由说明

Routes是一个数组，可以包含零个或多个路由对象。

属性 | 说明 | 值类型 | 限制条件
---- | ---- | ---- | ----
method | HTTP 方法 | String | 默认为: get。必须是有效的HTTP方法，小写。
route | 路由匹配 | String | 不能包括空格或者特殊字符，必须符合路由语法，可以包括通配符。
handler | 句柄名称，用于处理符合路由路径的请求。注意输出结果将是基于`Handler`类的一个函数扩展 | String | 不要有空格或者特殊字符
type | 响应类型| String | 默认为：html。可选值：html, json



# 许可证

本工程采用 Apache 2.0 许可证，附于工程根目录下

# 作者

Jonathan Guthrie: [https://github.com/iamjono](https://github.com/iamjono) >> 推特: [@iamjono](https://twitter.com/iamjono)

# 问题和改进请求

如有问题请联系我[Perfect Slack](http://www.perfect.ly) ([www.perfect.ly](http://www.perfect.ly))，或者提出一个具体问题。

欢迎各类改进和提高请求！

非常感谢🙏
Jono
