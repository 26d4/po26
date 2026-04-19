package main

import (
	"net/http"
	"io"
	"gorm.io/gorm"
	// "fmt"
	"time"
)

type GetQuery struct {
	gorm.Model
	URL string
	Response []byte
}

type WeatherProxy struct {
	DB *gorm.DB
	StaleTime time.Duration
}

func (wp WeatherProxy) cacheGet(url string) ([]byte, error) {
	response, err := http.Get(url)
	if err != nil { return []byte{}, err }
	
	responseData, err := io.ReadAll(response.Body)
	if err == nil {
		wp.DB.Where(GetQuery{URL: url}).
		Assign(GetQuery{URL: url, Response: responseData}).
		FirstOrCreate(&GetQuery{})

		return responseData, nil
	}
	return nil, err
}

func (wp WeatherProxy) ProxyGet(url string) ([]byte, error) {
	var count int64
	result := wp.DB.Model(GetQuery{}).Where("updated_at > ? AND url = ?", time.Now().Add(-wp.StaleTime), url).Count(&count)
//	fmt.Println("COUNT: ", count)
	
	if result.Error != nil || count == 0 {
		return wp.cacheGet(url)
	} else {
		var q GetQuery
		result := wp.DB.Where("updated_at > ? AND url = ?", time.Now().Add(-wp.StaleTime), url).Order("updated_at DESC").Take(&q)
		
		if result.Error != nil {
			return wp.cacheGet(url)
		}
		
		return q.Response, nil
	}
}
