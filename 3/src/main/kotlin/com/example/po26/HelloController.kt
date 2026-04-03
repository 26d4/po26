package com.example.po26

import org.springframework.web.bind.annotation.RestController
import org.springframework.web.bind.annotation.RequestParam
import org.springframework.web.bind.annotation.GetMapping

@RestController
class HelloController {

	@GetMapping("/hello")
	fun hello(@RequestParam(value = "name", defaultValue = "World") name: String): String {
		return String.format("Hello %s!", name);
	}

}
