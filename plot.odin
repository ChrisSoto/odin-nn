package nn

import rl "vendor:raylib"

ToScreenSpace :: proc(position: [2]f32) -> [2]i32 {
	return {i32(((position.x + 1) * WIDTH) / 2), i32(HEIGHT - (((position.y + 1) * HEIGHT) / 2))}
}


PlotPoints :: proc(plot_data: ^[]PlotData) {
	rl.SetTargetFPS(60)
	rl.InitWindow(WIDTH, HEIGHT, "Neural Network Test")

	circle_blu: rl.Color = {48, 128, 240, 255}
	circle_gre: rl.Color = {59, 245, 71, 255}
	circle_red: rl.Color = {245, 57, 46, 255}
	circle_pur: rl.Color = {151, 84, 245, 255}
	bg_blu: rl.Color = {146, 181, 240, 255}
	bg_gre: rl.Color = {181, 245, 190, 255}
	bg_red: rl.Color = {245, 136, 133, 255}
	bg_pur: rl.Color = {215, 171, 245, 255}

	circle_color: rl.Color
	screen_x: i32
	screen_y: i32

	for {
		rl.BeginDrawing()
		rl.ClearBackground(rl.BLUE)

		rl.DrawRectangle(0, 0, WIDTH / 2, HEIGHT / 2, bg_gre)
		rl.DrawRectangle(WIDTH / 2, 0, WIDTH / 2, HEIGHT / 2, bg_pur)
		rl.DrawRectangle(0, HEIGHT / 2, WIDTH / 2, HEIGHT / 2, bg_blu)
		rl.DrawRectangle(WIDTH / 2, HEIGHT / 2, WIDTH / 2, HEIGHT / 2, bg_red)
		rl.DrawLine(0, HEIGHT / 2, WIDTH, HEIGHT / 2, rl.BLACK)
		rl.DrawLine(WIDTH / 2, 0, WIDTH / 2, HEIGHT, rl.BLACK)

		for i := 0; i < len(plot_data); i += 1 {
			if plot_data[i].label == "red" {
				circle_color = circle_red
			} else if plot_data[i].label == "green" {
				circle_color = circle_gre
			} else if plot_data[i].label == "purple" {
				circle_color = circle_pur
			} else if plot_data[i].label == "blue" {
				circle_color = circle_blu
			}

			circle_color.a = u8(plot_data[i].prob * 255)

			screen_space := ToScreenSpace({plot_data[i].x, plot_data[i].y})
			rl.DrawCircle(screen_space.x, screen_space.y, 5, circle_color)
		}

		rl.EndDrawing()

		if (rl.WindowShouldClose()) {
			rl.CloseWindow()
		}
	}
}
