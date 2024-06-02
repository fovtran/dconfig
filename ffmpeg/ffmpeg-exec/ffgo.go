package main

import (
    "bytes"
    "fmt"
    "log"
    "os/exec"
    // "strings"
)

func main() {
    cmd := exec.Command("/usr/bin/ffmpeg", "-h")

    // cmd.Stdin = strings.NewReader("and old falcon")

    var out bytes.Buffer
    cmd.Stdout = &out

    err := cmd.Run()

    if err != nil { log.Fatal(err) }

    fmt.Printf("Out: %q\n", out.String())
}