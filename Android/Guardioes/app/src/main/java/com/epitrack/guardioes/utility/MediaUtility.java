package com.epitrack.guardioes.utility;

import android.os.Environment;

import java.io.File;
import java.io.IOException;

public final class MediaUtility {

    private static final String TAG = MediaUtility.class.getSimpleName();

    private MediaUtility() {

    }

    public static File createTempFile(final String name, final Extension extension, final String environment) {

        try {

            final File directory = Environment.getExternalStoragePublicDirectory(environment);

            return File.createTempFile(name, extension.getName(), directory);

        } catch (final IOException e) {
            Logger.logError(TAG, e.getMessage());
        }

        return null;
    }
}
