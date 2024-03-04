package nn


// NeuralNetwork :: struct {
// 	in_len:  int,
// 	out_len: int,
// 	weights: []f32,
// 	bias:    []f32,
// }

// CreateNeuralNetwork :: proc(in_len: int, out_len: int) -> (nn: NeuralNetwork) {
// 	nn = {
// 		in_len  = in_len,
// 		out_len = out_len,
// 		bias    = make([]f32, out_len),
// 		weights = make([]f32, in_len * out_len),
// 	}

// 	for i in 0 ..< len(nn.weights) {
// 		nn.weights[i] = rand.float32()
// 	}

// 	return nn
// }

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

// Sigmoid :: proc(x: f32) -> f32 {
// 	return 1 / (1 + math.exp_f32(-x))
// }

// Relu :: proc(x: f32) -> f32 {
// 	return max(0, x)
// }

// Softsign :: proc(x: f32) -> f32 {
// 	return x / (1 + math.abs(x))
// }

// BackPropagate :: proc(nn: ^NeuralNetwork, inputs: []f32, target: []f32) {
// 	assert(nn.in_len == len(inputs), "inputs length does't match network")
// 	assert(nn.out_len == len(target), "target length doesn't match network")
// 	output := FeedFowrard(nn, inputs)
// 	errors := make([]f32, nn.out_len)
// 	defer delete(errors)
// 	row := 0
// 	for i := 1; i <= len(nn.weights); i += 1 {
// 		col := i % nn.in_len
// 		errors[row] = target[row] - output[row]
// 		nn.weights[i - 1] +=
// 			LEARNING_RATE * errors[row] * output[row] * (1 - output[row]) * inputs[col]
// 		if i >= nn.in_len - 1 && col == 0 {
// 			nn.bias[row] += LEARNING_RATE * errors[row]
// 			row += 1
// 		}
// 	}
// }
