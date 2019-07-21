package com.haanoo.wordcount

import org.apache.spark.rdd.RDD
import org.apache.spark.{SparkConf, SparkContext}

object WordCountRunByLocalMode {

  def testMapPartitionsWithIndex(sc: SparkContext) = {
    val rdd: RDD[String] = sc.parallelize(List("a","b","c"),2)
    val strings = rdd.mapPartitionsWithIndex((idx: Int, iterator: Iterator[String]) => {
      iterator.map(x => s"index:$idx,val:$x")
    }).collect()
    strings.toStream.print()
  }

  def main(args: Array[String]): Unit = {
    // local[*] 根据cpu的所有内核
    var conf = new SparkConf().setAppName("scalaWorldCount").setMaster("local[4]");
    var sc= new SparkContext(conf);

    testMapPartitionsWithIndex(sc);
    /*val unit:RDD[String] = sc.textFile(args(0))
    var words:RDD[String] = unit.flatMap(_.split(" "))
    var wordToOne:RDD[(String, Int)] = words.map((_,1))
    var wordToNums:RDD[(String,Int)] = wordToOne.reduceByKey(_+_)
    var sorts:RDD[(String,Int)] = wordToNums.sortBy(_._1)
    sorts.saveAsTextFile(args(1))

    var func = (index:Int,it:Iterator[Int]) =>{
      it.map(ele=>s"index:$index , element:$ele")
    }*/
    sc.stop();
  }

}
