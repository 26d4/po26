package com.example.po26

import jakarta.servlet.Filter
import jakarta.servlet.FilterChain
import jakarta.servlet.FilterConfig
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


@Component
@Order(1)
class AuthFilter: Filter {

	val username: String = "user"
	var password: String = ""

	val logger: Logger = LoggerFactory.getLogger(AuthFilter::class.java);

	override fun init(filterConfig: FilterConfig?) {
		logger.info("FILTER INIT")
		password = "password"
	}

	override fun doFilter(req: ServletRequest, res: ServletResponse, chain: FilterChain) {
		val request = req as HttpServletRequest
		val response = res as HttpServletResponse

		logger.info("FILTER ACTIVATED")

		val header: String? = req.getHeader("Authorization")
		if(header != null) {
			logger.info("Auth Header is " + header)
			val headerPair = header.split(" ")

			if(headerPair[0] != "Basic") {
				logger.info("Bad Auth header")
				response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Wrong authentication method")
			}
			else {
				val decoded = String(Base64.getDecoder().decode(headerPair[1]))
				logger.info("Decoded string: " + decoded)

				val userPass = decoded.split(":")

				if(userPass[0] != username || userPass[1] != password) {
					logger.info("Bad Auth header")
					response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Wrong credentials")
				}
			}
		}
		else {
			logger.info("No Auth header")
			response.addHeader("WWW-Authenticate", "Basic")
			response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Unauthenticated")
		}
		chain.doFilter(req, res)
	}

	override fun destroy() {
		logger.info("FILTER DESTROY")
	}
}