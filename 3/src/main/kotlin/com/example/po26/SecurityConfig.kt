package com.example.po26

import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration
import org.springframework.security.config.annotation.web.builders.HttpSecurity
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity
import org.springframework.security.config.annotation.web.invoke
import org.springframework.security.core.userdetails.User
import org.springframework.security.core.userdetails.UserDetailsService
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder
import org.springframework.security.crypto.password.PasswordEncoder
import org.springframework.security.provisioning.InMemoryUserDetailsManager
import org.springframework.security.web.SecurityFilterChain

@Configuration
@EnableWebSecurity
class SecurityConfig {

	@Bean
	fun userDetailsService(): UserDetailsService {
		val encoder = BCryptPasswordEncoder()
		val user = User.builder()
			.username("user")
			.password(encoder.encode("password"))
			.roles("USER")
			.build()

		return InMemoryUserDetailsManager(user)
	}

	@Bean
	fun filterChain(http: HttpSecurity): SecurityFilterChain {
		http {
			authorizeHttpRequests {
				authorize(anyRequest, authenticated)
			}
			
			httpBasic { }
		}

		return http.build()
	}
	
	@Bean
	fun passwordEncoder(): PasswordEncoder {
		return BCryptPasswordEncoder()
	}
}