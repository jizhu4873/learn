package com.haanoo;

import java.util.Random;
import java.util.function.Supplier;

public class RefFunctionDemo {

    static void printRandomNum(Supplier<Integer> sup){
        System.out.println(sup.get());
    }

    public static void main(String[] args) {
        Random random = new Random();
        printRandomNum(new Integer(10)::intValue);
    }
}
