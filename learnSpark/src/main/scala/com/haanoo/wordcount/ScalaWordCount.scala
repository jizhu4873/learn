package com.haanoo.wordcount

import org.apache.spark.rdd.RDD
import org.apache.spark.{SparkConf, SparkContext}

object ScalaWordCount {

  def main(args: Array[String]): Unit = {
    var conf = new SparkConf().setAppName("scalaWorldCount");
    var sc= new SparkContext(conf);

    val unit:RDD[String] = sc.textFile(args(0))
    var words:RDD[String] = unit.flatMap(_.split(" "))
    var wordToOne:RDD[(String, Int)] = words.map((_,1))
    var wordToNums:RDD[(String,Int)] = wordToOne.reduceByKey(_+_)
    var sorts:RDD[(String,Int)] = wordToNums.sortBy(_._1)
    sorts.saveAsTextFile(args(1))
    sc.stop();
  }

}
