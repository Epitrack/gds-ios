package com.epitrack.guardioes.view;

import android.graphics.Color;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.epitrack.guardioes.R;

import java.util.Random;

/**
 * Created by IgorMorais on 6/5/15.
 */
public class WelcomePageFragment extends Fragment {

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup viewGroup, Bundle bundle) {

        View view = inflater.inflate(R.layout.about_fragment, viewGroup, false);

        // Temp..
        Random random = new Random();
        final int color = Color.argb(255, random.nextInt(256), random.nextInt(256), random.nextInt(256));

        view.setBackgroundColor(color);

        return view;
    }
}
