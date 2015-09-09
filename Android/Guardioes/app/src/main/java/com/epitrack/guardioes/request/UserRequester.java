package com.epitrack.guardioes.request;

import android.content.Context;

import com.epitrack.guardioes.model.User;

import java.util.HashMap;
import java.util.Map;

/**
 * @author Miquéias Lopes on 09/09/15.
 */
public class UserRequester extends Requester {

    public UserRequester(final Context context) {
        super(context);
    }

    public void requestUser(Method method, final Map<String, String> bodyMap, String url,  RequestListener<User> listener) {

        Map<String, String> headerMap = new HashMap<>();

        headerMap.put("Accept", "application/json");
        headerMap.put("Content-type", "application/json");
        headerMap.put("app_token", "d41d8cd98f00b204e9800998ecf8427e");

        request(method, Requester.API_URL + url, null, headerMap, bodyMap, listener);
    }

}
