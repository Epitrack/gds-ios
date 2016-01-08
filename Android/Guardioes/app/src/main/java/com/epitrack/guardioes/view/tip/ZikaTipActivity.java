package com.epitrack.guardioes.view.tip;

import android.os.Bundle;
import android.text.Html;
import android.widget.TextView;

import com.epitrack.guardioes.R;
import com.epitrack.guardioes.service.AnalyticsApplication;
import com.epitrack.guardioes.view.base.BaseAppCompatActivity;
import com.google.android.gms.analytics.Tracker;

import butterknife.Bind;

/**
 * @author Miqueias Lopes
 */
public class ZikaTipActivity extends BaseAppCompatActivity {

    @Bind(R.id.zika_content)
    TextView zikaContent;

    private Tracker mTracker;

    @Override
    protected void onCreate(final Bundle bundle) {
        super.onCreate(bundle);

        setContentView(R.layout.zika_info);

        // [START shared_tracker]
        // Obtain the shared Tracker instance.
        AnalyticsApplication application = (AnalyticsApplication) getApplication();
        mTracker = application.getDefaultTracker();
        // [END shared_tracker]


        zikaContent.setText(Html.fromHtml("<p>&nbsp;&nbsp;&#8226;&nbsp;Os vírus da Dengue, Zika e Chikungunya são transmitidos pelo mosquito <i>Aedes aegypti</i> e apresentam sinais e sintomas parecidos.</p>\n" +
                "\n" +
                "<p>&nbsp;&nbsp;&#8226;&nbsp;É importante que você procure o serviço de saúde mais próximo quando apresentar febre, manchas vermelhas pelo corpo seguida de febre, dores no corpo, dor nas juntas (articulações) ou coceira.</p>\n" +
                "\n" +
                "<p>&nbsp;&nbsp;&#8226;&nbsp;As infecções pelos vírus Zika e Chikungunya começaram a ocorrer no Brasil nos últimos dois anos.</p>\n" +
                "\n" +
                "<p>&nbsp;&nbsp;&#8226;&nbsp;Procure informações sobre a ocorrência de casos de Dengue, Zika ou Chikungunya no seu bairro ou cidade.</p>\n" +
                "\n" +
                "<p>&nbsp;&nbsp;&#8226;&nbsp;No caso da infecção pelo vírus Zika, a maior parte das pessoas (mais de 80%), não ficarão doentes ou apresentarão sinais e sintomas.</p>\n" +
                "\n" +
                "<p>&nbsp;&nbsp;&#8226;&nbsp;É muito raro acontecer complicações devido infecção pelo vírus Zika, como a síndrome neurológica (exemplo: síndrome de Guillain-Barré) ou malformações congênitas (ex.: microcefalia).</p>\n" +
                "\n" +
                "<p>&nbsp;&nbsp;&#8226;&nbsp;Não existe tratamento específico para a infecção pelo vírus Zika.</p>\n" +
                "\n" +
                "<p>&nbsp;&nbsp;&#8226;&nbsp;Não se recomenda o uso de medicamentos sem prescrição médica, em função do risco aumentado de complicações hemorrágicas (sangramento).</p>\n" +
                "\n" +
                "<p>&nbsp;&nbsp;&#8226;&nbsp;Não se deve utilizar os medicamentos a base de ácido acetilsalicílico (ex.: AAS, Aspirina entre outros), nem anti-inflamatórios.</p>\n" +
                "\n" +
                "<p>&nbsp;&nbsp;&#8226;&nbsp;A principal medida de prevenção é evitar a reprodução dos mosquitos, evitando deixar água parada em pratinhos de plantas, jogando o lixo na lixeira, tampando as caixas de água e outros recipientes.</p>\n" +
                "\n" +
                "<p><b>Repelentes:</b></p>\n" +
                "\n" +
                "<p>&nbsp;&nbsp;&#8226;&nbsp;Os repelentes para uso sobre a pele podem ser utilizados por gestantes, desde que estejam devidamente registrados na ANVISA e que sejam seguidas as instruções de uso descritas no rótulo.</p>\n" +
                "<p>&nbsp;&nbsp;&#8226;&nbsp;Produtos à base de DEET não devem ser usados em crianças menores de 2 anos. Em crianças entre 2 e 12 anos, a concentração dever ser no máximo 10% e a aplicação deve se restringir a 3 vezes por dia. Concentrações superiores a 10% são permitidas para maiores de 12 anos.</p>\n" +
                "<p>&nbsp;&nbsp;&#8226;&nbsp;Os repelentes de ambiente, como aqueles de parede (aparelhos elétricos) ou espirais não devem ser utilizados em locais com pouca ventilação nem na presença de pessoas asmáticas ou com alergias respiratórias; podendo ser utilizados em qualquer ambiente da casa desde que estejam no mínimo a 2 metros de distância das pessoas.</p>"));
    }
}