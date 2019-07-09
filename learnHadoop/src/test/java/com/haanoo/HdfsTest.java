package com.haanoo;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.FileSystem;
import org.apache.hadoop.fs.Path;
import org.junit.Test;

import java.io.File;
import java.io.IOException;
import java.net.URI;

public class HdfsTest {
    @Test
    public void testUpload() throws Exception {
        Configuration conf =new Configuration();
        conf.set("dfs.replication","2");
        conf.set("dfs.blocksize","64m");
        FileSystem fs = FileSystem.get(URI.create("hdfs://eeye-test:9000/"), conf,"root");
        fs.copyFromLocalFile(new Path("C:\\Users\\Administrator\\Desktop\\1.md"),new Path("/"));
        fs.close();
    }

    @Test
    public void testMove() throws Exception {
        Configuration conf =new Configuration();
        FileSystem fs = FileSystem.get(URI.create("hdfs://eeye-test:9000/"), conf,"root");
        fs.copyFromLocalFile(new Path("C:\\Users\\Administrator\\Desktop\\1.md"),new Path("/"));
        fs.rename(new Path("/1.md"),new Path("/diaryOfEeye.md"));

        fs.close();
    }
}
