package com.epitrack.guardioes.view.menu.help;

import android.content.Intent;
import android.os.Bundle;
import android.view.MenuItem;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

import com.afollestad.materialdialogs.MaterialDialog;
import com.epitrack.guardioes.R;
import com.epitrack.guardioes.utility.DialogBuilder;
import com.epitrack.guardioes.view.HomeActivity;
import com.epitrack.guardioes.view.base.BaseAppCompatActivity;

import butterknife.Bind;
import butterknife.OnClick;

/**
 * Created by @Miqueias Lopes on 17/10/15.
 */
public class Report extends BaseAppCompatActivity {

    @Bind(R.id.txt_report_subject)
    EditText txtSubject;

    @Bind(R.id.report_message)
    EditText txtMessage;

    @Bind(R.id.button_send_email)
    Button buttonSendEmail;

    @Override
    public void onCreate(Bundle bundle) {
        super.onCreate(bundle);

        setContentView(R.layout.report);
    }

    @OnClick(R.id.button_send_email)
    public void sendEmail() {

        boolean isError = false;

        if (txtSubject.getText().toString().trim() == "") {
            isError = true;
        } else if (txtMessage.getText().toString().trim() == "") {
            isError = true;
        }

        if (!isError) {
            new DialogBuilder(Report.this).load()
                    .title(R.string.attention)
                    .content(R.string.email_null)
                    .positiveText(R.string.ok)
                    .show();
        } else {
            Intent i = new Intent(Intent.ACTION_SEND);
            i.setType("message/rfc822");
            i.putExtra(Intent.EXTRA_EMAIL  , new String[]{"contato@epitrack.com.br"});
            i.putExtra(Intent.EXTRA_SUBJECT, txtSubject.getText().toString().trim());
            i.putExtra(Intent.EXTRA_TEXT, txtMessage.getText().toString().trim());
            try {
                startActivity(Intent.createChooser(i, "Enviando email..."));
            } catch (android.content.ActivityNotFoundException ex) {
                Toast.makeText(Report.this, "There are no email clients installed.", Toast.LENGTH_SHORT).show();
            }
        }
    }

    @Override
    public boolean onOptionsItemSelected(final MenuItem item) {

        if (item.getItemId() == android.R.id.home) {
            onBackPressed();

        } else {
            super.onOptionsItemSelected(item);
        }
        return true;
    }

}
