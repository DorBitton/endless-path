package main

import "fmt"

var service = "auth-service" // Package level variable

func main() {
	var request int
	var isDegraded bool
	var errorRate float64

	target := "10.0.0.1:8080"

	fmt.Printf("[%s] %d %t %.1f %s\n",
		service, request, isDegraded, errorRate, target)
}
