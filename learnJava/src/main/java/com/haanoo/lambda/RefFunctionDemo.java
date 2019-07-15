package com.haanoo.lambda;

import java.util.Random;
import java.util.function.Supplier;

public class RefFunctionDemo {

    static void printRandomNum(Supplier<?> sup){
        System.out.println(sup.get());
    }

    public static void main(String[] args) {
        Random random = new Random();
        printRandomNum(new Integer(10)::intValue);
        // 静态引用
        printRandomNum(Math::random);
    }


}
