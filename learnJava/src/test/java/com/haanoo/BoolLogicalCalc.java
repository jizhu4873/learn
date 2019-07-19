package com.haanoo;

import org.junit.Test;

import java.util.Arrays;
import java.util.List;

public class BoolLogicalCalc {
    @Test
    public void testBoolLogicalCalc(){
        List<Boolean> bools = Arrays.asList(false,false);
        boolean flag = false;
        for (Boolean b:bools) {
            flag |= b;
        }
        System.out.println(flag);
    }
}
