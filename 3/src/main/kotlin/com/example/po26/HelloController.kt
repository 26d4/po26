package com.example.po26

import org.springframework.web.bind.annotation.RestController
import org.springframework.web.bind.annotation.RequestParam
import org.springframework.web.bind.annotation.GetMapping

@RestController
class HelloController {
	val aList: List<String> = listOf("foo", "bar", "baz")

	@GetMapping("/hello")
	fun hello(): List<String> {
		return aList;
	}

}
