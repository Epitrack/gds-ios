package com.epitrack.guardioes.request;

import android.os.AsyncTask;

import com.epitrack.guardioes.utility.Logger;
import com.epitrack.guardioes.utility.MessageText;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.net.MalformedURLException;
import java.net.URL;

import java.net.HttpURLConnection;

/**
 * @author Miquéias Lopes on 09/09/15.
 */
public class SimpleRequester extends AsyncTask<SimpleRequester, Void, String> {

    private static final String TAG = Requester.class.getSimpleName();
    private String url;
    private JSONObject jsonObject;

    public SimpleRequester() {

    }

    public void setUrl(String url) {
        this.url = url;
    }

    public void setJsonObject(JSONObject jsonObject) {
        this.jsonObject = jsonObject;
    }

    @Override
    protected String doInBackground(SimpleRequester... params) {
        try {
            return SendPostRequest(this.url, Method.POST, this.jsonObject);
        } catch (Exception e) {
            return e.getMessage();
        }
    }


    public static String SendPostRequest(String posturl, JSONObject jsonObjSend) throws JSONException, IOException, Exception {
        return SendPostRequest(posturl, Method.POST, jsonObjSend);
    }

    /*public static String SendGetRequest(String posturl) throws JSONException, IOException {
        HttpGet httpget = new HttpGet(posturl);
        HttpClient Client = new DefaultHttpClient();

        ResponseHandler<String> responseHandler = new BasicResponseHandler();
        String response = Client.execute(httpget, responseHandler);

        return response;
    }*/

    private static String SendPostRequest(String posturl, Method method, JSONObject jsonObjSend) throws JSONException, IOException, SimpleRequesterException {

        URL url;
        try {
            url = new URL(posturl);
        } catch (MalformedURLException e) {
            throw new IllegalArgumentException("invalid url: " + posturl);
        }

        String body = "";
        if (jsonObjSend != null) {
            body = jsonObjSend.toString();
        }

        Logger.logDebug(TAG, body + "' to " + url);
        byte[] bytes = body.getBytes();
        HttpURLConnection conn = null;
        conn = (HttpURLConnection) url.openConnection();
        conn.setRequestProperty("Content-Type", "application/json");
        conn.setReadTimeout(10000);
        conn.setConnectTimeout(15000);
        conn.setRequestMethod(String.valueOf(method.POST));
        conn.setDoInput(true);
        conn.setDoOutput(true);

        // post the request
        OutputStream out = conn.getOutputStream();
        out.write(bytes);
        out.close();
        // handle the response
        int status = conn.getResponseCode();
        if (status != 200) {
            return MessageText.ERROR_SERVER.toString();
        }

        String convertStreamToString = "";
        if (conn != null) {
            convertStreamToString = convertStreamToString(conn.getInputStream(), /*HTTP.UTF_8*/"UTF-8");
            conn.disconnect();
        }

        return convertStreamToString;
    }

    private static String convertStreamToString(InputStream is, String enc) throws UnsupportedEncodingException {
        BufferedReader reader = new BufferedReader(new InputStreamReader(is, enc));
        StringBuilder sb = new StringBuilder();
        String line = null;

        try {
            while ((line = reader.readLine()) != null) {
                sb.append(line + "\n");
            }
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            try {
                is.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }

        return sb.toString();
    }
}
