package com.epitrack.guardioes.view;

import android.os.Bundle;
import android.support.annotation.Nullable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.epitrack.guardioes.R;

import butterknife.ButterKnife;
import butterknife.OnClick;

public class MenuFragment extends BaseFragment {

    @Nullable
    @Override
    public View onCreateView(final LayoutInflater inflater, final ViewGroup viewGroup, final Bundle bundle) {

        final View view = inflater.inflate(R.layout.menu_fragment, viewGroup, false);

        ButterKnife.inject(this, view);

        return view;
    }

    @OnClick(R.id.menu_fragment_button_news)
    public void onNews() {
        navigateTo(NewsActivity.class);
    }

    @OnClick(R.id.menu_fragment_button_map)
    public void onMap() {
        navigateTo(MapActivity.class);
    }

    @OnClick(R.id.menu_fragment_button_tip)
    public void onTip() {
        navigateTo(TipActivity.class);
    }

    @OnClick(R.id.menu_fragment_button_diary)
    public void onDiary() {
        navigateTo(DiaryActivity.class);
    }

    @OnClick(R.id.menu_fragment_button_join)
    public void onJoin() {
        navigateTo(SelectParticipantActivity.class);
    }

    @Override
    public void onDestroyView() {
        super.onDestroyView();

        ButterKnife.reset(this);
    }
}
