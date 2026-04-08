package com.example.po26

import jakarta.servlet.ServletException
import jakarta.servlet.ServletRequest
import jakarta.servlet.ServletResponse
import jakarta.servlet.http.HttpServletRequest
import jakarta.servlet.http.HttpServletResponse
import org.springframework.stereotype.Component
import org.springframework.core.annotation.*
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import java.util.Base64
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration

@Configuration
class Auth
{
	@Bean
	fun authSingleton(): AuthSingleton = AuthSingleton
	
	object AuthSingleton {
		
		val username: String = "user"
		val password: String = "password"
		val logger: Logger = LoggerFactory.getLogger(AuthSingleton::class.java);
		
		init {
			logger.info("FILTER INIT")
		}

		fun doFilter(request: HttpServletRequest, response: HttpServletResponse): Boolean {

			logger.info("FILTER ACTIVATED")

			val header: String? = request.getHeader("Authorization")
			if(header != null) {
				logger.info("Auth Header is " + header)
				val headerPair = header.split(" ")

				if(headerPair[0] != "Basic") {
					logger.info("Bad Auth header")
					response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Wrong authentication method")
					return false
				}
				else {
					val decoded = String(Base64.getDecoder().decode(headerPair[1]))
					logger.info("Decoded string: " + decoded)

					val userPass = decoded.split(":")

					if(userPass[0] != username || userPass[1] != password) {
						logger.info("Wrong credentials")
						response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Wrong credentials")
						return false
					}
				}
			}
			else {
				logger.info("No Auth header")
				response.addHeader("WWW-Authenticate", "Basic")
				response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Unauthenticated")
				return false
			}
			return true
		}
	}
}
