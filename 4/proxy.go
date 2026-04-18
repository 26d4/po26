package main

import (
	"net/http"
	"io"
	"gorm.io/gorm"
	"fmt"
)

type GetQuery struct {
	gorm.Model
	URL string
	Response []byte
}

type WeatherProxy struct {
	DB *gorm.DB
	StaleTime int
}

func (wp WeatherProxy) cacheGet(url string) ([]byte, string) {
	response, err := http.Get(url)
	if err != nil { return []byte{}, err.Error() }
	
	responseData, err := io.ReadAll(response.Body)
	if err == nil {
		wp.DB.Create(&GetQuery{URL: url, Response: responseData})
		return responseData, ""
	}
	return nil, err.Error()
}

func (wp WeatherProxy) proxyGet(url string) ([]byte, string) {
	staleFmt := fmt.Sprintf("-%d minutes", wp.StaleTime)

	var count int64
	result := wp.DB.Model(GetQuery{}).Where("created_at > datetime('now', ?) AND url = ?", staleFmt, url).Count(&count)
//	fmt.Println("COUNT: ", count)
	
	if result.Error != nil || count == 0 {
		return wp.cacheGet(url)
	} else {
		var q GetQuery
		result := wp.DB.Where("created_at > datetime('now', ?) AND url = ?", staleFmt, url).Order("created_at DESC").Take(&q)
		
		if result.Error != nil {
			return wp.cacheGet(url)
		}
		
		return q.Response, ""
	}
}
