package com.epitrack.guardioes.utility;

import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.graphics.PorterDuff;
import android.graphics.PorterDuffXfermode;
import android.graphics.Rect;

public final class BitmapUtility {

    private BitmapUtility() {

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
