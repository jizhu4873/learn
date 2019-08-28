package com.haanoo;

import com.haanoo.entity.AbstractData;
import org.junit.Test;

public class AccessAbstractMethod {

    @Test
    public void accessAbstract(){
        String greet = AbstractData.greet("hello ");
        System.out.println(greet);
    }
}
