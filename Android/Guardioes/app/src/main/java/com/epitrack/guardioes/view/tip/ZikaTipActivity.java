package com.epitrack.guardioes.view.tip;

import android.os.Bundle;
import android.widget.TextView;

import com.epitrack.guardioes.R;
import com.epitrack.guardioes.view.base.BaseAppCompatActivity;

import butterknife.Bind;

/**
 * @author Miqueias Lopes
 */
public class ZikaTipActivity extends BaseAppCompatActivity {

    @Bind(R.id.zika_content)
    TextView zikaContent;

    @Override
    protected void onCreate(final Bundle bundle) {
        super.onCreate(bundle);

        setContentView(R.layout.zika_info);

        String text = zikaContent.getText().toString();
        zikaContent.setText(text.replace("+", "%"));

    }
}