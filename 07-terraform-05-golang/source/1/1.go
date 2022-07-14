package main

import (
	"fmt"
)

func FootToMeter(x float64) float64 {
	return x * 0.3048
}

func main() {
	var input float64
	fmt.Print("Enter a number: ")
	fmt.Scanf("%f", &input)
	fmt.Println(FootToMeter(input))
}