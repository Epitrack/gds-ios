package com.epitrack.guardioes.request;

import android.content.Context;

import com.android.volley.RequestQueue;
import com.android.volley.toolbox.Volley;

public final class RequestHandler {

    private static RequestHandler requestHandler;

    private final RequestQueue queue;

    private RequestHandler(final Context context) {
        queue = setupQueue(context.getApplicationContext());
    }

    public static RequestHandler getRequestHandler(final Context context) {

        if (requestHandler == null) {
            requestHandler = new RequestHandler(context);
        }

        return requestHandler;
    }

    private RequestQueue setupQueue(final Context context) {
        return Volley.newRequestQueue(context);
    }

    public final RequestQueue getQueue() {
        return queue;
    }
}
