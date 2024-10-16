package main

import (
	"fmt"
	log "github.com/sirupsen/logrus"
	"net"
	"time"
)

func Ping(proto, addr string, out chan<- string) {
	log.SetFormatter(&log.JSONFormatter{})
	log.SetLevel(log.DebugLevel)
	log.Debug("1")
	c, err := net.Dial(proto, addr)
	if err != nil {
		log.Fatal(err)
	}
	log.Info("2")
	defer c.Close()

	msg := []byte("holla!")
	log.Debug("3")
	_, err = c.Write(msg)
	log.Debug("4")
	if err != nil {
		log.Fatal(err)
	}
	log.Debug("5")

	buf := make([]byte, 1024)
	_, err = c.Read(buf)
	if err != nil {
		log.Fatal(err)
	}
	log.Debug("6")
	out <- string(buf)
	log.Debug("7")
}

func main() {

	start := time.Now()

	ch := make(chan string, 1)
	for i := 0; i < 100; i++ {
		log.Debug("8")
		go Ping("tcp", "envoy:10000", ch)
		log.Debug("9")
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
