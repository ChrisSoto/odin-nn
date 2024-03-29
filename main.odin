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

FeedFowrard :: proc(nn: NeuralNetwork, inputs: []f32) -> (output: []f32) {
	weight_index := 0
	bias_index := 0
	curr_layer := inputs
	input_size := nn.sizes[0]
	for layer := 1; layer < nn.num_layers; layer += 1 {
		num_neurons := nn.sizes[layer]
		next_layer := make([]f32, num_neurons)
		for j := 0; j < num_neurons; j += 1 {
			sum: f32 = 0
			for i := 0; i < input_size; i += 1 {
				sum += curr_layer[i] * nn.weights[weight_index]
				weight_index += 1
			}
			// add bias
			sum += nn.biases[bias_index]
			// last layer doesn't use activation
			next_layer[j] = layer != nn.num_layers - 1 ? Sigmoid(sum) : sum
			bias_index += 1
		}
		curr_layer = next_layer
		input_size = num_neurons
		delete(next_layer)
	}
	output = curr_layer
	return output
}

BackPropagate :: proc(nn: ^NeuralNetwork, inputs: []f32, target: []f32) {
	outputs := FeedFowrard(nn^, inputs)
	activated_outputs := Activate(outputs) // will add activation type later
	delta := CalculateDelta(outputs, activated_outputs, target) // add activation type later

	// need to calculate the partial derivative for each layer of neurons
	// apply the partial derivative to the weights activations and biases
}

CalculateDelta :: proc(outputs: []f32, activated: []f32, target: []f32) -> (delta: []f32) {
	delta = make([]f32, len(outputs)) // same size as outputs
	for o := 0; o < len(outputs); o += 1 {
		delta[o] = 2 * (activated[o] - target[o]) * SigmoidDerivative(outputs[o])
	}
	return delta
}

Activate :: proc(outputs: []f32) -> (activated: []f32) {
	activated = make([]f32, len(outputs))
	for i := 0; i < len(outputs); i += 1 {
		activated[i] = Sigmoid(outputs[i])
	}
	return activated
}

main :: proc() {

	test_nn := CreateNN({1, 1, 1})
	// out := FeedFowrard(test_nn, {9, 9})
	// fmt.println(out)

	data := rand.choice(training_data[:])
	BackPropagate(&test_nn, {data.x, data.y}, encoding[data.label])

	// testing_size := 100
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
