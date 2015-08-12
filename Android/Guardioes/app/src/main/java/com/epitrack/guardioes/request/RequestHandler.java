package com.epitrack.guardioes.request;

import com.epitrack.guardioes.BuildConfig;
import com.epitrack.guardioes.utility.Logger;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.koushikdutta.async.future.FutureCallback;

import java.io.IOException;

class RequestHandler<T> implements FutureCallback<String> {

    private static final String TAG = RequestHandler.class.getSimpleName();
    
    private final ObjectMapper mapper = new ObjectMapper();

    private final RequestListener<T> listener;

    public RequestHandler(final RequestListener listener) {
        this.listener = listener;
    }

    @Override
    public void onCompleted(final Exception error, final String json) {

        if (error == null) {

            if (json == null) {

                listener.onSuccess(null);

            } else {

                if (BuildConfig.DEBUG) {
                    Logger.logDebug(TAG, json);
                }

                try {

                    final T entity = mapper.readValue(json, new TypeReference<T>() {

                    });

                    listener.onSuccess(entity);

                } catch (IOException e) {

                    if (BuildConfig.DEBUG) {
                        Logger.logDebug(TAG, e.getMessage());
                    }

                    listener.onError(e);
                }
            }

        } else {

            if (BuildConfig.DEBUG) {
                Logger.logDebug(TAG, error.getMessage());
            }

            listener.onError(error);
        }
    }
}
