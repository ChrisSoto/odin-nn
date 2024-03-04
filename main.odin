package nn

// # 1 loop through the data
// # 2 forward pass (forward propagation)
// # 3 calculate loss
// # 4 optimize zero grad
// # 5 loss backward (backward propagation)
// # 6 optimizer step (Gradient Descent)

import "core:fmt"
import "core:math"
import "core:math/rand"
import rl "vendor:raylib"

LEARNING_RATE :: 0.1
TRAINING_STEPS :: 100

WIDTH :: 800
HEIGHT :: 600

NeuralNetwork :: struct {
	num_layers: int,
	sizes:      []int,
	weights:    []f32,
	biases:     []f32,
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

CreateNN :: proc(sizes: []int) -> (nn: NeuralNetwork) {
	nn.num_layers = len(sizes)
	nn.sizes = sizes
	nn.biases = CreateBiases(sizes)
	nn.weights = CreateWeights(sizes)
	return nn
}

FeedFowrard :: proc(nn: ^NeuralNetwork, inputs: []f32) {
	layer := 0
	output := make([]f32, nn.sizes[nn.num_layers - 1])
	for w in nn.weights {
		// add up all the weights*input in the first row
	}
}

// FeedFowrard :: proc(nn: ^NeuralNetwork, inputs: []f32) -> []f32 {
// 	row := 0
// 	output := make([]f32, nn.out_len)
// 	for i := 1; i <= len(nn.weights); i += 1 {
// 		col := i % nn.in_len
// 		output[row] += nn.weights[i - 1] * inputs[col]
// 		if i >= nn.in_len && col == 0 {
// 			output[row] += nn.bias[row]
// 			output[row] = Sigmoid(output[row])
// 			row += 1
// 		}
// 	}
// 	return output
// }


main :: proc() {

	test_nn := CreateNN({2, 3, 1})

	FeedFowrard(&test_nn, {0, 0})

	// testing_size := 1000
	// plot_data := make([]PlotData, testing_size)
	// defer delete(plot_data)

	// for i := 0; i < TRAINING_STEPS; i += 1 {
	// 	data := rand.choice(training_data[:])
	// 	BackPropagate(&test_nn, {data.x, data.y}, encoding[data.label])
	// }

	// // does it work?
	// for i := 0; i < testing_size; i += 1 {
	// 	test_x := rand.float32() * 2 - 1
	// 	test_y := rand.float32() * 2 - 1
	// 	output := FeedFowrard(&test_nn, {test_x, test_y})
	// 	max, index := Max(output)
	// 	plot_data[i].x = test_x
	// 	plot_data[i].y = test_y
	// 	plot_data[i].label = decoding[index]
	// 	plot_data[i].prob = max
	// 	// fmt.println("x and y: ", test_x, test_y)
	// 	// fmt.println("result: ", decoding[index])
	// 	// fmt.println("prob: ", max)
	// }

	// PlotPoints(&plot_data)
}
