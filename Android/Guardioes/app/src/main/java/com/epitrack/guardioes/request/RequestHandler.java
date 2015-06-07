package com.epitrack.guardioes.request;

import android.content.Context;

import com.android.volley.RequestQueue;
import com.android.volley.toolbox.Volley;

public class RequestHandler {

    private static RequestHandler requestHandler;

    private final RequestQueue queue;

    private RequestHandler(final Context context) {
        queue = Volley.newRequestQueue(context);
    }

    public static RequestHandler getInstance(final Context context) {

        if (requestHandler == null) {
            requestHandler = new RequestHandler(context.getApplicationContext());
        }

        return requestHandler;
    }


    public final RequestQueue getQueue() {
        return queue;
    }
}
