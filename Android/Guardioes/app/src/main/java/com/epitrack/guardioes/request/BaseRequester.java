package com.epitrack.guardioes.request;

import android.content.Context;

import com.fasterxml.jackson.databind.ObjectMapper;

import org.apache.http.NameValuePair;

class BaseRequester {

    private final Context context;

    private ObjectMapper mapper;

    public BaseRequester(final Context context) {
        this.context = context;
    }

    public final Context getContext() {
        return context;
    }

    public final ObjectMapper getMapper() {

        if (mapper == null) {
            mapper = new ObjectMapper();
        }

        return mapper;
    }

    public String toQuery(final NameValuePair... nameValueArray) {

        final StringBuilder builder = new StringBuilder();

        for (final NameValuePair nameValue : nameValueArray) {

            builder.append(nameValue.getName()).append("=").append(nameValue.getValue()).append('&');
        }

        builder.deleteCharAt(builder.length() - 1);

        return builder.toString();
    }
}
