package com.epitrack.guardioes.view;

import android.app.ProgressDialog;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.graphics.drawable.Drawable;
import android.os.AsyncTask;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.util.DisplayMetrics;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.epitrack.guardioes.R;
import com.epitrack.guardioes.model.DTO;
import com.epitrack.guardioes.model.SingleUser;
import com.epitrack.guardioes.request.Method;
import com.epitrack.guardioes.request.Requester;
import com.epitrack.guardioes.utility.BitmapUtility;
import com.epitrack.guardioes.utility.Constants;
import com.epitrack.guardioes.utility.Extension;
import com.epitrack.guardioes.utility.FileUtility;
import com.epitrack.guardioes.utility.MediaUtility;
import com.epitrack.guardioes.view.base.BaseFragment;
import com.epitrack.guardioes.view.diary.DiaryActivity;
import com.epitrack.guardioes.view.menu.profile.Avatar;
import com.epitrack.guardioes.view.survey.SelectParticipantActivity;
import com.epitrack.guardioes.view.tip.TipActivity;

import java.io.IOException;
import java.io.InputStream;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;
import java.util.concurrent.Executors;

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
    de.hdodenhof.circleimageview.CircleImageView imageViewPhoto;
    ////ImageView imageViewPhoto;

    @Override
    public void onCreate(final Bundle bundle) {
        super.onCreate(bundle);

        setDisplayTitle(false);
        setDisplayLogo(true);
    }

    @Nullable
    @Override
    public View onCreateView(final LayoutInflater inflater, final ViewGroup viewGroup, Bundle bundle) {

        final View view = inflater.inflate(R.layout.home_fragment, viewGroup, false);

        ButterKnife.bind(this, view);

        SingleUser singleUser = SingleUser.getInstance();

        String picture = singleUser.getPicture();

        String text = getString(R.string.message_hello);
        text = text.replace("{0}", singleUser.getNick());

        if (singleUser.getImageResource() == null) {
            singleUser.setImageResource("");
        }

        if (!singleUser.getImageResource().equals("")) {

            imageViewPhoto.setImageBitmap(BitmapUtility.scale(singleUser.getWidthImageProfile(), singleUser.getHeightImageProfile(), singleUser.getImageResource()));

        } else {

            new ImageUserAsyncTaskRunner().execute(picture);

            if (singleUser.getPicture().length() > 1) {
                singleUser.setPicture("0");
            }

            if (Integer.parseInt(singleUser.getPicture()) == 0) {

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
            } else {
                imageViewPhoto.setImageResource(Avatar.getBy(Integer.parseInt(singleUser.getPicture())).getLarge());
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

    private class ImageUserAsyncTaskRunner extends AsyncTask<String, Void, String> {

        private ProgressDialog progressDialog;

        @Override
        protected String doInBackground(String... imageUrl) {
            String saveImage = "";
            try {
                if (imageUrl[0].equals("")) {
                    return null;
                } else if (imageUrl[0].equals("0")) {
                    return null;
                }else{
                    String file = imageUrl[0];
                    String fileName[] = file.toString().split("/");

                    URL url = new URL(Requester.API_URL_PHOTO + imageUrl[0]);
                    URLConnection urlConnection = url.openConnection();

                    InputStream is = urlConnection.getInputStream();
                    Bitmap bitmap = BitmapFactory.decodeStream(is);

                    saveImage = FileUtility.save(getActivity().getApplicationContext(), fileName[fileName.length - 1], Extension.BITMAP, bitmap);
                    return saveImage;
                }
        } catch (MalformedURLException e) {
            return null;
        } catch (IOException e) {
            if (saveImage.equals("")) {
                return null;
            } else {
                return saveImage;
            }
        }
    }

        @Override
        protected void onPostExecute(String saveFile) {
            if (saveFile != null) {
                if (!saveFile.equals("")) {
                    int width = 0;
                    int height = 0;

                    DisplayMetrics metrics = getResources().getDisplayMetrics();
                    int densityDpi = (int) (metrics.density * 160f);

                    if (densityDpi == DisplayMetrics.DENSITY_LOW) {
                        width = 90;
                        height = 90;
                    } else if (densityDpi == DisplayMetrics.DENSITY_MEDIUM) {
                        width = 120;
                        height = 120;
                    } else if (densityDpi == DisplayMetrics.DENSITY_HIGH) {
                        width = 180;
                        height = 180;
                    } else if (densityDpi >= DisplayMetrics.DENSITY_XHIGH) {
                        width = 240;
                        height = 240;
                    }

                    if (width > 0 && height > 0) {
                        SingleUser.getInstance().setWidthImageProfile(width);
                        SingleUser.getInstance().setHeightImageProfile(height);
                        SingleUser.getInstance().setImageResource(saveFile);
                        imageViewPhoto.setImageBitmap(BitmapUtility.scale(width, height, saveFile));
                    }
                }
            }
            progressDialog.dismiss();
        }

        @Override
        protected void onPreExecute() {
            progressDialog = new ProgressDialog(getActivity());
            progressDialog.getWindow().setBackgroundDrawable(new ColorDrawable(Color.rgb(30, 136, 229)));
            progressDialog.setTitle(R.string.app_name);
            progressDialog.setMessage("Estamos atualizando seus dados...");
            progressDialog.show();
        }
    }
}
