package com.ebertp.bom2.example;

import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HelloWorldControler {

    @GetMapping(path = "/hello", produces = MediaType.APPLICATION_JSON_VALUE)
    public Greeting doGet(){
        return new Greeting("Hello World");
    }
    
    
}
