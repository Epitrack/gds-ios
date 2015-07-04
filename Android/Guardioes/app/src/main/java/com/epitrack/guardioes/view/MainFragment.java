package com.epitrack.guardioes.view;

import android.os.Bundle;
import android.support.annotation.Nullable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.epitrack.guardioes.R;

import butterknife.ButterKnife;
import butterknife.InjectView;

public class MainFragment extends BaseFragment {

    @InjectView(R.id.main_fragment_text_view_name)
    TextView textViewName;

    @Nullable
    @Override
    public View onCreateView(final LayoutInflater inflater, final ViewGroup viewGroup, final Bundle bundle) {

        final View view = inflater.inflate(R.layout.main_fragment, viewGroup, false);

        ButterKnife.inject(this, view);

        String text = getString(R.string.main_fragment_name_message);
        text = text.replace("{0}", "Renatinder");

        textViewName.setText(text);

        return view;
    }

//    @OnClick(R.id.menu_fragment_button_news)
//    public void onNews() {
//        navigateTo(NewsActivity.class);
//    }
//
//    @OnClick(R.id.menu_fragment_button_map)
//    public void onMap() {
//        navigateTo(MapActivity.class);
//    }
//
//    @OnClick(R.id.menu_fragment_button_tip)
//    public void onTip() {
//        navigateTo(TipActivity.class);
//    }
//
//    @OnClick(R.id.menu_fragment_button_diary)
//    public void onDiary() {
//        navigateTo(DiaryActivity.class);
//    }
//
//    @OnClick(R.id.menu_fragment_button_join)
//    public void onJoin() {
//        navigateTo(SelectParticipantActivity.class);
//    }

    @Override
    public void onDestroyView() {
        super.onDestroyView();

        ButterKnife.reset(this);
    }
}
