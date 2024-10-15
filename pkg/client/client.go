package main

import (
	"fmt"
	"log"
	"net"
	"time"
)

func Ping(proto, addr string, out chan<- string) {
	c, err := net.Dial(proto, addr)
	if err != nil {
		log.Fatal(err)
	}
	defer c.Close()

	msg := []byte("holla!")
	_, err = c.Write(msg)
	if err != nil {
		log.Fatal(err)
	}

	buf := make([]byte, 1024)
	_, err = c.Read(buf)
	if err != nil {
		log.Fatal(err)
	}
	out <- string(buf)
}

func main() {

	start := time.Now()

	ch := make(chan string, 1)
	for i := 0; i < 100; i++ {
		go Ping("tcp", "server.docker:8888", ch)
		time.Sleep(2 * time.Second)
	}

	var m string
	for i := 0; i < 100; i++ {
		m = <-ch
		log.Println(i+1, m)

		fmt.Println("Sleeping for 2 seconds...")
		time.Sleep(2 * time.Second)
	}

	log.Println(time.Since(start))
}
