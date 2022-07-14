package main

import "fmt"

func minListValue(list []int) int {
	var min = list[0]

	for _, el := range list[1:] {
		if el < min {
			min = el
		}
	}

	return min
}


func main() {
	var x = []int{48, 96, 86, 68, 57, 82, 63, 70, 37, 34, 83, 27, 19, 97, 9, 17}

	var min = minListValue(x)

	fmt.Printf("\n min=%v \n",min)
}
