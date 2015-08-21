package com.epitrack.guardioes.view.survey;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.ListView;

import com.afollestad.materialdialogs.MaterialDialog;
import com.epitrack.guardioes.R;
import com.epitrack.guardioes.model.Symptom;
import com.epitrack.guardioes.utility.Constants;
import com.epitrack.guardioes.utility.DialogBuilder;
import com.epitrack.guardioes.view.BaseAppCompatActivity;

import butterknife.Bind;

public class SymptomActivity extends BaseAppCompatActivity {

    @Bind(R.id.list_view)
    ListView listView;

    @Override
    protected void onCreate(final Bundle bundle) {
        super.onCreate(bundle);

        setContentView(R.layout.symptom);

        final View footerView = LayoutInflater.from(this).inflate(R.layout.symptom_footer, null);

        footerView.findViewById(R.id.button_confirm).setOnClickListener(new View.OnClickListener() {

            @Override
            public void onClick(final View view) {

                new DialogBuilder(SymptomActivity.this).load()
                        .title(R.string.attention)
                        .content(R.string.message_register_info)
                        .negativeText(R.string.no)
                        .positiveText(R.string.yes)
                        .callback(new MaterialDialog.ButtonCallback() {

                            @Override
                            public void onPositive(final MaterialDialog dialog) {

                                final Bundle bundle = new Bundle();
                                bundle.putBoolean(Constants.Intent.BAD_STATE, true);

                                navigateTo(ShareActivity.class, bundle);
                            }

                        }).show();
            }
        });

        listView.addFooterView(footerView);

        listView.setAdapter(new SymptomAdapter(this, Symptom.values()));
    }
}
