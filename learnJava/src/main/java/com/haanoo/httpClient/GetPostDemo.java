package com.haanoo.httpClient;

import org.apache.http.HttpEntity;
import org.apache.http.NameValuePair;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.client.utils.URIBuilder;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.impl.conn.PoolingHttpClientConnectionManager;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.util.EntityUtils;

import java.io.IOException;
import java.net.URI;
import java.nio.charset.Charset;
import java.util.ArrayList;

public class GetPostDemo {
    public static void main(String[] args) {
        //testGet();
        postWithParam();
    }

    public static void testGet() {
        CloseableHttpClient client = HttpClients.createDefault();
        try {
            HttpGet get = new HttpGet(URI.create("https://www.baidu.com"));
            CloseableHttpResponse response = client.execute(get);
            if(response.getStatusLine().getStatusCode() == 200){
                HttpEntity entity = response.getEntity();
                String content = EntityUtils.toString(entity, Charset.forName("utf-8"));
                System.out.println(content);
            }
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            try {
                client.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    public static void getFromPool() {
        PoolingHttpClientConnectionManager cm = new PoolingHttpClientConnectionManager();
        cm.setDefaultMaxPerRoute(10);
        cm.setMaxTotal(100);
        CloseableHttpClient client  = HttpClients.custom().setConnectionManager(cm).build();
        try {
            HttpGet get = new HttpGet(URI.create("https://www.baidu.com"));
            CloseableHttpResponse response = client.execute(get);
            if(response.getStatusLine().getStatusCode() == 200){
                HttpEntity entity = response.getEntity();
                String content = EntityUtils.toString(entity, Charset.forName("utf-8"));
                System.out.println(content);
            }
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            try {
                client.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    // 发送带参数的get请求
    // https://www.baidu.com/s?wd=HD
    public static void getWithParam(){
        CloseableHttpClient client = HttpClients.createDefault();
        try {
            URIBuilder builder = new URIBuilder("https://www.baidu.com/s");
            builder.addParameter("wd","HD");
            HttpGet get = new HttpGet(builder.build());
            CloseableHttpResponse response = client.execute(get);
            if(response.getStatusLine().getStatusCode() == 200){
                HttpEntity entity = response.getEntity();
                String content = EntityUtils.toString(entity, Charset.forName("utf-8"));
                System.out.println(content);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                client.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    // 发送带参数的post请求
    // https://www.baidu.com/s?wd=HD
    public static void postWithParam(){
        CloseableHttpClient client = HttpClients.createDefault();
        try {
            URIBuilder builder = new URIBuilder("https://www.baidu.com/s");
            HttpPost post = new HttpPost(builder.build());
            ArrayList<NameValuePair> params = new ArrayList<>();
            params.add(new BasicNameValuePair("wd","HD"));
            UrlEncodedFormEntity postEntity = new UrlEncodedFormEntity(params, "utf-8");
            post.setEntity(postEntity);
            CloseableHttpResponse response = client.execute(post);
            if(response.getStatusLine().getStatusCode() == 200){
                HttpEntity entity = response.getEntity();
                String content = EntityUtils.toString(entity, Charset.forName("utf-8"));
                System.out.println(content);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                client.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }
}
