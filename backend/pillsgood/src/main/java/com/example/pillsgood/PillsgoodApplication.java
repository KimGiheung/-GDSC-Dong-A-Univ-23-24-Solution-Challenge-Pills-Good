package com.example.pillsgood;

import org.springframework.batch.core.configuration.annotation.EnableBatchProcessing;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

//@EnableBatchProcessing
@SpringBootApplication
public class PillsgoodApplication {

	public static void main(String[] args) {
		SpringApplication.run(PillsgoodApplication.class, args);
	}

}
