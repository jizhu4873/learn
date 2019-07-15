package com.haanoo.lambda;

import lombok.AllArgsConstructor;
import lombok.Data;

import java.util.Random;
import java.util.function.Function;
import java.util.function.Supplier;

public class RefConstructorDemo {

    static void printPerson(String name, Function<String,Person> func){
        System.out.println(func.apply(name));
    }

    public static void main(String[] args) {
        printPerson("张飞",name->new Person(name));
        // 构造引用
        printPerson("张飞",Person::new);
    }

    @Data
    @AllArgsConstructor
    static class Person{
        String name;
        @Override
        public String toString(){
            return name;
        }
    }
}
