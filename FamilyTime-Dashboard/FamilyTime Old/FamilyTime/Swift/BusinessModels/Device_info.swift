/* 
Copyright (c) 2019 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct Device_info_Model  {
	let device_id : Int
	let signal_strength : String
	let battery_remaining : String
	let wifi_name : String
	let accuracy : String
	let latitude : String
	let longitude : String
	let address : String
	let child_id : Int
	let device_manufacturer : String
	let device_name : String
	let device_model : String
	let device_os : String
	let device_language : String
	let device_timezone : String
	let device_imei : String
	let app_version : String
	let app_build : String
	let date_created : String
	let date_modified : String
	let deleted : Int
	let created_at : String
	let updated_at : String

	

	init() {
        
		device_id           = -1
		signal_strength     = ""
		battery_remaining   = ""
		wifi_name           = ""
		accuracy            = ""
		latitude            = ""
		longitude           = ""
		address             = ""
		child_id            = 0
		device_manufacturer = ""
		device_name         = ""
		device_model        = ""
		device_os           = ""
		device_language     = ""
		device_timezone     = ""
		device_imei         = ""
		app_version         = ""
		app_build           = ""
		date_created        = ""
		date_modified       = ""
		deleted             = -1
		created_at          = ""
		updated_at          = ""
        
	}

}
