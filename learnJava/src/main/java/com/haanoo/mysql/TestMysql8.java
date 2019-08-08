package com.haanoo.mysql;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;


public class TestMysql8 {


    //private static final String URL = "jdbc:mysql://10.79.158.22:3306/eye?useSSL=false&serverTimezone=GMT";
    private static final String URL = "jdbc:mysql://node2:3306/hive";//?useSSL=false&serverTimezone=GMT";
    private static final String USER = "root";//"eye_app_t";
    private static final String PASSWORD = "123456";//"eye_app_t*1";

    public static void main(String[] args) throws Exception {
        
        Class.forName("com.mysql.cj.jdbc.Driver");
        
        Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
        //3.操作数据库，实现增删改查
        Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT TBL_NAME FROM TBLS");
        //如果有数据，rs.next()返回true
        while(rs.next()){
            System.out.println(rs.getString("TBL_NAME"));
        }

    }
}
