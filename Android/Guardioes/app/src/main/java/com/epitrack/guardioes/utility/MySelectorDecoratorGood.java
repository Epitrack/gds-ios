package com.epitrack.guardioes.utility;

import android.app.Activity;
import android.graphics.drawable.Drawable;

import com.epitrack.guardioes.R;
import com.prolificinteractive.materialcalendarview.CalendarDay;
import com.prolificinteractive.materialcalendarview.DayViewDecorator;
import com.prolificinteractive.materialcalendarview.DayViewFacade;

import java.util.ArrayList;

/**
 * @author Miqueias Lopes
 */
public class MySelectorDecoratorGood implements DayViewDecorator {

    private Drawable drawable = null;
    private ArrayList<Integer> days;

    public MySelectorDecoratorGood(Activity context, ArrayList<Integer> days) {
        drawable = context.getResources().getDrawable(R.drawable.my_selector_good);
        this.days = days;
    }

    @Override
    public boolean shouldDecorate(CalendarDay day) {
        if (days.size() > 0) {
            for (int i = 0; i < days.size(); i++) {
                if (days.get(i) == day.getDay()) {
                    return true;
                }
            }
        }
        return false;
    }

    @Override
    public void decorate(DayViewFacade view) {
        view.setSelectionDrawable(drawable);
    }

}
