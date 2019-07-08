package com.haanoo.wordcount;

import org.apache.spark.SparkConf;
import org.apache.spark.api.java.JavaPairRDD;
import org.apache.spark.api.java.JavaRDD;
import org.apache.spark.api.java.JavaSparkContext;
import org.apache.spark.api.java.function.FlatMapFunction;
import org.apache.spark.api.java.function.Function2;
import org.apache.spark.api.java.function.PairFunction;
import scala.Tuple2;

import java.util.Arrays;
import java.util.Iterator;

public class LambdaWordCount {
    public static void main(String[] args) {
        SparkConf conf = new SparkConf().setAppName("JavaWordCount");
        JavaSparkContext jsc = new JavaSparkContext(conf);
        JavaRDD<String> rdd = jsc.textFile(args[0]);
        JavaRDD<String> wordsInLine = rdd.flatMap(line -> Arrays.asList(line.split(" ")).iterator());
        JavaPairRDD<String, Integer> wordAndOne = wordsInLine.mapToPair(word -> new Tuple2<>(word, 1));
        JavaPairRDD<String, Integer> wordAndCounts = wordAndOne.reduceByKey((one1, one2) -> one1 + one2);
        //排序
        JavaPairRDD<Integer, String> countsAndWord = wordAndCounts.mapToPair(tuple2 -> tuple2.swap());
        JavaPairRDD<Integer, String> sortedCountsAndWord = countsAndWord.sortByKey(false);
        JavaPairRDD<String, Integer> sortedWordAndCounts = sortedCountsAndWord.mapToPair(tuple2 -> tuple2.swap());
        sortedWordAndCounts.saveAsTextFile(args[1]);
        jsc.stop();

    }
}
