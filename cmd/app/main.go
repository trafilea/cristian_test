package main

import "github.com/trafilea/cristian_test/internal/routes"

func main() {
	routes.InitializeRouter().Run(":80")
}
