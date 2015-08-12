package com.epitrack.guardioes.utility;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

public final class Utility {

    private static final String TAG = Utility.class.getSimpleName();

    private Utility() {

    }

    public static <T> void print(final T entity) {

        try {

            Logger.logDebug(TAG, new ObjectMapper().writeValueAsString(entity));

        } catch (JsonProcessingException e) {
            Logger.logError(TAG, e.getMessage());
        }
    }
}
