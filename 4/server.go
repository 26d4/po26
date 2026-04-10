package main

import (
	"net/http"
	"io"

	"github.com/labstack/echo/v5"
	"github.com/labstack/echo/v5/middleware"
)

func main() {
	e := echo.New()
	e.Use(middleware.RequestLogger())

	e.GET("/", func(c *echo.Context) error {
		response, err := http.Get("http://api.open-meteo.com/v1/forecast?latitude=50.0614&longitude=19.9366&timezone=auto&current=temperature_2m,precipitation,weather_code,wind_speed_10m")

		if err != nil {
		    e.Logger.Error(err.Error())
		    return echo.NewHTTPError(http.StatusBadGateway, "Bad API response")
		}

		responseData, err := io.ReadAll(response.Body)
		if err != nil {
		    e.Logger.Error(err.Error())
		    return echo.NewHTTPError(http.StatusBadGateway, "Failed to read API response")
		}

		return c.JSONBlob(http.StatusOK, responseData)
	})

	if err := e.Start(":1323"); err != nil {
		e.Logger.Error("failed to start server", "error", err)
	}
}

