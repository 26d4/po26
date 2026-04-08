package com.example.po26

import org.springframework.web.bind.annotation.RestController
import org.springframework.web.bind.annotation.RequestParam
import org.springframework.web.bind.annotation.GetMapping
import jakarta.servlet.http.HttpServletRequest
import jakarta.servlet.http.HttpServletResponse
import org.springframework.beans.factory.annotation.Autowired

@RestController
class HelloController {
	
	val auth = Auth

	val aList: List<String> = listOf("foo", "bar", "baz")

	@GetMapping("/hello")
	fun hello(request: HttpServletRequest, response: HttpServletResponse): List<String> {
		auth.doFilter(request, response)
		return aList;
	}

}
