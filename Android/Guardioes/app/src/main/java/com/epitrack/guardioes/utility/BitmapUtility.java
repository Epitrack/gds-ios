package com.epitrack.guardioes.utility;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.graphics.PorterDuff;
import android.graphics.PorterDuffXfermode;
import android.graphics.Rect;

import java.io.ByteArrayOutputStream;

public final class BitmapUtility {

    public static final int QUALITY = 100;

    private BitmapUtility() {

    }

    public static byte[] toByteArray(final Bitmap bitmap) {

        final ByteArrayOutputStream output = new ByteArrayOutputStream();

        bitmap.compress(Bitmap.CompressFormat.PNG, 100, output);

        bitmap.recycle();

        return output.toByteArray();
    }

    public static int getSampleSize(final int reqWidth, final int reqHeight, final BitmapFactory.Options option) {

        int sampleSize = 1;

        int width = option.outWidth;
        int height = option.outHeight;

        if (width > reqWidth || height > reqHeight) {

            width = width / 2;
            height = height / 2;

            while ((height / sampleSize) > reqHeight && (width / sampleSize) > reqWidth) {
                sampleSize *= 2;
            }
        }

        return sampleSize;
    }

    public static Bitmap scale (final int width, final int height, final String path) {

        final BitmapFactory.Options option = new BitmapFactory.Options();

        option.inJustDecodeBounds = true;

        BitmapFactory.decodeFile(path, option);

        option.inSampleSize = Math.min(option.outWidth / width, option.outHeight / height);

        option.inJustDecodeBounds = false;

        return BitmapFactory.decodeFile(path, option);
    }

    public static Bitmap round(final Bitmap bitmap) {

        final Bitmap round = Bitmap.createBitmap(bitmap.getWidth(),
                                                 bitmap.getHeight(),
                                                 Bitmap.Config.ARGB_8888);

        final Paint paint = new Paint();

        paint.setAntiAlias(true);
        paint.setDither(true);
        paint.setFilterBitmap(true);

        final Canvas canvas = new Canvas(round);

        canvas.drawCircle(bitmap.getWidth() / 2 + 0.7f,
                          bitmap.getHeight() / 2 + 0.7f,
                          bitmap.getWidth() / 2 + 0.1f,
                          paint);

        final Rect rect = new Rect(0,
                                   0,
                                   bitmap.getWidth(),
                                   bitmap.getHeight());

        paint.setXfermode(new PorterDuffXfermode(PorterDuff.Mode.SRC_IN));

        canvas.drawBitmap(bitmap,
                          rect,
                          rect,
                          paint);

        return round;
    }
}
