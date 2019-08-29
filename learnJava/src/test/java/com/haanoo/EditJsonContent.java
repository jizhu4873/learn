package com.haanoo;

import ch.qos.logback.core.util.FileUtil;
import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.alibaba.fastjson.support.hsf.HSFJSONUtils;
import lombok.Data;
import org.apache.commons.io.IOUtils;
import org.junit.Test;

import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

public class EditJsonContent {
    String origin = "[\n" +
            "      {\n" +
            "        \"idx\": 0,\n" +
            "        \"val\": \"吴峰\",\n" +
            "        \"left\": 89,\n" +
            "        \"top\": 83\n" +
            "      },\n" +
            "      {\n" +
            "        \"idx\": 1,\n" +
            "        \"val\": 10545451511515,\n" +
            "        \"left\": 217,\n" +
            "        \"top\": 86\n" +
            "      },\n" +
            "      {\n" +
            "        \"idx\": 2,\n" +
            "        \"val\": \"BUDEQIANZHUAN不得签转/BIANGENG\",\n" +
            "        \"left\": 470,\n" +
            "        \"top\": 84\n" +
            "      },\n" +
            "      {\n" +
            "        \"idx\": 3,\n" +
            "        \"val\": \"广州/CAN\",\n" +
            "        \"left\": 77,\n" +
            "        \"top\": 145\n" +
            "      },\n" +
            "      {\n" +
            "        \"idx\": 4,\n" +
            "        \"val\": \"CZ\",\n" +
            "        \"left\": 203,\n" +
            "        \"top\": 143\n" +
            "      },\n" +
            "      {\n" +
            "        \"idx\": 5,\n" +
            "        \"val\": 8647,\n" +
            "        \"left\": 243,\n" +
            "        \"top\": 143\n" +
            "      },\n" +
            "      {\n" +
            "        \"idx\": 6,\n" +
            "        \"val\": \"U\",\n" +
            "        \"left\": 307,\n" +
            "        \"top\": 173\n" +
            "      },\n" +
            "      {\n" +
            "        \"idx\": 7,\n" +
            "        \"val\": \"2019-06-07\",\n" +
            "        \"left\": 330,\n" +
            "        \"top\": 143\n" +
            "      },\n" +
            "      {\n" +
            "        \"idx\": 8,\n" +
            "        \"val\": \"06:20\",\n" +
            "        \"left\": 401,\n" +
            "        \"top\": 142\n" +
            "      },\n" +
            "      {\n" +
            "        \"idx\": 9,\n" +
            "        \"val\": \"YID00R2\",\n" +
            "        \"left\": 507,\n" +
            "        \"top\": 139\n" +
            "      },\n" +
            "      {\n" +
            "        \"idx\": 10,\n" +
            "        \"val\": \"20K\",\n" +
            "        \"left\": 729,\n" +
            "        \"top\": 137\n" +
            "      },\n" +
            "      {\n" +
            "        \"idx\": 11,\n" +
            "        \"val\": \"青岛/TAO\",\n" +
            "        \"left\": 78,\n" +
            "        \"top\": 175\n" +
            "      },\n" +
            "      {\n" +
            "        \"idx\": 12,\n" +
            "        \"val\": \"CZ\",\n" +
            "        \"left\": 201,\n" +
            "        \"top\": 173\n" +
            "      },\n" +
            "      {\n" +
            "        \"idx\": 13,\n" +
            "        \"val\": \"CZOPEN\",\n" +
            "        \"left\": 241,\n" +
            "        \"top\": 173\n" +
            "      },\n" +
            "      {\n" +
            "        \"idx\": 14,\n" +
            "        \"val\": \"X\",\n" +
            "        \"left\": 305,\n" +
            "        \"top\": 143\n" +
            "      },\n" +
            "      {\n" +
            "        \"idx\": 15,\n" +
            "        \"val\": \"YID00R2\",\n" +
            "        \"left\": 506,\n" +
            "        \"top\": 168\n" +
            "      },\n" +
            "      {\n" +
            "        \"idx\": 16,\n" +
            "        \"val\": \"20K\",\n" +
            "        \"left\": 731,\n" +
            "        \"top\": 166\n" +
            "      },\n" +
            "      {\n" +
            "        \"idx\": 17,\n" +
            "        \"val\": \"广州/CAN\",\n" +
            "        \"left\": 78,\n" +
            "        \"top\": 204\n" +
            "      },\n" +
            "      {\n" +
            "        \"idx\": 18,\n" +
            "        \"val\": \"VOID\",\n" +
            "        \"left\": 243,\n" +
            "        \"top\": 203\n" +
            "      },\n" +
            "      {\n" +
            "        \"idx\": 19,\n" +
            "        \"val\": \"VOID\",\n" +
            "        \"left\": 77,\n" +
            "        \"top\": 235\n" +
            "      },\n" +
            "      {\n" +
            "        \"idx\": 20,\n" +
            "        \"val\": \"VOID\",\n" +
            "        \"left\": 244,\n" +
            "        \"top\": 233\n" +
            "      },\n" +
            "      {\n" +
            "        \"idx\": 21,\n" +
            "        \"val\": \"VOID\",\n" +
            "        \"left\": 80,\n" +
            "        \"top\": 265\n" +
            "      },\n" +
            "      {\n" +
            "        \"idx\": 22,\n" +
            "        \"val\": \"CNY 0.0\",\n" +
            "        \"left\": 196,\n" +
            "        \"top\": 270\n" +
            "      },\n" +
            "      {\n" +
            "        \"idx\": 23,\n" +
            "        \"val\": \"CNY 100.0\",\n" +
            "        \"left\": 296,\n" +
            "        \"top\": 269\n" +
            "      },\n" +
            "      {\n" +
            "        \"idx\": 24,\n" +
            "        \"val\": \"CNY 260.0\",\n" +
            "        \"left\": 397,\n" +
            "        \"top\": 268\n" +
            "      },\n" +
            "      {\n" +
            "        \"idx\": 25,\n" +
            "        \"val\": \"CNY\",\n" +
            "        \"left\": 503,\n" +
            "        \"top\": 266\n" +
            "      },\n" +
            "      {\n" +
            "        \"idx\": 26,\n" +
            "        \"val\": \"CNY 360.0\",\n" +
            "        \"left\": 606,\n" +
            "        \"top\": 265\n" +
            "      },\n" +
            "      {\n" +
            "        \"idx\": 27,\n" +
            "        \"val\": \"784-2437635414\",\n" +
            "        \"left\": 79,\n" +
            "        \"top\": 306\n" +
            "      },\n" +
            "      {\n" +
            "        \"idx\": 28,\n" +
            "        \"val\": \"0807\",\n" +
            "        \"left\": 256,\n" +
            "        \"top\": 303\n" +
            "      },\n" +
            "      {\n" +
            "        \"idx\": 29,\n" +
            "        \"val\": \"08678059\",\n" +
            "        \"left\": 88,\n" +
            "        \"top\": 332\n" +
            "      },\n" +
            "      {\n" +
            "        \"idx\": 30,\n" +
            "        \"val\": \"青岛机场\",\n" +
            "        \"left\": 294,\n" +
            "        \"top\": 329\n" +
            "      },\n" +
            "      {\n" +
            "        \"idx\": 31,\n" +
            "        \"val\": \"2013-01-21\",\n" +
            "        \"left\": 655,\n" +
            "        \"top\": 323\n" +
            "      }\n" +
            "    ]";
    @Test
    public void editContent() throws Exception {
        List<PositionObj> ps = JSON.parseArray(origin, PositionObj.class);
        List<PositionObj> newList = ps.stream().map(p -> {
            PositionObj newP = new PositionObj();
            newP.setIdx(p.getIdx());
            newP.setTop(p.getTop() / 3.78);
            newP.setLeft(p.getLeft() / 3.78);
            newP.setVal(p.getVal());
            return newP;
        }).collect(Collectors.toList());
        String s = JSON.toJSONString(newList, true);
        IOUtils.write(s,new FileOutputStream("C://1.txt"));
    }


}

@Data
class PositionObj{
    private String idx;
    private Double top;
    private Double left;
    private String val;
}
