package com.epitrack.guardioes.request;

import android.os.AsyncTask;

import com.epitrack.guardioes.model.SingleUser;
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
import java.net.URLConnection;

/**
 * @author Miquéias Lopes on 09/09/15.
 */
public class SimpleRequester extends AsyncTask<SimpleRequester, Void, String> {

    private static final String TAG = Requester.class.getSimpleName();
    private String url;
    private JSONObject jsonObject;
    private Method method;
    private boolean otherAPI = false;

    public SimpleRequester() {

    }

    public void setUrl(String url) {
        this.url = url;
    }

    public void setJsonObject(JSONObject jsonObject) {
        this.jsonObject = jsonObject;
    }

    public void setMethod(Method method) {
        this.method = method;
    }

    public void setOtherAPI(boolean otherAPI) {
        this.otherAPI = otherAPI;
    }

    @Override
    protected String doInBackground(SimpleRequester... params) {
        try {
            return SendPostRequest(this.url, this.method, this.jsonObject, this.otherAPI);
        } catch (Exception e) {
            return e.getMessage();
        }
    }

    private static String SendPostRequest(String apiUrl, Method method, JSONObject jsonObjSend, boolean otherAPI) throws JSONException, IOException, SimpleRequesterException {

        URL url;
        String returnStr = "";
        SingleUser singleUser = SingleUser.getInstance();

        try {
            url = new URL(apiUrl);
        } catch (MalformedURLException e) {
            throw new IllegalArgumentException("invalid url: " + apiUrl);
        }

        if (method == Method.POST) {

            HttpURLConnection conn = null;
            byte[] bytes = null;
            conn = (HttpURLConnection) url.openConnection();

            String body = "";
            if (jsonObjSend != null) {
                body = jsonObjSend.toString();
            }

            Logger.logDebug(TAG, body + "' to " + url);
            bytes = body.getBytes();
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setRequestProperty("app_token", singleUser.getApp_token());
            conn.setRequestProperty("user_token", singleUser.getUser_token());

            conn.setReadTimeout(10000);
            conn.setConnectTimeout(15000);
            conn.setRequestMethod(String.valueOf(method));
            conn.setDoInput(true);
            conn.setDoOutput(true);

            OutputStream out = conn.getOutputStream();
            out.write(bytes);
            out.close();

            int status = conn.getResponseCode();
            if (status != 200) {
                return MessageText.ERROR_SERVER.toString();
            }


            String convertStreamToString = "";
            if (conn != null) {
                convertStreamToString = convertStreamToString(conn.getInputStream(), /*HTTP.UTF_8*/"UTF-8");
                conn.disconnect();
            }
            returnStr = convertStreamToString;
            return convertStreamToString;
        } else if (method == Method.GET) {
            url = new URL(apiUrl);
            URLConnection urlConnection = url.openConnection();

            if (!otherAPI) {
                urlConnection.setRequestProperty("app_token", singleUser.getApp_token());
                urlConnection.setRequestProperty("user_token", singleUser.getUser_token());
                //urlConnection.setRequestProperty("Content-Type", "application/json");
            }

            StringBuilder stringBuilder = null;
            BufferedReader br = new BufferedReader(new InputStreamReader(urlConnection.getInputStream()));

            String inputLine;
            String jsonStr = "";
            while ((inputLine = br.readLine()) != null) {
                if (!otherAPI) {
                    jsonStr = inputLine;
                } else {
                    jsonStr += inputLine;
                }
            }
            br.close();

            returnStr = jsonStr;
            return jsonStr;
        } else{
            return returnStr;
        }
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
