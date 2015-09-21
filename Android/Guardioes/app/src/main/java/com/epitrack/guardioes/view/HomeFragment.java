package com.epitrack.guardioes.view;

import android.os.Bundle;
import android.support.annotation.Nullable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.epitrack.guardioes.R;
import com.epitrack.guardioes.model.SingleUser;
import com.epitrack.guardioes.view.base.BaseFragment;
import com.epitrack.guardioes.view.diary.DiaryActivity;
import com.epitrack.guardioes.view.survey.SelectParticipantActivity;
import com.epitrack.guardioes.view.tip.TipActivity;

import butterknife.Bind;
import butterknife.ButterKnife;
import butterknife.OnClick;

/**
 * @author Igor Morais
 */
public class HomeFragment extends BaseFragment {

    @Bind(R.id.text_view_name)
    TextView textViewName;

    @Bind(R.id.image_view_photo)
    ImageView imageViewPhoto;


    @Override
    public void onCreate(final Bundle bundle) {
        super.onCreate(bundle);

        setDisplayTitle(false);
        setDisplayLogo(true);
    }

    @Nullable
    @Override
    public View onCreateView(final LayoutInflater inflater, final ViewGroup viewGroup, final Bundle bundle) {

        final View view = inflater.inflate(R.layout.home_fragment, viewGroup, false);

        ButterKnife.bind(this, view);

        SingleUser singleUser = SingleUser.getInstance();

        String text = getString(R.string.message_hello);
        text = text.replace("{0}", singleUser.getNick());

        if (singleUser.getGender().equals("M")) {

            if (singleUser.getRace().equals("branco") || singleUser.getRace().equals("amarelo")) {
                imageViewPhoto.setImageResource(R.drawable.image_avatar_6);
            } else {
                imageViewPhoto.setImageResource(R.drawable.image_avatar_4);
            }
        } else {

            if (singleUser.getRace().equals("branco") || singleUser.getRace().equals("amarelo")) {
                imageViewPhoto.setImageResource(R.drawable.image_avatar_8);
            } else {
                imageViewPhoto.setImageResource(R.drawable.image_avatar_7);
            }
        }


        textViewName.setText(text);

        return view;
    }

    @OnClick(R.id.text_view_notice)
    public void onNews() {
        navigateTo(NoticeActivity.class);
    }

    @OnClick(R.id.text_view_map)
    public void onMap() {
        navigateTo(MapSymptomActivity.class);
    }

    @OnClick(R.id.text_view_tip)
    public void onTip() {
        navigateTo(TipActivity.class);
    }

    @OnClick(R.id.text_view_diary)
    public void onDiary() {
        navigateTo(DiaryActivity.class);
    }

    @OnClick(R.id.text_view_join)
    public void onJoin() {
        navigateTo(SelectParticipantActivity.class);
    }
}
