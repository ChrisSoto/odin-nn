package nn

import "core:fmt"
import "core:math"
import "core:math/rand"
import rl "vendor:raylib"

LEARNING_RATE :: 0.1
TRAINING_STEPS :: 100

WIDTH :: 800
HEIGHT :: 600

NeuralNetwork :: struct {
	in_len:  int,
	out_len: int,
	weights: []f32,
	bias:    []f32,
}

PlotData :: struct {
	x:     f32,
	y:     f32,
	label: string,
	prob:  f32,
}

training_data: [4]PlotData =  {
	{x = -0.5, y = -0.5, label = "blue"},
	{x = 0.5, y = -0.5, label = "red"},
	{x = -0.5, y = 0.5, label = "green"},
	{x = 0.5, y = 0.5, label = "purple"},
}

encoding := map[string][]f32 {
	"blue"   = {1, 0, 0, 0},
	"red"    = {0, 1, 0, 0},
	"green"  = {0, 0, 1, 0},
	"purple" = {0, 0, 0, 1},
}

decoding := map[int]string {
	0 = "blue",
	1 = "red",
	2 = "green",
	3 = "purple",
}

Max :: proc(arr: ^[]f32) -> (max: f32, i: int) {
	index := 0
	for i := 0; i < len(arr); i += 1 {
		if (arr[i] > max) {
			max = arr[i]
			index = i
		}
	}
	return max, index
}

NewNeuralNetwork :: proc(in_len: int, out_len: int) -> (nn: NeuralNetwork) {
	nn = {
		in_len  = in_len,
		out_len = out_len,
		bias    = make([]f32, out_len),
		weights = make([]f32, in_len * out_len),
	}

	for i in 0 ..< len(nn.weights) {
		nn.weights[i] = rand.float32()
	}

	return nn
}

FeedFowrard :: proc(nn: ^NeuralNetwork, inputs: []f32) -> []f32 {
	row := 0
	output := make([]f32, nn.out_len)
	defer delete(output)
	for i := 1; i <= len(nn.weights); i += 1 {
		col := i % nn.in_len
		output[row] += nn.weights[i - 1] * inputs[col]
		if i >= nn.in_len && col == 0 {
			output[row] += nn.bias[row]
			output[row] = Sigmoid(output[row])
			row += 1
		}
	}
	return output
}

Sigmoid :: proc(x: f32) -> f32 {
	return 1 / (1 + math.exp_f32(-x))
}

Relu :: proc(x: f32) -> f32 {
	return max(0, x)
}

Softsign :: proc(x: f32) -> f32 {
	return x / (1 + math.abs(x))
}

BackPropagate :: proc(nn: ^NeuralNetwork, inputs: []f32, target: []f32) {
	assert(nn.in_len == len(inputs), "inputs length does't match network")
	assert(nn.out_len == len(target), "target length doesn't match network")
	output := FeedFowrard(nn, inputs)
	errors := make([]f32, nn.out_len)
	defer delete(errors)
	row := 0
	for i := 1; i <= len(nn.weights); i += 1 {
		col := i % nn.in_len
		errors[row] = target[row] - output[row]
		nn.weights[i - 1] +=
			LEARNING_RATE * errors[row] * output[row] * (1 - output[row]) * inputs[col]
		if i >= nn.in_len - 1 && col == 0 {
			nn.bias[row] += LEARNING_RATE * errors[row]
			row += 1
		}
	}
}

main :: proc() {
	test_nn := NewNeuralNetwork(2, 4)

	testing_size := 1000
	plot_data := make([]PlotData, testing_size)
	defer delete(plot_data)

	for i := 0; i < TRAINING_STEPS; i += 1 {
		data := rand.choice(training_data[:])
		BackPropagate(&test_nn, {data.x, data.y}, encoding[data.label])
	}

	// does it work?
	for i := 0; i < testing_size; i += 1 {
		test_x := rand.float32() * 2 - 1
		test_y := rand.float32() * 2 - 1
		output := FeedFowrard(&test_nn, {test_x, test_y})
		max, index := Max(&output)
		plot_data[i].x = test_x
		plot_data[i].y = test_y
		plot_data[i].label = decoding[index]
		plot_data[i].prob = max
		// fmt.println("x and y: ", test_x, test_y)
		// fmt.println("result: ", decoding[index])
		// fmt.println("prob: ", max)
	}

	PlotPoints(&plot_data)
}
