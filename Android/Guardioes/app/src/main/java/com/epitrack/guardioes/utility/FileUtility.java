package com.epitrack.guardioes.utility;

import android.content.Context;
import android.graphics.Bitmap;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;

public final class FileUtility {

    private static final String TAG = FileUtility.class.getSimpleName();

    private FileUtility() {

    }

    public static String save(final Context context, final String name, final Extension extension, final Bitmap bitmap) {

        final File file = new File(context.getFilesDir(), name + extension.getName());

        try {

            final FileOutputStream output = new FileOutputStream(file);

            output.write(BitmapUtility.toByteArray(bitmap));

            output.close();

        } catch (final IOException e) {
            Logger.logError(TAG, e.getMessage());

            return null;
        }

        return file.getAbsolutePath();
    }
}
