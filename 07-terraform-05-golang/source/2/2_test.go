package main

import (
	"testing"
)

func TestminListValue(t *testing.T) {
	min := minListValue([]int{48, 96, 86, 68, 57, 82, 63, 70, 37, 34, 83, 27, 19, 97, 5, 17})
	if min != 5 {
		t.Errorf("Sum was incorrect, got: %d, want: %d.", min, 762)
	}
}
