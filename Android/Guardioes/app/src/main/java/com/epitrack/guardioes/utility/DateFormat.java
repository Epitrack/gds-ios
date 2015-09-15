package com.epitrack.guardioes.utility;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

/**
 * @author Miquéias Lopes on 12/09/15.
 */
public final class DateFormat {

    public static String getDate(String date, String format) {

        SimpleDateFormat userFormat = new SimpleDateFormat(format);
        SimpleDateFormat apiFormat = new SimpleDateFormat("yyyy-MM-dd");
        String strReturn = "";

        try {
            Date userDate = apiFormat.parse(date);
            strReturn = userFormat.format(userDate);
        } catch (ParseException e) {
            e.printStackTrace();
        } finally {
            return strReturn;
        }
    }

    public static String getDate(String date) {

        SimpleDateFormat userFormat = new SimpleDateFormat("dd/MM/yyyy");
        SimpleDateFormat apiFormat = new SimpleDateFormat("yyyy-MM-dd");
        String strReturn = "";

        try {
            Date userDate = userFormat.parse(date);
            strReturn = apiFormat.format(userDate);
        } catch (ParseException e) {
            e.printStackTrace();
        } finally {
            return strReturn;
        }
    }

    public static int getDateDiff(String date) {

        SimpleDateFormat userFormat = new SimpleDateFormat("yyyy");
        Calendar calendar = Calendar.getInstance();
        int year = calendar.get(Calendar.YEAR);

        Date userDate = null;
        int diffDate = -1;

        try {
            userDate = userFormat.parse(date);
            diffDate = year - Integer.parseInt(userFormat.format(userDate).toString());
        } catch (ParseException e) {
            e.printStackTrace();
        }

        return diffDate;
    }
}
