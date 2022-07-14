package main

import "testing"

func TestFootToMeter(t *testing.T) {
	res := FootToMeter(2500)
	if res != 762 {
		t.Errorf("Value was incorrect, got: %f, want: %d.", res, 762)
	}
}
