package com.haanoo;

import org.junit.Test;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;

public class BoolLogicalCalc {
    @Test
    public void testBoolLogicalCalc(){
        HashMap<String, Object> m = new HashMap<>();
        m.put("str","hello");
        m.put("int",1);
        String str = String.valueOf(m.get("str"));
        String anInt = String.valueOf(m.get("int"));
        List<Boolean> bools = Arrays.asList(false,false);
        boolean flag = false;
        for (Boolean b:bools) {
            flag |= b;
        }
        System.out.println(flag);
    }
}
