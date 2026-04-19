package main

import (
	"net/http"
	"time"
	"fmt"

	"github.com/labstack/echo/v5"
	"github.com/labstack/echo/v5/middleware"
	"github.com/libtnb/sqlite"
	"gorm.io/gorm"
)

func main() {
	e := echo.New()
	
	db, err := gorm.Open(sqlite.Open("db.sqlite"), &gorm.Config{})
	if err != nil {
		e.Logger.Error(err.Error())
	}
	
	db.AutoMigrate(GetQuery{})
	
	e.Use(middleware.RequestLogger())

	e.GET("/", func(c *echo.Context) error {
		wp := WeatherProxy{db, 5*time.Minute}

		var lat, long float64

		err := echo.QueryParamsBinder(c).MustFloat64("latitude", &lat).MustFloat64("longitude", &long).BindError()
		
		if err != nil {
			return echo.NewHTTPError(http.StatusBadRequest, "bad request")
		}
		
		response, err := wp.ProxyGet(fmt.Sprintf("http://api.open-meteo.com/v1/forecast?latitude=%f&longitude=%f&timezone=auto&current=temperature_2m,precipitation,weather_code,wind_speed_10m", lat, long))

		if err != nil {
		    e.Logger.Error("failed to get response", "error", err)
		    return echo.NewHTTPError(http.StatusBadGateway, "Failed to get response")
		}

		return c.JSONBlob(http.StatusOK, response)
	})

	if err := e.Start(":1323"); err != nil {
		e.Logger.Error("failed to start server", "error", err)
	}
}

