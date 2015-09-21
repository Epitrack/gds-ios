package com.epitrack.guardioes.view.diary;

import android.graphics.Color;
import android.graphics.Typeface;
import android.os.Bundle;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.epitrack.guardioes.R;
import com.epitrack.guardioes.model.SingleUser;
import com.epitrack.guardioes.model.User;
import com.epitrack.guardioes.request.Method;
import com.epitrack.guardioes.request.Requester;
import com.epitrack.guardioes.request.SimpleRequester;
import com.epitrack.guardioes.view.base.BaseAppCompatActivity;
import com.epitrack.guardioes.view.survey.ParentListener;
import com.github.mikephil.charting.animation.Easing;
import com.github.mikephil.charting.charts.PieChart;
import com.github.mikephil.charting.data.Entry;
import com.github.mikephil.charting.data.PieData;
import com.github.mikephil.charting.data.PieDataSet;
import com.github.mikephil.charting.formatter.PercentFormatter;
import com.github.mikephil.charting.utils.ColorTemplate;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ExecutionException;

import butterknife.Bind;

/**
 * @author Igor Morais
 */
public class DiaryActivity extends BaseAppCompatActivity implements ParentListener {

    @Bind(R.id.text_view_participation)
    TextView textViewParticipation;

    @Bind(R.id.text_view_good_percentage)
    TextView textViewGoodPercentage;

    @Bind(R.id.text_view_good_report)
    TextView textViewGoodReport;

    @Bind(R.id.text_view_bad_percentage)
    TextView textViewBadPercentage;

    @Bind(R.id.text_view_bad_report)
    TextView textViewBadReport;

    @Bind(R.id.text_view_day)
    TextView textViewDay;

    @Bind(R.id.text_view_date)
    TextView textViewDate;

    @Bind(R.id.text_view_symptom)
    TextView textViewSymptom;

    @Bind(R.id.recycler_view)
    RecyclerView recyclerView;

    @Bind(R.id.pie_chart_diary)
    PieChart pieChart;

    private double goodCount = 0;
    private double badCount = 0;
    private double totalCount = 0;

    SingleUser singleUser = SingleUser.getInstance();

    @Override
    protected void onCreate(final Bundle bundle) {
        super.onCreate(bundle);

        setContentView(R.layout.diary);

        recyclerView.setHasFixedSize(true);

        recyclerView.setLayoutManager(new LinearLayoutManager(this, LinearLayoutManager.HORIZONTAL, false));

        //final List<MemberAdapter.Parent> parentList = new ArrayList<>();
        final List<User> parentList = new ArrayList<>();

        SimpleRequester simpleRequester = new SimpleRequester();
        simpleRequester.setUrl(Requester.API_URL + "user/household/" + singleUser.getId());
        simpleRequester.setJsonObject(null);
        simpleRequester.setMethod(Method.GET);

        parentList.add(new User(R.drawable.image_avatar_small_8, singleUser.getNick(),
                singleUser.getEmail(), singleUser.getId(),
                singleUser.getDob(), singleUser.getRace(),
                singleUser.getGender()));

        try {
            String jsonStr = simpleRequester.execute(simpleRequester).get();

            JSONObject jsonObject = new JSONObject(jsonStr);

            if (jsonObject.get("error").toString() == "false") {

                JSONArray jsonArray = jsonObject.getJSONArray("data");

                if (jsonArray.length() > 0) {

                    JSONObject jsonObjectHousehold;

                    for (int i = 0; i < jsonArray.length(); i++) {

                        jsonObjectHousehold = jsonArray.getJSONObject(i);
                        parentList.add(new User(R.drawable.image_avatar_small_8, jsonObjectHousehold.get("nick").toString(),
                                /*jsonObjectHousehold.get("email").toString()*/"", jsonObjectHousehold.get("id").toString(),
                                jsonObjectHousehold.get("dob").toString(), jsonObjectHousehold.get("race").toString(),
                                jsonObjectHousehold.get("gender").toString()));
                    }
                }
            }

        } catch (InterruptedException e) {
            e.printStackTrace();
        } catch (ExecutionException e) {
            e.printStackTrace();
        } catch (JSONException e) {
            e.printStackTrace();
        }

        recyclerView.setAdapter(new MemberAdapter(getApplicationContext(), this, parentList));

        setupView();
    }

