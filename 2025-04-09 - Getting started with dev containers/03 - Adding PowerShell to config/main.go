package main

import (
	"fmt"
	"net/http"
)

func helloWorld(w http.ResponseWriter, req *http.Request) {
	fmt.Println("/helloWorld called")
	fmt.Fprintf(w, "Hello World\n")
}

func main() {
	http.HandleFunc("/helloWorld", helloWorld)
	fmt.Println("Server launching on port 8080...")
	http.ListenAndServe(":8080", nil)
}
