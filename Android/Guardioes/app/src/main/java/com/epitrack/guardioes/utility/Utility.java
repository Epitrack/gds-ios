package com.epitrack.guardioes.utility;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

public final class Utility {

    private static final String TAG = Utility.class.getSimpleName();

    private Utility() {

    }

    public static <T> void print(final T entity) {

        try {

            final String json = new ObjectMapper().writeValueAsString(entity);

            Logger.logDebug(TAG, json);

        } catch (JsonProcessingException e) {
            Logger.logError(TAG, e.getMessage());
        }
    }
}
