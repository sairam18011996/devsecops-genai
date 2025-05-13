package com.example.carrental;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

public class CarTest {

    @Test
    public void testCarConstructorAndGetters() {
        Car car = new Car("Toyota Corolla", "Sedan", 2020);

        assertEquals("Toyota Corolla", car.getModel());
        assertEquals("Sedan", car.getType());
        assertEquals(2020, car.getYear());
    }
}