    private void setupView() {

        SimpleRequester simpleRequester = new SimpleRequester();
        simpleRequester.setUrl(Requester.API_URL + "user/survey/summary");
        simpleRequester.setJsonObject(null);
        simpleRequester.setMethod(Method.GET);

        String jsonStr = null;
        try {
            jsonStr = simpleRequester.execute(simpleRequester).get();

            JSONObject jsonObject = new JSONObject(jsonStr);
            JSONObject jsonObjectSympton = jsonObject.getJSONObject("data");

            goodCount = Integer.parseInt(jsonObjectSympton.get("no_symptom").toString());
            badCount = Integer.parseInt(jsonObjectSympton.get("symptom").toString());
            totalCount = Integer.parseInt(jsonObjectSympton.get("total").toString());

            textViewParticipation.setText((int)totalCount +  " Participações");

            double goodPercent = goodCount / totalCount;
            textViewGoodPercentage.setText((int)(goodPercent * 100) + "% Bem");
            textViewGoodReport.setText((int)goodCount  + " Relatórios");

            double badPercent = badCount / totalCount;
            textViewBadPercentage.setText((int)(badPercent * 100) + "% Mal");
            textViewBadReport.setText((int) badCount + " Relatórios");

           /* pieChart.setUsePercentValues(true);
            pieChart.setDescription("");
            pieChart.setDragDecelerationFrictionCoef(0.95f);
            pieChart.setDrawHoleEnabled(true);
            pieChart.setHoleColorTransparent(true);
            pieChart.setTransparentCircleColor(Color.WHITE);
            pieChart.setTransparentCircleAlpha(100);
            pieChart.setHoleRadius(58f);
            pieChart.setTransparentCircleRadius(61f);
            //pieChart.setDrawCenterText(true);
            pieChart.setRotationAngle(0);
            pieChart.setRotationEnabled(true);*/

            //pieChart.setLayoutParams(new LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT, 0.5f));
            pieChart.setHoleRadius(60f);
            pieChart.setDrawCenterText(false);
            pieChart.setHoleColorTransparent(false);
            pieChart.setDrawHoleEnabled(true);
            pieChart.setUsePercentValues(false);
            pieChart.setHoleColor(Color.WHITE);

            setData();

        } catch (InterruptedException e) {
            e.printStackTrace();
        } catch (ExecutionException e) {
            e.printStackTrace();
        } catch (JSONException e) {
            e.printStackTrace();
        }


        //textViewDay.setText("Sexta-feira");
        //textViewDate.setText("15 de maio");
        //textViewSymptom.setText("7 Sintomas");
    }

    @Override
    public void onParentSelect(String id) {

    }

    private void setData() {

        float[] yData = { (int)badCount, (int)goodCount };
        String[] xData = { "Mal", "Bem" };

        ArrayList<Entry> yVals1 = new ArrayList<Entry>();

        for (int i = 0; i < yData.length; i++)
            yVals1.add(new Entry(yData[i], i));

        ArrayList<String> xVals = new ArrayList<String>();

        for (int i = 0; i < xData.length; i++)
            xVals.add(xData[i]);

        // create pie data set
        PieDataSet dataSet = new PieDataSet(yVals1, "");
        dataSet.setSliceSpace(2);
        dataSet.setSelectionShift(2);

        // add many colors
        int colors[] = {Color.parseColor("#FF0000"),Color.parseColor("#CCCC00")
        };
        /*ArrayList<Integer> colors = new ArrayList<Integer>();

        for (int c : ColorTemplate.VORDIPLOM_COLORS)
            colors.add(c);

        for (int c : ColorTemplate.JOYFUL_COLORS)
            colors.add(c);

        for (int c : ColorTemplate.COLORFUL_COLORS)
            colors.add(c);

        for (int c : ColorTemplate.LIBERTY_COLORS)
            colors.add(c);

        for (int c : ColorTemplate.PASTEL_COLORS)
            colors.add(c);

        colors.add(ColorTemplate.getHoloBlue());*/
        dataSet.setColors(colors);

        // instantiate pie data object now
        PieData data = new PieData(xVals, dataSet);
        data.setValueFormatter(new PercentFormatter());
        data.setValueTextSize(14f);
        data.setValueTextColor(R.color.grey_dark);

        pieChart.setData(data);
        pieChart.highlightValues(null);
        pieChart.invalidate();
    }
}
