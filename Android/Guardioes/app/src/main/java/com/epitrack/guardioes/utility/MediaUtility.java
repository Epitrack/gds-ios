package com.epitrack.guardioes.utility;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.drawable.Drawable;
import android.os.Environment;
import android.util.Log;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;

import twitter4j.HttpResponse;

/**
 * @author Igor Morais
 */
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

    public static Bitmap loadImageFromUrl(String imageUrl) {

        try {
            URL url = new URL(imageUrl);
            URLConnection urlConnection = url.openConnection();

            InputStream is = urlConnection.getInputStream();
            Bitmap bitmap = BitmapFactory.decodeStream(is);

            return bitmap;
        } catch (MalformedURLException e) {
            return null;
        } catch (IOException e) {
            return null;
        }
    }

}
