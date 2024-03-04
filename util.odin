package nn

import "core:math"
import "core:math/rand"

CreateWeights :: proc(sizes: []int) -> (weights: []f32) {
	total := 0
	zipped := soa_zip(sizes[0:len(sizes) - 1], sizes[1:])
	for z in zipped {total += z._0 * z._1}
	weights = make([]f32, total)
	for &w in weights {
		w = rand.float32_normal(0, 1)
	}
	return weights
}

CreateBiases :: proc(sizes: []int) -> (biases: []f32) {
	hiddenAndOutput := 0
	// add up hidden plus output layers
	for size in sizes[1:] {
		hiddenAndOutput += size
	}
	biases = make([]f32, hiddenAndOutput)
	// set random numbers
	for &bias in biases {
		bias = rand.float32_normal(0, 1)
	}
	return biases
}


Max :: proc(arr: []f32) -> (max: f32, i: int) {
	index := 0
	for i := 0; i < len(arr); i += 1 {
		if (arr[i] > max) {
			max = arr[i]
			index = i
		}
	}
	return max, index
}

Sigmoid :: proc(x: f32) -> f32 {
	return 1 / (1 + math.exp_f32(-x))
}
